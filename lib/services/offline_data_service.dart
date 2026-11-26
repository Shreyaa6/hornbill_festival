import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/landmark.dart';
import '../models/stall.dart';
import '../models/tribe.dart';
import '../data/landmarks_data.dart';
import '../data/stalls_data.dart';
import '../data/app_data.dart';

/// Offline-first data caching and persistence service for Locate Stalls, Landmarks, and Tribes.
/// 
/// Architecture:
/// 1. Tier 1 (Memory Cache): Instant synchronous access.
/// 2. Tier 2 (Disk Cache): Persistent SharedPreferences JSON storage surviving app restarts.
/// 3. Tier 3 (Bundled Seed Data): Static compile-time dataset in LandmarksData, StallsData & AppData.
/// 4. Live Sync: Streams live updates from Firestore when online and seamlessly writes to disk cache.
class OfflineDataService {
  static final OfflineDataService _instance = OfflineDataService._internal();
  factory OfflineDataService() => _instance;
  OfflineDataService._internal();

  static const String _landmarksKey = 'hornbill_cached_landmarks_v1';
  static const String _stallsKey = 'hornbill_cached_stalls_v1';
  static const String _tribesKey = 'hornbill_cached_tribes_v1';

  List<Landmark>? _memoryLandmarks;
  List<Stall>? _memoryStalls;
  List<Tribe>? _memoryTribes;

  // -------------------------------------------------------------
  // LANDMARKS
  // -------------------------------------------------------------

  /// Get cached landmarks immediately: Memory -> Disk -> Bundled Fallback
  Future<List<Landmark>> getCachedLandmarks() async {
    if (_memoryLandmarks != null && _memoryLandmarks!.isNotEmpty) {
      return _memoryLandmarks!;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_landmarksKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final decoded = jsonDecode(jsonStr) as List<dynamic>;
        final list = decoded
            .map((m) => Landmark.fromMap(Map<String, dynamic>.from(m as Map)))
            .toList();
        if (list.isNotEmpty) {
          _memoryLandmarks = list;
          return list;
        }
      }
    } catch (e) {
      debugPrint('OfflineDataService: error reading cached landmarks: $e');
    }

