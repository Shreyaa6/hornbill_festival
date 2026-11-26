import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/app_config.dart';
import '../../services/app_config_service.dart';

class AppUpdateScreen extends StatelessWidget {
  final AppConfig? config;
  final bool isMandatory;
  final VoidCallback? onDismiss;

  const AppUpdateScreen({
    super.key,
    this.config,
    this.isMandatory = true,
    this.onDismiss,
  });

  Future<void> _openStore(String storeUrl) async {
    final uri = Uri.parse(storeUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not open store: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appConfig = config ?? AppConfigService().config;
    final storeUrl = appConfig.storeUrl;
    final title = appConfig.updateTitle.isNotEmpty &&
            appConfig.updateTitle != 'Update Required'
        ? appConfig.updateTitle
        : 'New Version Available';
    final message = appConfig.updateMessage.isNotEmpty
        ? appConfig.updateMessage
        : 'A new version of Hornbill Festival is available with important updates. Please update to continue.';

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Expanded Centered Content matching design
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Clean Hornbill Logo in Center
                        Image.asset(
                          'assets/images/logo.png',
                          width: 165,
                          height: 165,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 38),

                        // Title: New Version Available
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF111827),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Message Text
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 15.5,
                            height: 1.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Pinned Bottom Button - Mandatory Update Now
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () => _openStore(storeUrl),
                    child: const Text(
                      'Update Now',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
