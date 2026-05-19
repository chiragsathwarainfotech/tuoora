import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/core/widgets/common_dialog.dart';
import 'package:tuoora/presentation/institute/controllers/chat_controller.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/data/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

enum _ChatMenuAction { delete }

class ChatMessagesScreen extends GetView<ChatController> {
  const ChatMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) controller.closeChat();
      },
      child: Scaffold(
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
                    PopupMenuButton<_ChatMenuAction>(
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: AppColors.primaryBrand,
                      ),
                      onSelected: (action) {
                        switch (action) {
                          case _ChatMenuAction.delete:
                            _confirmDeleteConversation(chat);
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem<_ChatMenuAction>(
                          value: _ChatMenuAction.delete,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete_outline_rounded,
                                color: AppColors.bohoRed,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Delete chat',
                                style: AppTextStyles.lexend(
                                  fontSize: 14,
                                  color: AppColors.bohoRed,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.messages.isEmpty) {
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
    final attachmentUrl = message.attachment ?? '';
    final hasAttachment = attachmentUrl.isNotEmpty;
    final type = message.messageType;
    final isVisualAttachment =
        hasAttachment && (type == 'image' || type == 'video');
    final hasText = message.content.trim().isNotEmpty;
    final isFailed = message.status == MessageStatus.failed;

    final bubble = Container(
      margin: EdgeInsets.only(bottom: isFailed ? 4 : 16),
      constraints: BoxConstraints(maxWidth: Get.width * 0.75),
      padding: isVisualAttachment
          ? const EdgeInsets.all(4)
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasAttachment) _buildAttachmentContent(message, isMe),
          if (hasText)
            Padding(
              padding: isVisualAttachment
                  ? const EdgeInsets.fromLTRB(8, 8, 8, 0)
                  : EdgeInsets.only(top: hasAttachment ? 8 : 0),
              child: Text(
                message.content,
                style: AppTextStyles.lexend(
                  fontSize: 14,
                  color: isMe ? AppColors.white : AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
          Padding(
            padding: isVisualAttachment
                ? const EdgeInsets.fromLTRB(8, 4, 8, 4)
                : const EdgeInsets.only(top: 4),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.timestamp,
                    style: AppTextStyles.lexend(
                      fontSize: 10,
                      color: isMe
                          ? AppColors.white.withValues(alpha: 0.7)
                          : AppColors.textTertiary,
                    ),
                  ),
                  if (isMe) ...[
                    const SizedBox(width: 4),
                    _buildStatusTick(message.status),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );

    final wrapped = isFailed && isMe
        ? GestureDetector(
            onTap: () => controller.retrySend(message),
            child: bubble,
          )
        : bubble;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          wrapped,
          if (isFailed && isMe)
            Padding(
              padding: const EdgeInsets.only(right: 4, bottom: 16, top: 2),
              child: GestureDetector(
                onTap: () => controller.retrySend(message),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.refresh_rounded,
                      size: 12,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Tap to retry',
                      style: AppTextStyles.lexend(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAttachmentContent(Message message, bool isMe) {
    final url = message.attachment ?? '';
    switch (message.messageType) {
      case 'image':
        return _buildImageContent(url, isMe);
      case 'video':
        return _buildVideoContent(url, isMe);
      case 'audio':
        return _buildAudioContent(url, isMe);
      case 'document':
        return _buildDocumentContent(url, isMe);
      default:
        return const SizedBox.shrink();
    }
  }

  bool _isLocalPath(String urlOrPath) => !urlOrPath.startsWith('http');

  String _displayFilename(String urlOrPath) {
    if (urlOrPath.isEmpty) return 'File';
    try {
      final segments = Uri.parse(urlOrPath).pathSegments;
      if (segments.isNotEmpty && segments.last.isNotEmpty) {
        return segments.last;
      }
    } catch (_) {
      /* fall through */
    }
    return urlOrPath.split(RegExp(r'[\\/]')).last;
  }

  Future<void> _openExternal(String url) async {
    if (url.isEmpty || _isLocalPath(url)) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _buildImageContent(String urlOrPath, bool isMe) {
    final isLocal = _isLocalPath(urlOrPath);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 240,
          minWidth: 180,
          maxWidth: 280,
        ),
        child: isLocal
            ? Image.file(
                File(urlOrPath),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _imageErrorBox(isMe),
              )
            : CachedNetworkImage(
                imageUrl: urlOrPath,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  height: 200,
                  width: 200,
                  alignment: Alignment.center,
                  color: AppColors.divider.withValues(alpha: 0.3),
                  child: const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (_, _, _) => _imageErrorBox(isMe),
              ),
      ),
    );
  }

  Widget _imageErrorBox(bool isMe) => Container(
    height: 120,
    width: 200,
    alignment: Alignment.center,
    color: AppColors.divider.withValues(alpha: 0.3),
    child: Icon(
      Icons.broken_image_outlined,
      color: isMe ? AppColors.white : AppColors.textTertiary,
    ),
  );

  Widget _buildVideoContent(String urlOrPath, bool isMe) {
    return GestureDetector(
      onTap: () => _openExternal(urlOrPath),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 160,
          width: 220,
          color: Colors.black87,
          alignment: Alignment.center,
          child: const Icon(
            Icons.play_circle_outline_rounded,
            color: Colors.white,
            size: 48,
          ),
        ),
      ),
    );
  }

  Widget _buildAudioContent(String urlOrPath, bool isMe) {
    return _buildFileTile(
      icon: Icons.audiotrack_rounded,
      label: _displayFilename(urlOrPath),
      sublabel: 'Audio',
      onTap: () => _openExternal(urlOrPath),
      isMe: isMe,
    );
  }

  Widget _buildDocumentContent(String urlOrPath, bool isMe) {
    final name = _displayFilename(urlOrPath);
    final ext = name.contains('.')
        ? name.split('.').last.toUpperCase()
        : 'FILE';
    return _buildFileTile(
      icon: Icons.description_rounded,
      label: name,
      sublabel: ext,
      onTap: () => _openExternal(urlOrPath),
      isMe: isMe,
    );
  }

  Widget _buildFileTile({
    required IconData icon,
    required String label,
    required String sublabel,
    required VoidCallback onTap,
    required bool isMe,
  }) {
    final tint = isMe ? AppColors.white : AppColors.primaryBrand;
    final textColor = isMe ? AppColors.white : AppColors.textPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 200, maxWidth: 240),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: tint.withValues(alpha: isMe ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: tint, size: 22),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.lexend(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  Text(
                    sublabel,
                    style: AppTextStyles.lexend(
                      fontSize: 11,
                      color: textColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTick(MessageStatus status) {
    // Colors picked so they read well against the brand-coloured bubble.
    const sentColor = Color(0xCCFFFFFF); // muted white
    const readColor = Color(0xFF38BDF8); // sky-400, classic blue tick

    switch (status) {
      case MessageStatus.sending:
        return const Icon(
          Icons.access_time_rounded,
          size: 12,
          color: sentColor,
        );
      case MessageStatus.sent:
        return const Icon(Icons.check_rounded, size: 14, color: sentColor);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all_rounded, size: 14, color: sentColor);
      case MessageStatus.read:
        return const Icon(Icons.done_all_rounded, size: 14, color: readColor);
      case MessageStatus.failed:
        return const Icon(
          Icons.error_outline_rounded,
          size: 14,
          color: Colors.redAccent,
        );
    }
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
              crossAxisCount: 4,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              // Square cells are too short for the 56px circle + spacer +
              // 10px label, causing ~5px overflow on narrow devices. Add a
              // little extra vertical room.
              childAspectRatio: 0.82,
              children: [
                _buildAttachmentItem(
                  Icons.image_rounded,
                  'IMAGE',
                  Colors.green.shade100,
                  Colors.green.shade900,
                  onTap: _pickAndSendImage,
                ),
                _buildAttachmentItem(
                  Icons.videocam_rounded,
                  'VIDEO',
                  Colors.purple.shade100,
                  Colors.purple.shade900,
                  onTap: _pickAndSendVideo,
                ),
                _buildAttachmentItem(
                  Icons.headphones_rounded,
                  'AUDIO',
                  Colors.red.shade100,
                  Colors.red.shade900,
                  onTap: _pickAndSendAudio,
                ),
                _buildAttachmentItem(
                  Icons.insert_drive_file_rounded,
                  'DOCUMENT',
                  Colors.cyan.shade100,
                  Colors.cyan.shade900,
                  onTap: _pickAndSendDocument,
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
    Color iconColor, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Column(
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
      ),
    );
  }

  // ----------------------------------------------------- menu actions

  void _confirmDeleteConversation(Chat? chat) {
    if (chat == null) return;
    CommonDialog.showDeleteConfirmation(
      title: 'Delete chat',
      description:
          'Are you sure you want to delete your chat with '
          '${chat.participantName}? This will permanently remove all '
          'messages in this conversation.',
      onConfirm: () => controller.deleteConversation(chat),
    );
  }

  // ----------------------------------------------------- attachment pickers

  Future<void> _pickAndSendImage() async {
    if (Get.isBottomSheetOpen ?? false) Get.back();
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked == null) return;
      await controller.sendAttachment(file: File(picked.path), type: 'image');
    } catch (e) {
      AppSnackBar.error('Could not pick image: $e');
    }
  }

  Future<void> _pickAndSendVideo() async {
    if (Get.isBottomSheetOpen ?? false) Get.back();
    try {
      final picked = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (picked == null) return;
      await controller.sendAttachment(file: File(picked.path), type: 'video');
    } catch (e) {
      AppSnackBar.error('Could not pick video: $e');
    }
  }

  Future<void> _pickAndSendAudio() async {
    if (Get.isBottomSheetOpen ?? false) Get.back();
    try {
      final result = await FilePicker.pickFiles(type: FileType.audio);
      final path = result?.files.firstOrNull?.path;
      if (path == null) return;
      await controller.sendAttachment(file: File(path), type: 'audio');
    } catch (e) {
      AppSnackBar.error('Could not pick audio: $e');
    }
  }

  Future<void> _pickAndSendDocument() async {
    if (Get.isBottomSheetOpen ?? false) Get.back();
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: const [
          'pdf',
          'doc',
          'docx',
          'xls',
          'xlsx',
          'ppt',
          'pptx',
          'txt',
          'csv',
          'zip',
        ],
      );
      final path = result?.files.firstOrNull?.path;
      if (path == null) return;
      await controller.sendAttachment(file: File(path), type: 'document');
    } catch (e) {
      AppSnackBar.error('Could not pick document: $e');
    }
  }
}
