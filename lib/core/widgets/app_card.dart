import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/app_spacing.dart';

/// A simple card widget that follows the app's design system.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? elevation;

  const AppCard({super.key, required this.child, this.padding, this.elevation});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: elevation ?? 2.0,
      borderRadius: BorderRadius.circular(AppSpacing.s16),
      child: Padding(
        padding: padding ?? EdgeInsets.all(AppSpacing.s16),
        child: child,
      ),
    );
  }
}

