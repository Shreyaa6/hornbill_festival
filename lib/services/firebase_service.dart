import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/app_data.dart';
import '../models/hotel.dart';
import '../models/user_model.dart';
import '../data/mock_user.dart';

import '../data/cafes_data.dart';
import '../data/contests_data.dart';
import '../data/nagaland_data.dart';
import '../data/hotels_data.dart';
import '../data/landmarks_data.dart';
import '../data/rooms_data.dart';
import '../data/taxis_data.dart';
import '../models/hotel_room.dart';
import '../models/landmark.dart';
import '../models/stall.dart';
import '../models/tribe.dart';
import '../models/calendar_event.dart';
import 'offline_data_service.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _firestore;

  // 1. CAROUSEL STREAM (Home banner slider)
  Stream<List<String>> getCarouselBanners() {
    try {
      return _firestore
          .collection('carousel')
          .snapshots()
          .map((snapshot) {
            final docs = snapshot.docs.toList();
            docs.sort((a, b) {
              final idA = (a.data()['id'] as num?)?.toInt() ?? 0;
              final idB = (b.data()['id'] as num?)?.toInt() ?? 0;
              return idA.compareTo(idB);
            });
            return docs
                .map((d) => d.data()['thumbnailImg'] as String?)
                .where((url) => url != null && url.isNotEmpty)
                .cast<String>()
                .toList();
          })
          .handleError((_) => AppData.homeBanners);
    } catch (_) {
      return Stream.value(AppData.homeBanners);
    }
  }

  // 2. PHOTO CONTEST SUBMISSIONS STREAM
  Stream<List<Map<String, dynamic>>> getSubmissions({String? dayFilter}) {
    try {
      return _firestore
          .collection('submissions')
          .snapshots()
          .map((snapshot) {
            final list = snapshot.docs.map((doc) {
              final data = Map<String, dynamic>.from(doc.data());
              data['docId'] = doc.id;
              data['id'] = doc.id;
              data['photoUrl'] = data['photoUrl'] ?? data['photo'] ?? data['image'] ?? '';
              data['fullName'] = (data['fullName'] ?? data['authorName'] ?? data['name'] ?? 'Photographer').toString().trim();
              data['localDateString'] = data['localDateString'] ?? '';
              data['votes'] = (data['votes'] as num?)?.toInt() ?? 0;
              return data;
            }).toList();

            // Filter by day if specified (e.g. "08" or "Day 8 - 8th Dec" or "2026-12-08")
            var filtered = list;
            if (dayFilter != null && dayFilter != "All Days" && dayFilter.isNotEmpty) {
              final match = RegExp(r'\b(0?[1-9]|10)\b').firstMatch(dayFilter);
              if (match != null) {
                final dayNum = int.tryParse(match.group(1)!) ?? 0;
                final twoDigit = dayNum.toString().padLeft(2, '0');
                filtered = list.where((item) {
                  final localDate = item['localDateString']?.toString() ?? '';
                  return localDate.endsWith('-$twoDigit') || localDate == twoDigit;
                }).toList();
              }
            }

            // Sort by votes descending
            filtered.sort((a, b) {
              final vA = (a['votes'] as num?)?.toInt() ?? 0;
              final vB = (b['votes'] as num?)?.toInt() ?? 0;
              return vB.compareTo(vA);
            });

            return filtered;
          })
          .handleError((err) {
            debugPrint('Error loading submissions: $err');
            return <Map<String, dynamic>>[];
          });
    } catch (_) {
      return Stream.value(<Map<String, dynamic>>[]);
    }
  }

  // 3. USER VOTES STREAM
  Stream<Set<String>> getUserVotes(String userId) {
    if (userId.isEmpty) return Stream.value({});
    try {
      return _firestore
          .collection('userVotes')
          .doc(userId)
          .snapshots()
          .map((doc) {
            if (!doc.exists || doc.data() == null) return <String>{};
            final votedList = doc.data()!['votedFor'];
            if (votedList is List) {
              return votedList.map((e) => e.toString()).toSet();
            }
            return <String>{};
          })
          .handleError((_) => <String>{});
    } catch (_) {
      return Stream.value({});
    }
  }

  // 4. CAST VOTE
  Future<bool> castVote({
    required String userId,
    required String submissionDocId,
    bool isVoting = true,
  }) async {
    try {
      final subRef = _firestore.collection('submissions').doc(submissionDocId);
      final voteRef = _firestore.collection('userVotes').doc(userId);

      if (isVoting) {
        await subRef.update({'votes': FieldValue.increment(1)});
        if (userId.isNotEmpty) {
          await voteRef.set({
            'votedFor': FieldValue.arrayUnion([submissionDocId]),
          }, SetOptions(merge: true));
        }
      } else {
        await subRef.update({'votes': FieldValue.increment(-1)});
        if (userId.isNotEmpty) {
          await voteRef.set({
            'votedFor': FieldValue.arrayRemove([submissionDocId]),
          }, SetOptions(merge: true));
        }
      }
      return true;
    } catch (e) {
      debugPrint("Remote castVote error: $e");
      return false;
    }
  }

  // 5. HORNBILL SCHEDULE STREAM
  Stream<Map<String, dynamic>?> getHornbillSchedule() {
    try {
      return _firestore
          .collection('hornbill')
          .doc('latest')
          .snapshots()
          .map((doc) => doc.exists ? doc.data() : null)
          .handleError((_) => null);
    } catch (e) {
      debugPrint('Firebase not initialized for hornbill schedule: $e');
      return Stream.value(null);
    }
  }

  // 5.1 HORNBILL TOURISM E-MAGAZINE STREAM
  Stream<String?> getMagazineUrlStream() {
    return _firestore
        .collection('hornbill')
        .doc('Magazine')
        .snapshots()
        .asyncMap((doc) async {
          if (doc.exists && doc.data() != null) {
            final data = doc.data()!;
            final url = data['magazine'] ?? data['Magazine'] ?? data['url'] ?? data['pdfUrl'] ?? data['pdf'];
            if (url != null && url.toString().trim().isNotEmpty) {
              return url.toString().trim();
            }
          }

          // Fallback check subcollection hornbill/Magazine/latest/Magazine
          try {
            final subDoc = await _firestore
                .collection('hornbill')
                .doc('Magazine')
                .collection('latest')
                .doc('Magazine')
                .get();
            if (subDoc.exists && subDoc.data() != null) {
              final subData = subDoc.data()!;
              final url = subData['magazine'] ?? subData['Magazine'] ?? subData['url'] ?? subData['pdfUrl'] ?? subData['pdf'];
              if (url != null && url.toString().trim().isNotEmpty) {
                return url.toString().trim();
              }
            }
          } catch (_) {}

          // Fallback check hornbill/latest
          try {
            final latestDoc = await _firestore.collection('hornbill').doc('latest').get();
            if (latestDoc.exists && latestDoc.data() != null) {
              final url = latestDoc.data()!['magazine'];
              if (url != null && url.toString().trim().isNotEmpty) {
                return url.toString().trim();
              }
            }
          } catch (_) {}

          return null;
        })
        .handleError((_) => null);
  }

  Future<String?> fetchMagazineUrl() async {
    try {
      final doc = await _firestore.collection('hornbill').doc('Magazine').get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final url = data['magazine'] ?? data['Magazine'] ?? data['url'] ?? data['pdfUrl'] ?? data['pdf'];
        if (url != null && url.toString().trim().isNotEmpty) {
          return url.toString().trim();
        }
      }

      // Fallback check subcollection hornbill/Magazine/latest/Magazine
      try {
        final subDoc = await _firestore
            .collection('hornbill')
            .doc('Magazine')
            .collection('latest')
            .doc('Magazine')
            .get();
        if (subDoc.exists && subDoc.data() != null) {
          final subData = subDoc.data()!;
          final url = subData['magazine'] ?? subData['Magazine'] ?? subData['url'] ?? subData['pdfUrl'] ?? subData['pdf'];
          if (url != null && url.toString().trim().isNotEmpty) {
            return url.toString().trim();
          }
        }
      } catch (_) {}

      // Fallback check hornbill/latest
      try {
        final latestDoc = await _firestore.collection('hornbill').doc('latest').get();
        if (latestDoc.exists && latestDoc.data() != null) {
          final url = latestDoc.data()!['magazine'];
          if (url != null && url.toString().trim().isNotEmpty) {
            return url.toString().trim();
          }
        }
      } catch (_) {}
    } catch (_) {}
    return null;
  }

  // 6. CONTESTS & PROGRAMS STREAM
  Stream<List<Map<String, dynamic>>> getContests() {
    try {
      return _firestore
          .collection('contests')
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final data = Map<String, dynamic>.from(doc.data());
              data['docId'] = doc.id;
              data['localPoster'] = 'assets/images/posters/${doc.id}.jpg';
              return data;
            }).toList();
          })
          .handleError((_) => ContestsData.allContests.map((c) => c.toMap()).toList());
    } catch (_) {
      return Stream.value(ContestsData.allContests.map((c) => c.toMap()).toList());
    }
  }

  // 7. CAFES STREAM (Normalized for view_cafe_screen & cafes_screen)
  Stream<List<Map<String, dynamic>>> getCafes({String? district}) {
    try {
      return _firestore.collection('cafes').snapshots().map((snap) {
        return snap.docs.map((d) {
          final data = Map<String, dynamic>.from(d.data());
          data['docId'] = d.id;
          data['id'] = data['cafeID'] ?? d.id;
          data['name'] = data['cafeName'] ?? data['name'] ?? 'Café';
          data['cafeName'] = data['name'];
          data['location'] = data['address'] ?? data['location'] ?? 'Nagaland';
          data['address'] = data['location'];
          data['phone'] = data['phoneNumber'] ?? data['phone'] ?? '';
          data['phoneNumber'] = data['phone'];
          data['image'] = data['photo'] ?? data['image'] ?? '';
          data['photo'] = data['image'];
          data['localBanner'] = 'assets/images/cafes/${d.id}_banner.jpg';
          data['localMenu'] = 'assets/images/cafes/${d.id}_menu.jpg';
          data['district'] = data['district'] ?? 'Kohima';
          data['rating'] = data['rating'] ?? 4.5;
          data['reviews'] = data['reviews'] ?? 32;
          data['openTime'] = data['openTime'] ?? '9:00 AM - 8:00 PM';
          data['description'] = data['description'] ??
              'Cozy cafe serving delicious local treats, beverages, and warm hospitality.';
          data['isActive'] = data['isActive'] == true;
          return data;
        }).toList();
      }).handleError((_) => CafesData.allCafes);
    } catch (_) {
      return Stream.value(CafesData.allCafes);
    }
  }

  // 8. HOTELS STREAM (Normalized to List<Hotel> from Firebase 'hotels' collection)
  Stream<List<Hotel>> getHotels({String? district}) {
    try {
      return _firestore
          .collection('hotels')
          .snapshots()
          .map((snap) {
            final all = snap.docs.map((d) {
              final data = Map<String, dynamic>.from(d.data() as Map);
              return Hotel.fromMap(data, d.id);
            }).where((h) => h.isActive).toList();

            if (district != null && district != "All" && district.isNotEmpty) {
              return all
                  .where((h) => h.district.toLowerCase() == district.toLowerCase())
                  .toList();
            }
            return all;
          })
          .handleError((err) {
            debugPrint('Error loading hotels from Firebase: $err');
            final fallback = HotelsData.allHotels;
            if (district != null && district != "All" && district.isNotEmpty) {
              return fallback
                  .where((h) => h.district.toLowerCase() == district.toLowerCase())
                  .toList();
            }
            return fallback;
          });
    } catch (_) {
      final fallback = HotelsData.allHotels;
      if (district != null && district != "All" && district.isNotEmpty) {
        return Stream.value(
          fallback
              .where((h) => h.district.toLowerCase() == district.toLowerCase())
              .toList(),
        );
      }
      return Stream.value(fallback);
    }
  }

  // 9. ROOMS STREAM (Strongly typed for ViewHotelScreen with local memory cache)
  static List<HotelRoom>? _cachedAllRooms;

  Stream<List<HotelRoom>> getHotelRooms({String? hotelDocId, String? hotelID}) {
    final fallback = RoomsData.getRoomsForHotel(hotelDocId: hotelDocId, hotelID: hotelID);

    try {
      return _firestore.collection('rooms').snapshots().map((snap) {
        final all = snap.docs.map((d) {
          final data = Map<String, dynamic>.from(d.data());
          return HotelRoom.fromMap(data, d.id);
        }).toList();

        _cachedAllRooms = all;

        final filtered = all.where((r) {
          if (hotelID != null && hotelID.isNotEmpty && (r.hotelID == hotelID || r.hotelID == hotelDocId)) return true;
          if (hotelDocId != null && hotelDocId.isNotEmpty && (r.hotelID == hotelDocId || r.hotelID == hotelID)) return true;
          return false;
        }).toList();

        return filtered;
      }).handleError((_) => fallback);
    } catch (_) {
      return Stream.value(fallback);
    }
  }

  Stream<List<Map<String, dynamic>>> getRooms(String hotelId) {
    try {
      return _firestore
          .collection('rooms')
          .snapshots()
          .map((snap) {
            return snap.docs
                .map((d) {
                  final data = Map<String, dynamic>.from(d.data());
                  data['docId'] = d.id;
                  return data;
                })
                .where((d) => d['hotelID'] == hotelId)
                .toList();
          })
          .handleError((_) => RoomsData.getRoomsForHotel(hotelDocId: hotelId, hotelID: hotelId)
              .map((r) => r.toMap())
              .toList());
    } catch (_) {
      return Stream.value(RoomsData.getRoomsForHotel(hotelDocId: hotelId, hotelID: hotelId)
          .map((r) => r.toMap())
          .toList());
    }
  }

  // 10. TAXIS STREAM
  Stream<List<Map<String, dynamic>>> getTaxis({String? district}) {
    try {
      return _firestore.collection('taxis').snapshots().map((snap) {
        return snap.docs.map((d) {
          final data = Map<String, dynamic>.from(d.data());
          data['docId'] = d.id;
          return data;
        }).toList();
      }).handleError((_) => TaxisData.rawTaxis);
    } catch (_) {
      return Stream.value(TaxisData.rawTaxis);
    }
  }

  // 11. TOUR GUIDES STREAM
  Stream<List<Map<String, dynamic>>> getTourGuides() {
    return _firestore.collection('tour_guides').snapshots().map((snap) {
      return snap.docs.map((d) {
        final data = Map<String, dynamic>.from(d.data());
        data['docId'] = d.id;
        data['id'] = data['guideID'] ?? d.id;
        data['fullName'] = data['fullName'] ?? data['businessName'] ?? data['name'] ?? 'Tour Guide';
        data['name'] = data['fullName'];
        data['phone'] = data['phoneNumber'] ?? data['phone'] ?? '';
        data['phoneNumber'] = data['phone'];
        data['district'] = data['district'] ?? '';
        data['address'] = data['address'] ?? '';
        data['document'] = data['document'] ?? '';
        data['photo'] = data['photo'] ?? data['document'] ?? '';
        data['isActive'] = data['isActive'] == true;
        return data;
      }).toList();
    }).handleError((_) => <Map<String, dynamic>>[]);
  }

  // 11b. TOUR OPERATORS STREAM
  Stream<List<Map<String, dynamic>>> getTourOperators() {
    try {
      return _firestore.collection('tour_operators').snapshots().map((snap) {
        return snap.docs.map((d) {
          final data = Map<String, dynamic>.from(d.data());
          data['docId'] = d.id;
          data['operatorID'] = data['operatorID'] ?? d.id;
          data['businessName'] = (data['businessName'] ?? '').toString().trim();
          data['owner'] = (data['owner'] ?? '').toString().trim();
          data['address'] = (data['address'] ?? '').toString().trim();
          data['district'] = (data['district'] ?? '').toString().trim();
          data['phoneNumber'] = (data['phoneNumber'] ?? data['phone'] ?? '').toString().trim();
          data['photo'] = data['photo'] ?? data['document'] ?? '';
          data['document'] = data['document'] ?? '';
          data['created_at'] = data['created_at'] ?? '';
          data['isActive'] = data['isActive'] == true || data['isActive'] == 'true';
          data['isDzukoTour'] = data['isDzukoTour'] == true || data['isDzukoTour'] == 'true';
          data['isNagalandTour'] = data['isNagalandTour'] == true || data['isNagalandTour'] == 'true';
          data['isNorthEastTour'] = data['isNorthEastTour'] == true || data['isNorthEastTour'] == 'true';
          return data;
        }).where((op) => op['isActive'] == true).toList();
      }).handleError((err) {
        debugPrint('Error loading tour_operators: $err');
        return <Map<String, dynamic>>[];
      });
    } catch (e) {
      debugPrint('Firebase not initialized for tour_operators: $e');
      return const Stream.empty();
    }
  }

  Stream<List<Map<String, dynamic>>> getTourPlanners() => getTourOperators();

  // 12. STALLS STREAM (Offline-First Cached)
  Stream<List<Stall>> getStallsStream() {
    return OfflineDataService().streamStalls();
  }

  Stream<List<Map<String, dynamic>>> getStalls() {
    return getStallsStream().map((list) => list.map((s) => s.toMap()).toList());
  }

  // 13. LANDMARK STREAM (Offline-First Cached)
  Stream<List<Landmark>> getLandmarksStream() {
    return OfflineDataService().streamLandmarks();
  }

  Stream<List<Map<String, dynamic>>> getLandmarks() {
    try {
      return _firestore
          .collection('landmark')
          .snapshots()
          .map((snap) {
            return snap.docs.map((d) {
              final data = Map<String, dynamic>.from(d.data());
              data['docId'] = d.id;
              return data;
            }).toList();
          })
          .handleError((_) => LandmarksData.allLandmarks.map((l) => l.toMap()).toList());
    } catch (e) {
      debugPrint('Firebase not initialized for landmarks map: $e');
      return Stream.value(LandmarksData.allLandmarks.map((l) => l.toMap()).toList());
    }
  }

  // 13B. TRIBES STREAM (Offline-first & Firebase collection 'tribes')
  Stream<List<Tribe>> getTribesStream() {
    return OfflineDataService().streamTribes();
  }

  Stream<List<Map<String, dynamic>>> getTribes() {
    try {
      return _firestore
          .collection('tribes')
          .snapshots()
          .map((snap) {
            final list = snap.docs.map((d) {
              final data = Map<String, dynamic>.from(d.data());
              data['docId'] = d.id;
              return data;
            }).toList();
            return list;
          })
          .handleError((_) => AppData.tribes.map((t) => t.toMap()).toList());
    } catch (e) {
      debugPrint('Firebase not initialized for tribes: $e');
      return Stream.value(AppData.tribes.map((t) => t.toMap()).toList());
    }
  }

  static String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }

  // 14. NOTIFICATIONS STREAM
  Stream<List<Map<String, dynamic>>> getNotifications() {
    try {
      return _firestore
          .collection('notifications')
          .snapshots()
          .map((snap) {
            return snap.docs.map((d) {
              final data = Map<String, dynamic>.from(d.data());
              data['docId'] = d.id;
              data['title'] = data['title'] ?? '';
              final rawDate = data['date_created'] ?? data['date'] ?? data['created_at'] ?? data['timestamp'];
              data['rawDate'] = rawDate;
              if (rawDate is Timestamp) {
                final dt = rawDate.toDate();
                data['date'] = '${dt.day} ${_monthName(dt.month)}, ${dt.year}';
              } else {
                data['date'] = (data['date_created'] ?? data['date'] ?? '').toString();
              }
              data['file'] = data['file'] ?? '';
              data['body'] = data['body'] ?? data['title'] ?? '';
              return data;
            }).toList();
          })
          .handleError((_) => <Map<String, dynamic>>[]);
    } catch (e) {
      debugPrint('Firebase not initialized for notifications: $e');
      return const Stream.empty();
    }
  }

  // 14.5. FESTIVALS STREAM
  Stream<List<Map<String, dynamic>>> getFestivals() {
    try {
      return _firestore
          .collection('festivals')
          .snapshots()
          .map((snap) {
            final list = snap.docs.map((d) {
              final data = Map<String, dynamic>.from(d.data());
              data['docId'] = d.id;
              data['id'] = data['id'] ?? d.id;
              data['festivalName'] = data['festivalName'] ?? data['name'] ?? '';
              data['tribeName'] = data['tribeName'] ?? data['tribe'] ?? '';
              data['description'] = data['description'] ?? '';
              data['image'] = data['image'] ?? data['photo'] ?? data['networkUrl'] ?? '';
              data['serialno'] = data['serialno'] ?? data['serialNo'] ?? data['serial_no'];
              return data;
            }).toList();

            list.sort((a, b) {
              final sA = (a['serialno'] is num)
                  ? (a['serialno'] as num).toInt()
                  : int.tryParse(a['serialno']?.toString() ?? '') ?? 999;
              final sB = (b['serialno'] is num)
                  ? (b['serialno'] as num).toInt()
                  : int.tryParse(b['serialno']?.toString() ?? '') ?? 999;
              return sA.compareTo(sB);
            });

            return list;
          })
          .handleError((_) => <Map<String, dynamic>>[]);
    } catch (e) {
      debugPrint('Firebase not initialized for festivals: $e');
      return const Stream.empty();
    }
  }

  // 14.6. CULTURAL CALENDAR STREAM
  Stream<List<CalendarEvent>> getCulturalCalendarEvents() {
    try {
      return _firestore
          .collection('cultural_calendar')
          .snapshots()
          .map((snap) {
            final events = snap.docs.map((d) {
              return CalendarEvent.fromMap(d.data(), d.id);
            }).toList();

            // Chronological sort: by startDate if available, else year/month/days
            events.sort((a, b) {
              if (a.startDate != null && b.startDate != null) {
                return a.startDate!.compareTo(b.startDate!);
              }
              if (a.order != 0 && b.order != 0) {
                return a.order.compareTo(b.order);
              }
              final yearCmp = a.year.compareTo(b.year);
              if (yearCmp != 0) return yearCmp;
              const monthOrder = {
                'JAN': 1, 'FEB': 2, 'MAR': 3, 'APR': 4, 'MAY': 5, 'JUN': 6,
                'JUL': 7, 'AUG': 8, 'SEP': 9, 'OCT': 10, 'NOV': 11, 'DEC': 12,
              };
              final mA = monthOrder[a.month.toUpperCase()] ?? 0;
              final mB = monthOrder[b.month.toUpperCase()] ?? 0;
              final monthCmp = mA.compareTo(mB);
              if (monthCmp != 0) return monthCmp;
              return a.days.compareTo(b.days);
            });

            return events;
          })
          .handleError((e) {
            debugPrint('Error streaming cultural calendar: $e');
            return <CalendarEvent>[];
          });
    } catch (e) {
      debugPrint('Firebase not initialized for cultural calendar: $e');
      return const Stream.empty();
    }
  }

  /// Seeds initial 21 cultural calendar events into Firestore collection 'cultural_calendar'
  /// if the collection is empty, so admin/organizers have all data in Firestore ready to edit.
  Future<void> seedCulturalCalendarIfEmpty(List<CalendarEvent> defaultEvents) async {
    try {
      final snap = await _firestore.collection('cultural_calendar').limit(1).get();
      if (snap.docs.isEmpty) {
        debugPrint('[CulturalCalendar] Seeding ${defaultEvents.length} events to Firestore...');
        final batch = _firestore.batch();
        for (int i = 0; i < defaultEvents.length; i++) {
          final event = defaultEvents[i];
          final docId = '${event.year}_${event.month.toLowerCase()}_${event.title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}';
          final docRef = _firestore.collection('cultural_calendar').doc(docId);
          final map = event.toMap();
          map['order'] = i + 1;
          batch.set(docRef, map);
        }
        await batch.commit();
        debugPrint('[CulturalCalendar] Successfully seeded events to Firestore!');
      }
    } catch (e) {
      debugPrint('[CulturalCalendar] Note during seeding check: $e');
    }
  }

  // 15. USER AUTHENTICATION & PROFILE VIA FIRESTORE 'users' COLLECTION
  Future<UserModel> loginWithFirestore({
    required String email,
    required String password,
  }) async {
    try {
      final cleanEmail = email.trim();
      QuerySnapshot snap = await _firestore
          .collection('users')
          .where('email', isEqualTo: cleanEmail)
          .limit(1)
          .get();

      if (snap.docs.isEmpty) {
        snap = await _firestore
            .collection('users')
            .where('email', isEqualTo: cleanEmail.toLowerCase())
            .limit(1)
            .get();
      }

      if (snap.docs.isEmpty) {
        throw Exception("No user found with email: $cleanEmail");
      }

      final doc = snap.docs.first;
      final data = Map<String, dynamic>.from(doc.data() as Map);
      final storedPassword = data['password']?.toString() ?? '';

      if (storedPassword != password) {
        throw Exception("Incorrect password. Please try again.");
      }

      return UserModel.fromMap(data, doc.id);
    } catch (e) {
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('no user found') || errStr.contains('incorrect password')) {
        rethrow;
      }
      debugPrint("Login Firestore error: $e");
      throw Exception("Unable to connect to service. Please check your internet connection.");
    }
  }

  Future<UserModel> registerWithFirestore({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String gender,
    required String state,
    String country = "India",
  }) async {
    try {
      final cleanEmail = email.trim().toLowerCase();

      final existing = await _firestore
          .collection('users')
          .where('email', isEqualTo: cleanEmail)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        throw Exception("An account with this email already exists");
      }

      final docRef = _firestore.collection('users').doc();
      final uid = docRef.id;
      final now = DateTime.now();
      final months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      final dateCreated = '${now.day}th ${months[now.month - 1]}, ${now.year}';

      final userData = {
        'country': country,
        'date_created': dateCreated,
        'email': cleanEmail,
        'fullName': fullName.trim(),
        'gender': gender,
        'isActive': true,
        'password': password,
        'phone': phone.trim(),
        'states': state,
        'userID': uid,
      };

      await docRef.set(userData);
      return UserModel.fromMap(userData, uid);
    } catch (e) {
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('already exists')) {
        rethrow;
      }
      debugPrint("Register Firestore error: $e");
      throw Exception("Unable to connect to service. Please check your internet connection.");
    }
  }

  /// Verifies [email] and [phone] against the Firestore `users` collection
  /// and updates the stored password to [newPassword].
  Future<void> resetPasswordWithFirestore({
    required String email,
    required String phone,
    required String newPassword,
  }) async {
    try {
      final cleanEmail = email.trim();
      QuerySnapshot snap = await _firestore
          .collection('users')
          .where('email', isEqualTo: cleanEmail)
          .limit(1)
          .get();

      if (snap.docs.isEmpty) {
        snap = await _firestore
            .collection('users')
            .where('email', isEqualTo: cleanEmail.toLowerCase())
            .limit(1)
            .get();
      }

      if (snap.docs.isEmpty) {
        throw Exception("No account found with this email.");
      }

      final doc = snap.docs.first;
      final data = Map<String, dynamic>.from(doc.data() as Map);
      final storedPhone = (data['phone']?.toString() ?? '').replaceAll(RegExp(r'[\s\-\(\)]'), '');
      final enteredPhone = phone.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');

      final bool phonesMatch = storedPhone.isNotEmpty &&
          (storedPhone == enteredPhone ||
              (storedPhone.length >= 10 &&
                  enteredPhone.length >= 10 &&
                  storedPhone.substring(storedPhone.length - 10) ==
                      enteredPhone.substring(enteredPhone.length - 10)));

      if (!phonesMatch) {
        throw Exception("The phone number does not match this account.");
      }

      await doc.reference.update({'password': newPassword});
    } catch (e) {
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('no account found') || errStr.contains('phone number does not match')) {
        rethrow;
      }
      debugPrint("Reset password Firestore error: $e");
      throw Exception("Unable to connect to service. Please check your internet connection.");
    }
  }

  Future<UserModel?> getUserProfile(String userId) async {
    if (userId.isEmpty) return null;
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }

      final snap = await _firestore
          .collection('users')
          .where('userID', isEqualTo: userId)
          .limit(1)
          .get();
      if (snap.docs.isNotEmpty) {
        return UserModel.fromMap(snap.docs.first.data(), snap.docs.first.id);
      }
    } catch (e) {
      debugPrint("Error fetching user profile: $e");
    }
    return null;
  }

  /// Permanently deletes the user profile and session data from Firestore.
  /// Required by Apple App Store (Guideline 5.1.1(v)) and Google Play Policy.
  Future<bool> deleteUserAccount(String userId, {String? userEmail}) async {
    if (userId.isEmpty && (userEmail == null || userEmail.isEmpty)) return false;
    try {
      // 1. Check direct doc ID
      if (userId.isNotEmpty) {
        final docRef = _firestore.collection('users').doc(userId);
        final docSnap = await docRef.get();
        if (docSnap.exists) {
          await docRef.delete();
          return true;
        }

        // 2. Query by 'userID' field
        final snap = await _firestore
            .collection('users')
            .where('userID', isEqualTo: userId)
            .limit(1)
            .get();
        if (snap.docs.isNotEmpty) {
          for (final doc in snap.docs) {
            await doc.reference.delete();
          }
          return true;
        }
      }

      // 3. Fallback: Query by email
      final cleanEmail = (userEmail ?? '').trim().toLowerCase();
      if (cleanEmail.isNotEmpty) {
        final emailSnap = await _firestore
            .collection('users')
            .where('email', isEqualTo: cleanEmail)
            .limit(1)
            .get();
        if (emailSnap.docs.isNotEmpty) {
          for (final doc in emailSnap.docs) {
            await doc.reference.delete();
          }
          return true;
        }
      }

      // 4. Purge linked user inquiries in queries collection
      if (userId.isNotEmpty) {
        try {
          final querySnap = await _firestore
              .collection('queries')
              .where('userId', isEqualTo: userId)
              .get();
          for (final doc in querySnap.docs) {
            await doc.reference.delete();
          }
        } catch (_) {}
      }

      return true;
    } catch (e) {
      debugPrint("Error deleting user account: $e");
      return false;
    }
  }

  // 17. SERVICE INQUIRY / LEAD LOGGER
  /// Logs a call lead / query to the 'queries' collection so providers can view and filter leads in their app.
  Future<String?> logServiceQuery({
    required String serviceType,
    required String serviceName,
    required String serviceId,
    String? providerId,
    String? providerPhone,
    String? district,
    String action = 'call',
  }) async {
    try {
      final now = DateTime.now();
      final year = now.year.toString();
      final month = now.month.toString().padLeft(2, '0');
      final day = now.day.toString().padLeft(2, '0');
      final dateString = '$year-$month-$day';

      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final dateFormatted = '${now.day} ${months[now.month - 1]} ${now.year}';

      final hour = now.hour;
      final minute = now.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final standardHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      final timeFormatted = '$standardHour:$minute $period';

      final mockUser = MockUser();
      final userName = mockUser.isLoggedIn
          ? mockUser.name
          : (mockUser.name.isNotEmpty && mockUser.name != 'Guest User'
              ? mockUser.name
              : 'Guest User');
      final userPhone = mockUser.isLoggedIn ? mockUser.phone : '';

      // Pure logic against Firestore: check if a query already exists today for this user and service/provider
      try {
        Query<Map<String, dynamic>> checkQuery = _firestore
            .collection('queries')
            .where('date', isEqualTo: dateString);

        if (userPhone.isNotEmpty) {
          checkQuery = checkQuery.where('userPhone', isEqualTo: userPhone);
        } else if (userName.isNotEmpty && userName != 'Guest User') {
          checkQuery = checkQuery.where('userName', isEqualTo: userName);
        }

        final existingDocs = await checkQuery.get();
        for (final doc in existingDocs.docs) {
          final data = doc.data();
          final existingProvider = (data['providerId'] ?? '').toString().trim();
          final existingService = (data['serviceName'] ?? '').toString().trim().toLowerCase();
          final incomingService = serviceName.trim().toLowerCase();
          final incomingProvider = (providerId ?? '').trim();

          final providerMatches = incomingProvider.isNotEmpty &&
              existingProvider.isNotEmpty &&
              existingProvider == incomingProvider;
          final serviceMatches = incomingService.isNotEmpty &&
              existingService.isNotEmpty &&
              incomingService == existingService;

          // If from the same provider, or for the same service on the same date:
          if ((providerMatches && serviceMatches) || providerMatches || serviceMatches) {
            debugPrint('Query already exists in Firestore today (Doc: ${doc.id}) for $serviceName (Provider: $providerId). Skipping duplicate.');
            return doc.id;
          }
        }
      } catch (e) {
        debugPrint('Deduplication check error: $e');
      }

      final queryData = {
        'providerId': providerId ?? '',
        'userName': userName,
        'userPhone': userPhone,
        'serviceName': serviceName,
        'serviceType': serviceType,
        'dateTime': '$dateFormatted, $timeFormatted',
        'date': dateString,
        'timestamp': now.millisecondsSinceEpoch,
      };

      final docRef = await _firestore.collection('queries').add(queryData);
      debugPrint('Query logged: ${docRef.id} for $serviceName (Provider: $providerId)');
      return docRef.id;
    } catch (e) {
      debugPrint('Error logging service query: $e');
      return null;
    }
  }

  /// Real-time stream of service queries, filtered and sorted by newest first
  Stream<List<Map<String, dynamic>>> getQueriesStream({
    String? providerId,
    String? dateFilter,
    String? serviceType,
  }) {
    try {
      Query<Map<String, dynamic>> query = _firestore.collection('queries');

      if (providerId != null && providerId.isNotEmpty) {
        query = query.where('providerId', isEqualTo: providerId);
      }
      if (dateFilter != null && dateFilter.isNotEmpty) {
        query = query.where('date', isEqualTo: dateFilter);
      }
      if (serviceType != null && serviceType.isNotEmpty) {
        query = query.where('serviceType', isEqualTo: serviceType);
      }

      return query.snapshots().map((snapshot) {
        final list = snapshot.docs.map((doc) {
          final data = Map<String, dynamic>.from(doc.data());
          data['id'] = doc.id;
          return data;
        }).toList();

        list.sort((a, b) {
          final tA = (a['timestamp'] as num?)?.toInt() ?? 0;
          final tB = (b['timestamp'] as num?)?.toInt() ?? 0;
          return tB.compareTo(tA);
        });

        return list;
      });
    } catch (e) {
      debugPrint('Firebase not initialized for queries: $e');
      return Stream.value(<Map<String, dynamic>>[]);
    }
  }

  /// Update query status (e.g. 'new', 'contacted', 'completed')
  Future<void> updateQueryStatus(String queryId, String status) async {
    try {
      await _firestore.collection('queries').doc(queryId).update({
        'status': status,
      });
    } catch (e) {
      debugPrint('Error updating query status: $e');
    }
  }

  // 18. EMERGENCY HELPLINES STREAM (Firestore 'emergency_helplines' collection)
  Stream<List<Map<String, dynamic>>> getEmergencyHelplines() {
    try {
      return _firestore.collection('emergency_helplines').snapshots().map((snapshot) {
        final list = snapshot.docs.map((doc) {
          final data = Map<String, dynamic>.from(doc.data());
          data['id'] = doc.id;
          return data;
        }).toList();

        list.sort((a, b) {
          final orderA = (a['order'] as num?)?.toInt() ?? 9999;
          final orderB = (b['order'] as num?)?.toInt() ?? 9999;
          return orderA.compareTo(orderB);
        });

        return list;
      });
    } catch (e) {
      debugPrint('Firebase not initialized for emergency_helplines: $e');
      return Stream.value(<Map<String, dynamic>>[]);
    }
  }

  // 19. EXPLORE NAGALAND DESTINATIONS STREAM (Firestore 'destinations' collection)
  Stream<List<DistrictInfo>> getDestinations() {
    const featuredOrder = [
      'kohima',
      'dimapur',
      'wokha',
      'zunheboto',
      'chümoukedima',
      'chumoukedima',
      'kiphire',
    ];
    try {
      return _firestore.collection('destinations').snapshots().map((snapshot) {
        final list = snapshot.docs.map((doc) {
          final data = Map<String, dynamic>.from(doc.data());
          return DistrictInfo.fromMap(data, doc.id);
        }).toList();

        list.sort((a, b) {
          final idxA = featuredOrder.indexOf(a.name.trim().toLowerCase());
          final idxB = featuredOrder.indexOf(b.name.trim().toLowerCase());
          if (idxA != -1 && idxB != -1) return idxA.compareTo(idxB);
          if (idxA != -1) return -1;
          if (idxB != -1) return 1;
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        return list;
      }).handleError((_) => NagalandData.districts);
    } catch (e) {
      debugPrint('Firebase not initialized for destinations: $e');
      return Stream.value(NagalandData.districts);
    }
  }

  // 20. DISCOVER VIEWPOINT SUBMISSION (Firebase Storage + Firestore 'viewpoints' collection)
  Future<String> submitViewpoint({
    required String venueName,
    required String townVillage,
    required String district,
    required String description,
    required List<String> photoPaths,
  }) async {
    final mockUser = MockUser();
    final userId = mockUser.userId.trim().isNotEmpty ? mockUser.userId.trim() : 'guest';
    final userName = mockUser.name.trim().isNotEmpty ? mockUser.name.trim() : 'Guest';
    final userEmail = mockUser.email.trim();

    final List<String> uploadedUrls = [];
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < photoPaths.length; i++) {
      final path = photoPaths[i].trim();
      if (path.isEmpty) continue;
      if (path.startsWith('http://') || path.startsWith('https://')) {
        uploadedUrls.add(path);
        continue;
      }
      if (!kIsWeb && !path.startsWith('assets/')) {
        final file = File(path);
        if (await file.exists()) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('viewpoints/${userId}_${timestamp}_${i + 1}.jpg');
          await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
          final url = await ref.getDownloadURL();
          uploadedUrls.add(url);
        }
      }
    }

    final docRef = await _firestore.collection('viewpoints').add({
      'createdAt': FieldValue.serverTimestamp(),
      'description': description.trim(),
      'district': district.trim(),
      'photos': uploadedUrls,
      'state': 'Nagaland',
      'status': 'PENDING',
      'thumbnail': uploadedUrls.isNotEmpty ? uploadedUrls.first : '',
      'townVillage': townVillage.trim(),
      'userEmail': userEmail,
      'userId': userId,
      'userName': userName,
      'venueName': venueName.trim(),
    });

    return docRef.id;
  }
}
