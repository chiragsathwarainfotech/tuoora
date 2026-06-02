import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:tuoora/core/constants/app_colors.dart';

class AppNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? color;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.color,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      color: color,
      placeholder: (_, _) => placeholder ?? _defaultPlaceholder(),
      errorWidget: (_, _, _) => errorWidget ?? _defaultError(),
      fadeInDuration: const Duration(milliseconds: 150),
    );
    if (borderRadius != null) {
      child = ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }

  Widget _defaultPlaceholder() =>
      Container(width: width, height: height, color: AppColors.fieldBg);

  Widget _defaultError() => Container(
    width: width,
    height: height,
    color: AppColors.fieldBg,
    alignment: Alignment.center,
    child: const Icon(
      Icons.broken_image_rounded,
      color: AppColors.textMuted,
      size: 24,
    ),
  );
}
