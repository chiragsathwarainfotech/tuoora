import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

/// Centralized helpers for opening external URLs (privacy policy, terms,
/// support links, etc.). Always uses the external browser so the legal
/// pages render full-screen with the OS chrome users trust.
class UrlLauncherUtils {
  const UrlLauncherUtils._();

  /// Opens [url] in the user's default external browser. Shows an error
  /// snackbar (without throwing) when the platform can't handle the URL.
  static Future<void> openExternal(String url) async {
    try {
      final uri = Uri.parse(url);
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) {
        AppSnackBar.error(AppStrings.errFailedOpenLink);
      }
    } catch (_) {
      AppSnackBar.error(AppStrings.errFailedOpenLink);
    }
  }
}
