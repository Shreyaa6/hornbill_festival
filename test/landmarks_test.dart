import 'package:flutter_test/flutter_test.dart';
import 'package:hornbill_festival/models/landmark.dart';
import 'package:hornbill_festival/data/landmarks_data.dart';

void main() {
  group('Landmarks Integration Tests', () {
    test('LandmarksData has all 59 landmarks', () {
      expect(LandmarksData.allLandmarks.length, 59);
    });

    test('Landmark properties are parsed properly', () {
      final sample = {
        'docId': '0QTocK1sF6Szn27vVrjp',
        'title': 'Garo Morung',
        'category': 'Morung',
        'latitude': 25.615689,
        'longitude': 94.114108,
        'photo': null,
      };

      final lm = Landmark.fromMap(sample, sample['docId'] as String);
      expect(lm.id, '0QTocK1sF6Szn27vVrjp');
      expect(lm.title, 'Garo Morung');
      expect(lm.category, 'Morung');
      expect(lm.latitude, 25.615689);
      expect(lm.longitude, 94.114108);
      expect(lm.photo, null);
      expect(lm.distanceKm, inInclusiveRange(1721.0, 1722.0));
    });

    test('Contains key morungs matching design screenshot', () {
      final morungTitles = LandmarksData.allLandmarks
          .where((l) => l.category.toLowerCase() == 'morung')
          .map((l) => l.title)
          .toSet();

      expect(morungTitles.contains('Angami Morung'), true);
      expect(morungTitles.contains('Ao Morung'), true);
      expect(morungTitles.contains('Chakhesang Morung'), true);
      expect(morungTitles.contains('Chang Morung'), true);
      expect(morungTitles.contains('CM Morung'), true);
      expect(morungTitles.contains('Garo Morung'), true);
      expect(morungTitles.contains('International Morung'), true);
      expect(morungTitles.contains('Kachari Morung'), true);
    });
  });
}
