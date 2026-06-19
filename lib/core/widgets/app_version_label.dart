import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';

/// Renders `App version X.Y.Z` (with build number when available) pulled
/// from the bundled platform manifests via `package_info_plus`. Shows
/// nothing while the future is loading or if the lookup fails — never
/// shows a misleading placeholder.
class AppVersionLabel extends StatelessWidget {
  final TextAlign? textAlign;
  const AppVersionLabel({super.key, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final info = snapshot.data!;
        final build = info.buildNumber.isNotEmpty ? '+${info.buildNumber}' : '';
        return Text(
          'App version ${info.version}$build',
          textAlign: textAlign ?? TextAlign.center,
          style: AppTextStyles.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textTertiary,
          ),
        );
      },
    );
  }
}