    _memoryLandmarks = LandmarksData.allLandmarks;
    return LandmarksData.allLandmarks;
  }

  /// Save landmarks to local persistent storage
  Future<void> saveLandmarksToCache(List<Landmark> landmarks) async {
    _memoryLandmarks = landmarks;
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = landmarks.map((l) => l.toMap()).toList();
      await prefs.setString(_landmarksKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('OfflineDataService: error saving landmarks to cache: $e');
    }
  }

  /// Offline-first Landmark stream:
  /// Emits cached data instantly, then connects to Firestore and emits live updates.
  Stream<List<Landmark>> streamLandmarks() async* {
    // 1. Immediately emit cached/offline landmarks
    final initial = await getCachedLandmarks();
    yield initial;

    // 2. Listen to Firestore stream when online
    try {
      final stream = FirebaseFirestore.instance.collection('landmark').snapshots();
      await for (final snap in stream) {
        if (snap.docs.isNotEmpty) {
          final list = snap.docs.map((d) {
            final data = Map<String, dynamic>.from(d.data());
            return Landmark.fromMap(data, d.id);
          }).toList();

          // Save to local cache in background
          unawaited(saveLandmarksToCache(list));
          yield list;
        }
      }
    } catch (e) {
      debugPrint('OfflineDataService: landmarks stream offline: $e');
      // Continues smoothly with cached data
    }
  }

  // -------------------------------------------------------------
  // STALLS
  // -------------------------------------------------------------

  /// Get cached stalls immediately: Memory -> Disk -> Bundled Fallback
  Future<List<Stall>> getCachedStalls() async {
    if (_memoryStalls != null && _memoryStalls!.isNotEmpty) {
      return _memoryStalls!;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_stallsKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final decoded = jsonDecode(jsonStr) as List<dynamic>;
        final list = decoded
            .map((m) => Stall.fromMap(Map<String, dynamic>.from(m as Map)))
            .toList();
        if (list.isNotEmpty) {
          list.sort((a, b) => a.order.compareTo(b.order));
          _memoryStalls = list;
          return list;
        }
      }
    } catch (e) {
      debugPrint('OfflineDataService: error reading cached stalls: $e');
    }

    _memoryStalls = StallsData.allStalls;
    return StallsData.allStalls;
  }

  /// Save stalls to local persistent storage
  Future<void> saveStallsToCache(List<Stall> stalls) async {
    _memoryStalls = stalls;
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = stalls.map((s) => s.toMap()).toList();
      await prefs.setString(_stallsKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('OfflineDataService: error saving stalls to cache: $e');
    }
  }

  /// Offline-first Stalls stream:
  /// Emits cached data instantly, then connects to Firestore and emits live updates.
  Stream<List<Stall>> streamStalls() async* {
    // 1. Immediately emit cached/offline stalls
    final initial = await getCachedStalls();
    yield initial;

    // 2. Listen to Firestore stream when online
    try {
      final stream = FirebaseFirestore.instance.collection('stalls').snapshots();
      await for (final snap in stream) {
        if (snap.docs.isNotEmpty) {
          final list = snap.docs.map((d) {
            final data = Map<String, dynamic>.from(d.data());
            return Stall.fromMap(data, d.id);
          }).toList();
          list.sort((a, b) => a.order.compareTo(b.order));

          // Save to local cache in background
          unawaited(saveStallsToCache(list));
          yield list;
        }
      }
    } catch (e) {
      debugPrint('OfflineDataService: stalls stream offline: $e');
      // Continues smoothly with cached data
    }
  }

  // -------------------------------------------------------------
  // TRIBES
  // -------------------------------------------------------------

  /// Get cached tribes immediately: Memory -> Disk -> Bundled Fallback
  Future<List<Tribe>> getCachedTribes() async {
    if (_memoryTribes != null && _memoryTribes!.isNotEmpty) {
      return _memoryTribes!;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_tribesKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final decoded = jsonDecode(jsonStr) as List<dynamic>;
        final list = decoded
            .map((m) => Tribe.fromMap(Map<String, dynamic>.from(m as Map)))
            .toList();
        if (list.isNotEmpty) {
          list.sort((a, b) => a.id.compareTo(b.id));
          _memoryTribes = list;
          return list;
        }
      }
    } catch (e) {
      debugPrint('OfflineDataService: error reading cached tribes: $e');
    }

    _memoryTribes = AppData.tribes;
    return AppData.tribes;
  }

  /// Save tribes to local persistent storage
  Future<void> saveTribesToCache(List<Tribe> tribes) async {
    _memoryTribes = tribes;
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = tribes.map((t) => t.toMap()).toList();
      await prefs.setString(_tribesKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('OfflineDataService: error saving tribes to cache: $e');
    }
  }

  /// Offline-first Tribes stream:
  /// Emits cached/bundled data instantly, then connects to Firestore and emits live updates.
  Stream<List<Tribe>> streamTribes() async* {
    // 1. Immediately emit cached/offline tribes
    final initial = await getCachedTribes();
    yield initial;

    // 2. Listen to Firestore stream when online
    try {
      final stream = FirebaseFirestore.instance.collection('tribes').snapshots();
      await for (final snap in stream) {
        if (snap.docs.isNotEmpty) {
          final list = snap.docs.map((d) {
            final data = Map<String, dynamic>.from(d.data());
            return Tribe.fromMap(data, d.id);
          }).toList();
          list.sort((a, b) => a.id.compareTo(b.id));

          // Save to local cache in background
          unawaited(saveTribesToCache(list));
          yield list;
        }
      }
    } catch (e) {
      debugPrint('OfflineDataService: tribes stream offline: $e');
      // Continues smoothly with cached data
    }
  }
}
