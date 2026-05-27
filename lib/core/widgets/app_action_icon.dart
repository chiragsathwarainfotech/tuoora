import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:tuoora/core/constants/app_colors.dart';

class AppActionIcon extends StatelessWidget {
  final String asset;
  final Color color;
  final double size;
  final String? semanticsLabel;

  const AppActionIcon({
    super.key,
    required this.asset,
    this.color = AppColors.primaryBrand,
    this.size = 22,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      semanticsLabel: semanticsLabel,
    );
  }
}
