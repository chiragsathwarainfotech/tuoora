import 'package:flutter/material.dart';
import 'package:tuoora/core/constants/app_colors.dart';

class ToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const ToggleSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.white,
      activeTrackColor: AppColors.activeTracker,
      inactiveTrackColor: AppColors.inActiveTracker,
      inactiveThumbColor: AppColors.white,
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      thumbIcon: WidgetStateProperty.resolveWith<Icon?>((
        Set<WidgetState> states,
      ) {
        if (!states.contains(WidgetState.selected)) {
          return const Icon(Icons.circle, size: 28, color: AppColors.white);
        }
        return null;
      }),
    );
  }
}
