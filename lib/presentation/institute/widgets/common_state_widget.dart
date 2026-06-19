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
      return LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxHeight == double.infinity) {
          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: CommonLoading()),
          );
        }
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: const Center(child: CommonLoading()),
          ),
        );
      });
    }

    if (isEmpty) {
      return LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxHeight == double.infinity) {
          return AppEmptyView(
            icon: emptyIcon,
            title: emptyTitle,
            message: emptySubtitle,
          );
        }
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: AppEmptyView(
              icon: emptyIcon,
              title: emptyTitle,
              message: emptySubtitle,
            ),
          ),
        );
      });
    }

    return child;
  }
}

