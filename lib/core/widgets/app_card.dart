import 'package:flutter/material.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/theme/app_spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? elevation;

  const AppCard({super.key, required this.child, this.padding, this.elevation});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      elevation: elevation ?? 2.0,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: Padding(padding: padding ?? AppSpacing.cardPadding, child: child),
    );
  }
}
