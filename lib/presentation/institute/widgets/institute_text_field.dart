import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/input_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InstituteTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const InstituteTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.brandAppBarColor,
          ),
        ),
        AppSpacing.v8,
        Container(
          decoration: BoxDecoration(
            color: AppColors.paleSilver,
            // Institute design system: 4dp corner radius on text fields.
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            // Vertical-centre single-line entries so hint/text/icon all
            // sit on the same baseline. Multi-line still flows from top.
            textAlignVertical:
                maxLines == 1 ? TextAlignVertical.center : null,
            style: AppTextStyles.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.blueSapphire,
              ),
              border: InputBorder.none,
              // Single source of truth — see [InputStyles.contentPadding]
              // for why this is 12 dp vertical (prefix-icon-friendly).
              contentPadding: InputStyles.contentPadding,
            ),
          ),
        ),
      ],
    );
  }
}

