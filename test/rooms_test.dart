import 'package:flutter_test/flutter_test.dart';
import 'package:hornbill_festival/models/hotel_room.dart';
import 'package:hornbill_festival/data/rooms_data.dart';
import 'package:hornbill_festival/data/hotels_data.dart';

void main() {
  group('Rooms Integration Tests', () {
    test('RoomsData has all 24 rooms', () {
      expect(RoomsData.allRooms.length, 24);
    });

    test('Rooms have valid IDs, images, and non-negative prices', () {
      for (final room in RoomsData.allRooms) {
        expect(room.id.isNotEmpty, true);
        expect(room.hotelID.isNotEmpty, true);
        expect(room.title.isNotEmpty, true);
        expect(room.price > 0, true);
        expect(room.roomTariff >= 0, true);
      }
    });

    test('Abi Homestay resolves to its rooms via hotelID', () {
      final abiHotel = HotelsData.allHotels.firstWhere(
        (h) => h.id == 'rYkuH431qzk8JqGDnUJP',
      );
      expect(abiHotel.hotelID, 'Fu53VKRTooemB0B0DGCBavwgROx1');

      final rooms = RoomsData.getRoomsForHotel(
        hotelDocId: abiHotel.id,
        hotelID: abiHotel.hotelID,
      );
      expect(rooms.isNotEmpty, true);
      expect(rooms.first.id, '2mMoVLopHwhNIYcruPHf');
      expect(rooms.first.title, 'Classic / Standard Room');
      expect(rooms.first.price, 3400.0);
      expect(rooms.first.images.length, 2);
    });

    test('HotelRoom.fromMap parses string and numeric values correctly', () {
      final sample = {
        'docId': 'test_room',
        'hotelID': 'test_hotel',
        'roomTitle': 'Deluxe Suite',
        'roomType': 'AC',
        'seater': '2 People',
        'price': '4500.00',
        'roomTariff': '5000.00',
        'extraPersonCharges': '1000.00',
        'images': [
          'https://example.com/img1.jpg',
          'https://example.com/img2.jpg',
        ],
        'created_at': '24th November, 2024',
      };

      final room = HotelRoom.fromMap(sample);
      expect(room.id, 'test_room');
      expect(room.hotelID, 'test_hotel');
      expect(room.title, 'Deluxe Suite');
      expect(room.price, 4500.0);
      expect(room.roomTariff, 5000.0);
      expect(room.extraPersonCharges, 1000.0);
      expect(room.images.length, 2);
    });
  });
}
