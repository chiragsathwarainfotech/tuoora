import 'package:tuoora/core/widgets/app_empty_view.dart';
import 'package:tuoora/core/widgets/common_loading.dart';
import 'package:flutter/material.dart';

class CommonStateWidget extends StatelessWidget {
  final bool isLoading;
  final bool isEmpty;
  final String emptyTitle;
  final String emptySubtitle;
  final IconData emptyIcon;
  final Widget child;

  const CommonStateWidget({
    super.key,
    required this.isLoading,
    required this.isEmpty,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.emptyIcon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && isEmpty) {
      return const Center(child: CommonLoading());
    }

    if (isEmpty) {
      return AppEmptyView(
        icon: emptyIcon,
        title: emptyTitle,
        message: emptySubtitle,
      );
    }

    return child;
  }
}

