import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/app_data.dart';
import '../models/hotel.dart';
import '../models/user_model.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _firestore;

  // 1. CAROUSEL STREAM (Home banner slider)
  Stream<List<String>> getCarouselBanners() {
    return _firestore
        .collection('carousel')
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return AppData.homeBanners;
          final docs = snapshot.docs.toList();
          docs.sort((a, b) {
            final idA = (a.data()['id'] as num?)?.toInt() ?? 0;
            final idB = (b.data()['id'] as num?)?.toInt() ?? 0;
            return idA.compareTo(idB);
          });
          final list = docs
              .map((d) => d.data()['thumbnailImg'] as String?)
              .where((url) => url != null && url.isNotEmpty)
              .cast<String>()
              .toList();
          return list.isEmpty ? AppData.homeBanners : list;
        })
        .handleError((_) => AppData.homeBanners);
  }

  // 2. PHOTO CONTEST SUBMISSIONS STREAM
  Stream<List<Map<String, dynamic>>> getSubmissions({String? dayFilter}) {
    return _firestore
        .collection('submissions')
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs.map((doc) {
            final data = Map<String, dynamic>.from(doc.data());
            data['docId'] = doc.id;
            return data;
          }).toList();

          // Filter by day if specified (e.g. "08" or "2025-12-08")
          var filtered = list;
          if (dayFilter != null && dayFilter != "All Days" && dayFilter.isNotEmpty) {
            final dayDigits = dayFilter.replaceAll(RegExp(r'\D'), '');
            filtered = list.where((item) {
              final localDate = item['localDateString']?.toString() ?? '';
              return localDate.endsWith(dayDigits) || localDate.contains(dayDigits);
            }).toList();
          }

          // Sort by votes descending
          filtered.sort((a, b) {
            final vA = (a['votes'] as num?)?.toInt() ?? 0;
            final vB = (b['votes'] as num?)?.toInt() ?? 0;
            return vB.compareTo(vA);
          });

          return filtered;
        });
  }

  // 3. USER VOTES STREAM
  Stream<Set<String>> getUserVotes(String userId) {
    if (userId.isEmpty) return Stream.value({});
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
  }

  // 4. CAST VOTE
  Future<bool> castVote({
    required String userId,
    required String submissionDocId,
  }) async {
    try {
      final subRef = _firestore.collection('submissions').doc(submissionDocId);
      final voteRef = _firestore.collection('userVotes').doc(userId);

      await _firestore.runTransaction((transaction) async {
        final subSnap = await transaction.get(subRef);
        final voteSnap = await transaction.get(voteRef);

        final currentVotes = (subSnap.data()?['votes'] as num?)?.toInt() ?? 0;
        final currentVotedList = (voteSnap.data()?['votedFor'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            [];

        if (!currentVotedList.contains(submissionDocId)) {
          currentVotedList.add(submissionDocId);
          transaction.update(subRef, {'votes': currentVotes + 1});
          transaction.set(
            voteRef,
            {'votedFor': currentVotedList},
            SetOptions(merge: true),
          );
        }
      });
      return true;
    } catch (_) {
      try {
        await _firestore.collection('submissions').doc(submissionDocId).update({
          'votes': FieldValue.increment(1),
        });
        await _firestore.collection('userVotes').doc(userId).set({
          'votedFor': FieldValue.arrayUnion([submissionDocId]),
        }, SetOptions(merge: true));
        return true;
      } catch (_) {
        return false;
      }
    }
  }

  // 5. HORNBILL SCHEDULE STREAM
  Stream<Map<String, dynamic>?> getHornbillSchedule() {
    return _firestore
        .collection('hornbill')
        .doc('latest')
        .snapshots()
        .map((doc) => doc.exists ? doc.data() : null)
        .handleError((_) => null);
  }

  // 6. CONTESTS & PROGRAMS STREAM
  Stream<List<Map<String, dynamic>>> getContests() {
    return _firestore
        .collection('contests')
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs.map((doc) {
            final data = Map<String, dynamic>.from(doc.data());
            data['docId'] = doc.id;
            return data;
          }).toList();
          return list;
        })
        .handleError((_) => <Map<String, dynamic>>[]);
  }

  // 7. CAFES STREAM (Normalized for view_cafe_screen & cafes_screen)
  Stream<List<Map<String, dynamic>>> getCafes({String? district}) {
    Query query = _firestore.collection('cafes').where('isActive', isEqualTo: true);
    if (district != null && district != "All" && district.isNotEmpty) {
      query = query.where('district', isEqualTo: district);
    }
    return query.snapshots().map((snap) {
      return snap.docs.map((d) {
        final data = Map<String, dynamic>.from(d.data() as Map);
        data['docId'] = d.id;
        // Normalize keys
        data['name'] = data['cafeName'] ?? data['name'] ?? 'Café';
        data['location'] = data['address'] ?? data['location'] ?? 'Nagaland';
        data['phone'] = data['phoneNumber'] ?? data['phone'] ?? '';
        data['image'] = data['photo'] ?? data['image'] ?? '';
        data['district'] = data['district'] ?? 'Kohima';
        data['rating'] = data['rating'] ?? 4.5;
        data['reviews'] = data['reviews'] ?? 32;
        data['openTime'] = data['openTime'] ?? '9:00 AM - 8:00 PM';
        data['description'] = data['description'] ??
            'Cozy cafe serving delicious local treats, beverages, and warm hospitality.';
        return data;
      }).toList();
    }).handleError((_) => <Map<String, dynamic>>[]);
  }

  // 8. HOTELS STREAM (Normalized to List<Hotel>)
  Stream<List<Hotel>> getHotels({String? district}) {
    Query query = _firestore.collection('hotels').where('isActive', isEqualTo: true);
    if (district != null && district != "All" && district.isNotEmpty) {
      query = query.where('district', isEqualTo: district);
    }
    return query.snapshots().map((snap) {
      if (snap.docs.isEmpty) return AppData.hotels;
      return snap.docs.map((d) {
        final data = Map<String, dynamic>.from(d.data() as Map);
        final facilities = <String>[];
        if (data['isWifi'] == true) facilities.add('WiFi');
        if (data['isFooding'] == true) facilities.add('Fooding');
        if (data['isAC'] == true) facilities.add('AC');
        if (data['isPowerBackup'] == true) facilities.add('Power Backup');
        if (data['isParking'] == true) facilities.add('Parking');
        if (data['isSwimming'] == true) facilities.add('Swimming Pool');
        if (data['isFridge'] == true) facilities.add('Fridge');
        if (facilities.isEmpty) {
          facilities.addAll(['WiFi', 'Fooding', 'Power Backup']);
        }

        return Hotel(
          id: data['hotelID']?.toString() ?? d.id,
          name: data['hotelName']?.toString().trim() ?? 'Hotel',
          type: data['property']?.toString() ?? 'Hotel',
          district: data['district']?.toString() ?? 'Kohima',
          address: data['address']?.toString() ?? 'Nagaland',
          rating: 4.5,
          price: 3200,
          strikethroughPrice: 3800,
          image: (data['photo'] != null && data['photo'].toString().isNotEmpty)
              ? data['photo'].toString()
              : 'assets/images/hotel.png',
          phone: data['phoneNumber']?.toString() ?? '',
          isFeatured: true,
          roomsAvailable: data['isActive'] == true,
          facilities: facilities,
        );
      }).toList();
    }).handleError((_) => AppData.hotels);
  }

  // 9. ROOMS STREAM
  Stream<List<Map<String, dynamic>>> getRooms(String hotelId) {
    return _firestore
        .collection('rooms')
        .where('hotelID', isEqualTo: hotelId)
        .snapshots()
        .map((snap) {
          return snap.docs.map((d) {
            final data = Map<String, dynamic>.from(d.data());
            data['docId'] = d.id;
            return data;
          }).toList();
        })
        .handleError((_) => <Map<String, dynamic>>[]);
  }

  // 10. TAXIS STREAM
  Stream<List<Map<String, dynamic>>> getTaxis({String? district}) {
    return _firestore.collection('taxis').snapshots().map((snap) {
      var list = snap.docs.map((d) {
        final data = Map<String, dynamic>.from(d.data());
        data['docId'] = d.id;
        data['id'] = data['taxiID'] ?? d.id;
        data['model'] = data['carModel'] ?? 'Cab';
        data['driver'] = data['driver'] ?? 'Driver';
        data['phone'] = data['phoneNumber'] ?? '';
        data['seats'] = data['seater'] ?? '4 seater';
        data['type'] = 'Hatchback';
        data['pricePerDay'] = 2500;
        data['rating'] = 4.8;
        data['trips'] = 120;
        data['isAvailable'] = data['isActive'] ?? true;
        return data;
      }).toList();

      if (district != null && district != "All" && district.isNotEmpty) {
        final key = 'is$district';
        final filtered = list.where((item) => item[key] == true).toList();
        if (filtered.isNotEmpty) return filtered;
      }
      return list;
    }).handleError((_) => <Map<String, dynamic>>[]);
  }

  // 11. TOUR GUIDES & TOUR OPERATORS STREAM
  Stream<List<Map<String, dynamic>>> getTourPlanners() {
    return _firestore.collection('tour_operators').snapshots().map((snap) {
      return snap.docs.map((d) {
        final data = Map<String, dynamic>.from(d.data());
        data['docId'] = d.id;
        data['name'] = data['businessName'] ?? data['owner'] ?? 'Tour Planner';
        data['phone'] = data['phoneNumber'] ?? '';
        data['district'] = data['district'] ?? 'Nagaland';
        data['address'] = data['address'] ?? '';
        return data;
      }).toList();
    }).handleError((_) => <Map<String, dynamic>>[]);
  }

  // 12. STALLS STREAM
  Stream<List<Map<String, dynamic>>> getStalls() {
    return _firestore
        .collection('stalls')
        .snapshots()
        .map((snap) {
          final list = snap.docs.map((d) {
            final data = Map<String, dynamic>.from(d.data());
            data['docId'] = d.id;
            return data;
          }).toList();
          list.sort((a, b) {
            final oA = (a['order'] as num?)?.toInt() ?? 0;
            final oB = (b['order'] as num?)?.toInt() ?? 0;
            return oA.compareTo(oB);
          });
          return list;
        })
        .handleError((_) => <Map<String, dynamic>>[]);
  }

  // 13. LANDMARK STREAM
  Stream<List<Map<String, dynamic>>> getLandmarks() {
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
        .handleError((_) => <Map<String, dynamic>>[]);
  }

  // 14. NOTIFICATIONS STREAM
  Stream<List<Map<String, dynamic>>> getNotifications() {
    return _firestore
        .collection('notifications')
        .snapshots()
        .map((snap) {
          return snap.docs.map((d) {
            final data = Map<String, dynamic>.from(d.data());
            data['docId'] = d.id;
            data['title'] = data['title'] ?? '';
            data['date'] = data['date_created'] ?? data['date'] ?? '';
            data['file'] = data['file'] ?? '';
            data['body'] = data['title'] ?? '';
            return data;
          }).toList();
        })
        .handleError((_) => <Map<String, dynamic>>[]);
  }

  // 15. USER AUTHENTICATION & PROFILE VIA FIRESTORE 'users' COLLECTION
  Future<UserModel> loginWithFirestore({
    required String email,
    required String password,
  }) async {
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
}
