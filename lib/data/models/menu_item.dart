import 'package:flutter/material.dart';

class ModuleItem {
  final String title;
  final VoidCallback onTap;
  final String svgAsset;

  ModuleItem(this.title, this.onTap, this.svgAsset);
}
