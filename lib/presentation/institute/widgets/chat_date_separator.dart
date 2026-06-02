import 'package:flutter/material.dart';

import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';

/// WhatsApp-style centred day chip shown between message groups
/// ("Today" / "Yesterday" / "12 May 2026").
class ChatDateSeparator extends StatelessWidget {
  final String label;

  const ChatDateSeparator({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.primaryBrandLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: AppTextStyles.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBrand,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
