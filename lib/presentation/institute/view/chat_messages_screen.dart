import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/chat_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/data/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMessagesScreen extends GetView<ChatController> {
  const ChatMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            Obx(() {
              final chat = controller.selectedChat.value;
              return InstituteAppBar(
                title: chat?.participantName ?? 'Chat',
                subtitle: chat?.participantRole,
                actions: [
                  IconButton(
                    onPressed: () {
                      Get.snackbar('Options', 'More chat options coming soon');
                    },
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: AppColors.primaryBrand,
                    ),
                  ),
                ],
              );
            }),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.messages.isEmpty) {
                  return _buildEmptyChatView();
                }

                return ListView.builder(
                  controller: controller.scrollController,
                  padding: AppSpacing.all24,
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    return _buildMessageBubble(message);
                  },
                );
              }),
            ),
            _buildMessageInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyChatView() {
    final chat = controller.selectedChat.value;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primaryBrandLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_rounded,
              size: 48,
              color: AppColors.primaryBrand,
            ),
          ),
          AppSpacing.v24,
          Text(
            'Say Hello to ${chat?.participantName ?? 'them'}!',
            style: AppTextStyles.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.v8,
          Text(
            'Type a message to start your conversation.',
            style: AppTextStyles.lexend(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isMe = message.isMe;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(maxWidth: Get.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryBrand : AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: AppTextStyles.lexend(
                fontSize: 14,
                color: isMe ? AppColors.white : AppColors.textPrimary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                message.timestamp,
                style: AppTextStyles.lexend(
                  fontSize: 10,
                  color: isMe
                      ? AppColors.white.withValues(alpha: 0.7)
                      : AppColors.textTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _showAttachmentSheet(context),
            icon: const Icon(Icons.add, color: AppColors.textSecondary),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.paleSilver.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      style: AppTextStyles.lexend(fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      maxLines: null,
                    ),
                  ),
                  const Icon(
                    Icons.sentiment_satisfied_alt_rounded,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => controller.sendMessage(),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.primaryBrand,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: AppColors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAttachmentSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              children: [
                _buildAttachmentItem(
                  Icons.insert_drive_file_rounded,
                  'DOCUMENT',
                  Colors.cyan.shade100,
                  Colors.cyan.shade900,
                ),
                _buildAttachmentItem(
                  Icons.camera_alt_rounded,
                  'CAMERA',
                  Colors.orange.shade100,
                  Colors.orange.shade900,
                ),
                _buildAttachmentItem(
                  Icons.image_rounded,
                  'GALLERY',
                  Colors.green.shade100,
                  Colors.green.shade900,
                ),
                _buildAttachmentItem(
                  Icons.headphones_rounded,
                  'AUDIO',
                  Colors.red.shade100,
                  Colors.red.shade900,
                ),
                _buildAttachmentItem(
                  Icons.location_on_rounded,
                  'LOCATION',
                  Colors.lightBlue.shade100,
                  Colors.lightBlue.shade900,
                ),
                _buildAttachmentItem(
                  Icons.person_rounded,
                  'CONTACT',
                  Colors.blueGrey.shade100,
                  Colors.blueGrey.shade900,
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildAttachmentItem(
    IconData icon,
    String label,
    Color bgColor,
    Color iconColor,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
