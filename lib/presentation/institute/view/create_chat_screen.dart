import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/chat_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/presentation/shared/widgets/common_state_widget.dart';
import 'package:fee_easy/data/models/chat_model.dart';
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
                          emptySubtitle: 'We couldn\'t find any members matching your search.',
                          emptyIcon: Icons.person_search_outlined,
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: controller.filteredParticipants.length,
                            separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.divider),
                            itemBuilder: (context, index) {
                              final participant = controller.filteredParticipants[index];
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.paleSilver,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        onChanged: (value) => controller.participantSearchQuery.value = value,
        style: AppTextStyles.lexend(fontSize: 16, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Search members...',
          hintStyle: AppTextStyles.lexend(
            fontSize: 14,
            color: AppColors.blueSapphire,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.blueSapphire,
            size: AppSpacing.s24,
          ),
          border: InputBorder.none,
          contentPadding: AppSpacing.all16,
        ),
      ),
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
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
    );
  }
}
