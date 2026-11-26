import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hornbill_festival/models/app_config.dart';
import 'package:hornbill_festival/screens/update/app_update_screen.dart';
import 'package:hornbill_festival/services/app_config_service.dart';

void main() {
  testWidgets('AppUpdateScreen renders app icon, title, message, and update button',
      (WidgetTester tester) async {
    const config = AppConfig(
      updateTitle: 'New App Update Available',
      updateMessage:
          'A newer version of Hornbill Festival is available with important updates. Please update to continue.',
      isUpdateMandatory: true,
      playStoreUrl: 'https://play.google.com/store/apps/details?id=hornbill.festival.nagaland',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: AppUpdateScreen(
          config: config,
          isMandatory: true,
        ),
      ),
    );

    // 1. App Icon in centre
    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);
    final imageWidget = tester.widget<Image>(imageFinder);
    expect((imageWidget.image as AssetImage).assetName, 'assets/images/logo.png');

    // 2. Title: New App Update Available
    expect(find.text('New App Update Available'), findsOneWidget);

    // 3. Message Text
    expect(
      find.text(
        'A newer version of Hornbill Festival is available with important updates. Please update to continue.',
      ),
      findsOneWidget,
    );

    // 4. Update Button
    expect(find.text('Update Now'), findsOneWidget);

    // 5. Non-mandatory "Maybe Later" button should NOT be present when isMandatory: true
    expect(find.text('Maybe Later'), findsNothing);
  });

  testWidgets('AppUpdateScreen does not display Maybe Later as updates are mandatory',
      (WidgetTester tester) async {
    const config = AppConfig(
      updateTitle: 'New Version Available',
      isUpdateMandatory: true,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: AppUpdateScreen(
          config: config,
          isMandatory: true,
        ),
      ),
    );

    expect(find.text('New Version Available'), findsOneWidget);
    expect(find.text('Update Now'), findsOneWidget);
    expect(find.text('Maybe Later'), findsNothing);
  });

  test('AppConfig semver comparison and isUpdateAvailable logic', () {
    expect(AppConfig.compareSemVer('2.5.2', '2.5.3'), -1);
    expect(AppConfig.compareSemVer('2.5.2', '2.6.0'), -1);
    expect(AppConfig.compareSemVer('2.5.2', '3.0.0'), -1);
    expect(AppConfig.compareSemVer('2.5.2', '2.5.2'), 0);
    expect(AppConfig.compareSemVer('2.5.2', '2.5.1'), 1);

    // Handles leading 'v'
    expect(AppConfig.compareSemVer('v2.5.2', 'v2.5.3'), -1);

    // AppConfig with minAndroidVersion '2.5.3' detects update available even if isUpdateMandatory is false
    const configOptional = AppConfig(
      minAndroidVersion: '2.5.3',
      isUpdateMandatory: false,
    );
    expect(configOptional.isUpdateAvailable(currentVersion: '2.5.2'), isTrue);
    expect(configOptional.shouldForceUpdate(currentVersion: '2.5.2'), isFalse);

    // When mandatory is true
    const configMandatory = AppConfig(
      minAndroidVersion: '2.5.3',
      isUpdateMandatory: true,
    );
    expect(configMandatory.isUpdateAvailable(currentVersion: '2.5.2'), isTrue);
    expect(configMandatory.shouldForceUpdate(currentVersion: '2.5.2'), isTrue);

    // Exact user configuration from Firestore:
    final userFirestoreData = {
      'app_store_url': 'https://apps.apple.com/app/id6737766797',
      'is_update_mandatory': false,
      'min_version_android': '1.0.0',
      'min_version_ios': '2.3.0',
      'play_store_url': 'https://play.google.com/store/apps/details?id=hornbill.festival.nagaland',
      'privacy_policy_url': 'https://nititechnologies.in/privacy-policy',
      'terms_url': 'https://nititechnologies.in/terms',
      'update_message': 'A newer version of Hornbill Festival is available with important updates. Please update to continue.',
      'update_title': 'Update Required',
    };
    final userConfig = AppConfig.fromMap(userFirestoreData);
    print('USER CONFIG minAndroidVersion: ${userConfig.minAndroidVersion}');
    print('USER CONFIG minAndroidBuild: ${userConfig.minAndroidBuild}');
    print('USER CONFIG isUpdateMandatory: ${userConfig.isUpdateMandatory}');
    final isAvail = userConfig.isUpdateAvailable(currentVersion: '2.5.3', currentAndroidBuild: 28);
    print('USER CONFIG isUpdateAvailable: $isAvail');
    expect(isAvail, isFalse);

    // If user changes to 2.5.3 (same version) -> NO update
    final sameVerConfig = AppConfig.fromMap({...userFirestoreData, 'min_version_android': '2.5.3'});
    expect(sameVerConfig.isUpdateAvailable(currentVersion: '2.5.3'), isFalse);

    // If user changes to 2.5.4 (greater version) -> UPDATE TRIGGERED
    final newVerConfig = AppConfig.fromMap({...userFirestoreData, 'min_version_android': '2.5.4'});
    expect(newVerConfig.isUpdateAvailable(currentVersion: '2.5.3'), isTrue);

    // If user changes to 3.0.0 (greater version) -> UPDATE TRIGGERED
    final majorVerConfig = AppConfig.fromMap({...userFirestoreData, 'min_version_android': '3.0.0'});
    expect(majorVerConfig.isUpdateAvailable(currentVersion: '2.5.3'), isTrue);
  });

  test('AppConfigService navigatorKey and live listener properties initialized', () {
    final service = AppConfigService();
    expect(service.navigatorKey, isNotNull);
    expect(service.isUpdateScreenShowing, isFalse);
    expect(AppConfigService.currentAndroidVersion, '2.5.3');
    expect(AppConfigService.currentAndroidBuild, 28);
  });
}
