import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/chat_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/presentation/shared/widgets/common_state_widget.dart';
import 'package:fee_easy/data/models/chat_model.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/widgets/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatListScreen extends GetView<ChatController> {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Chats'),
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
                          isEmpty: controller.filteredChats.isEmpty,
                          emptyTitle: 'No Chats Found',
                          emptySubtitle:
                              'Start a new conversation to see your chats here.',
                          emptyIcon: Icons.chat_bubble_outline_rounded,
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: controller.filteredChats.length,
                            separatorBuilder: (_, _) => const Divider(
                              height: 1,
                              color: AppColors.divider,
                            ),
                            itemBuilder: (context, index) {
                              final chat = controller.filteredChats[index];
                              return _buildChatTile(chat);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.fetchParticipants();
          Get.toNamed(AppRoutes.instituteCreateChat);
        },
        backgroundColor: AppColors.primaryBrand,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildSearchField() {
    return AppSearchField(
      hintText: 'Search chats...',
      onChanged: (value) => controller.searchQuery.value = value,
    );
  }

  Widget _buildChatTile(Chat chat) {
    return ListTile(
      onTap: () => controller.openChat(chat),
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: AppColors.primaryBrandLight,
        child: Text(
          chat.participantName.substring(0, 1).toUpperCase(),
          style: AppTextStyles.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryBrand,
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              chat.participantName,
              style: AppTextStyles.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            chat.lastMessageTime,
            style: AppTextStyles.lexend(
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                chat.lastMessage,
                style: AppTextStyles.lexend(
                  fontSize: 14,
                  color: chat.unreadCount > 0
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight: chat.unreadCount > 0
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (chat.unreadCount > 0)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.primaryBrand,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  chat.unreadCount.toString(),
                  style: AppTextStyles.lexend(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
