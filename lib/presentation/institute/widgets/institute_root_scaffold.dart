import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_bottom_nav.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_drawer.dart';
import 'package:flutter/material.dart';
import 'package:fee_easy/core/constants/app_colors.dart';

class InstituteRootScaffold extends StatelessWidget {
  final String title;
  final int currentIndex;
  final Widget body;
  final Widget? floatingActionButton;
  final Color? backgroundColor;


  const InstituteRootScaffold({
    super.key,
    required this.title,
    required this.currentIndex,
    required this.body,
    this.floatingActionButton,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.scaffoldBg,
      drawer: const InstituteDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            InstituteAppBar(
              title: title,
              isRoot: true,
            ),
            Expanded(child: body),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: InstituteBottomNav(currentIndex: currentIndex),
    );
  }
}
