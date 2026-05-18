import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/institute/controllers/chat_controller.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/presentation/shared/widgets/common_state_widget.dart';
import 'package:tuoora/data/models/chat_model.dart';
import 'package:tuoora/core/widgets/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateChatScreen extends GetView<ChatController> {
  const CreateChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Select Member'),
            Expanded(
              child: Padding(
                padding: AppSpacing.x24,
                child: Column(
                  children: [
                    AppSpacing.v16,
                    _buildSearchField(),
                    AppSpacing.v20,
                    Expanded(
                      child: Obx(() {
                        return CommonStateWidget(
                          isLoading: controller.isLoading.value,
                          isEmpty: controller.filteredParticipants.isEmpty,
                          emptyTitle: 'No Members Found',
                          emptySubtitle:
                              'We couldn\'t find any members matching your search.',
                          emptyIcon: Icons.person_search_outlined,
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: controller.filteredParticipants.length,
                            separatorBuilder: (_, _) => const Divider(
                              height: 1,
                              color: AppColors.divider,
                            ),
                            itemBuilder: (context, index) {
                              final participant =
                                  controller.filteredParticipants[index];
                              return _buildMemberTile(participant);
                            },
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return AppSearchField(
      hintText: 'Search members...',
      onChanged: (value) => controller.participantSearchQuery.value = value,
    );
  }

  Widget _buildMemberTile(ChatParticipant participant) {
    return ListTile(
      onTap: () => controller.startChatWithParticipant(participant),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: AppColors.primaryBrandLight,
        child: Text(
          participant.name.substring(0, 1).toUpperCase(),
          style: AppTextStyles.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryBrand,
          ),
        ),
      ),
      title: Text(
        participant.name,
        style: AppTextStyles.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        participant.role,
        style: AppTextStyles.lexend(
          fontSize: 12,
          color: AppColors.textTertiary,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textTertiary,
      ),
    );
  }
}
