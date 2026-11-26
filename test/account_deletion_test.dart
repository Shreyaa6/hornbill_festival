import 'package:flutter_test/flutter_test.dart';
import 'package:hornbill_festival/data/mock_user.dart';
import 'package:hornbill_festival/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('MockUser deleteAccount resets all state and clears local session', () async {
    final mockUser = MockUser();
    final testUser = UserModel(
      userId: 'test_user_del_123',
      fullName: 'Nagaland Traveler',
      email: 'traveler@nagaland.com',
      phone: '9876543210',
      gender: 'Male',
      state: 'Nagaland',
      country: 'India',
      isActive: true,
      dateCreated: '24th Nov, 2026',
    );

    await mockUser.setLoggedInUser(testUser);
    expect(mockUser.isLoggedIn, true);
    expect(mockUser.userId, 'test_user_del_123');
    expect(mockUser.name, 'Nagaland Traveler');

    // Trigger delete account
    await mockUser.deleteAccount();

    expect(mockUser.isLoggedIn, false);
    expect(mockUser.userId, isEmpty);
    expect(mockUser.name, 'Guest User');
    expect(mockUser.email, isEmpty);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('auth_user_id'), isNull);
    expect(prefs.getString('auth_user_name'), isNull);
  });
}
