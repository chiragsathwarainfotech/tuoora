import 'package:tuoora/core/widgets/common_loading.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/widgets/app_button.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/enums/app_enums.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/core/widgets/common_dialog.dart';
import 'package:tuoora/core/utils/date_format_utils.dart';
import 'package:tuoora/presentation/institute/controllers/chat_controller.dart';
import 'package:tuoora/presentation/institute/widgets/chat_attachment_view.dart';
import 'package:tuoora/presentation/institute/widgets/chat_date_separator.dart';
import 'package:tuoora/presentation/student/widgets/student_back_button.dart';
import 'package:tuoora/data/models/chat_model.dart';
import 'package:tuoora/core/constants/app_images.dart';
import 'package:tuoora/core/widgets/app_action_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentChatMessagesScreen extends StatefulWidget {
  const StudentChatMessagesScreen({super.key});

  @override
  State<StudentChatMessagesScreen> createState() =>
      _StudentChatMessagesScreenState();
}

class _StudentChatMessagesScreenState extends State<StudentChatMessagesScreen> {
  final controller = Get.find<ChatController>();
  bool isInitializing = true;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) _initChat();
    });
  }

  Future<void> _initChat() async {
    try {
      if (controller.chatsList.isEmpty) {
        await controller.fetchChats();
      }
      Chat? targetChat = controller.chatsList.firstWhereOrNull(
        (c) => c.participantRole.toLowerCase() == 'institute',
      );

      targetChat ??= controller.selectedChat.value;

      if (targetChat == null) {
        await controller.fetchParticipants();
        final institute = controller.availableParticipants.firstWhereOrNull(
          (p) => p.role.toLowerCase() == 'institute',
        );
        if (institute != null) {
          targetChat = Chat(
            id: '_',
            participantName: institute.name,
            participantId: institute.id,
            participantImage: institute.image,
            lastMessage: '',
            lastMessageTime: '',
            participantRole: institute.role,
            myId: '',
            myRole: '',
          );
        }
      }

      if (targetChat != null) {
        controller.selectedChat.value = targetChat;
        controller.messages.clear();
        if (targetChat.id != '_') {
          await controller.fetchMessages(targetChat.id);
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          isInitializing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) controller.closeChat();
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(57.0),
          child: Obx(() {
            final chat = controller.selectedChat.value;

            return AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              leadingWidth: 56,
              leading: const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Center(child: StudentBackButton()),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat?.participantName ?? 'Chat',
                    style: AppTextStyles.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (chat?.participantRole != null)
                    Text(
                      chat!.participantRole,
                      style: AppTextStyles.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textTertiary,
                      ),
                    ),
                ],
              ),
              actions: [
                PopupMenuButton<ChatMenuAction>(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.fieldLabel,
                  ),
                  onSelected: (action) {
                    switch (action) {
                      case ChatMenuAction.delete:
                        _confirmDeleteConversation(chat);
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem<ChatMenuAction>(
                      value: ChatMenuAction.delete,
                      child: Row(
                        children: [
                          const AppActionIcon(
                            asset: AppImages.icDelete,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            AppStrings.labelDeleteChat,
                            style: AppTextStyles.outfit(
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
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(color: AppColors.background, height: 1.0),
              ),
            );
          }),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: isInitializing
                    ? const CommonLoading()
                    : Stack(
                        children: [
                          Obx(() {
                            if (controller.isLoading.value &&
                                controller.messages.isEmpty) {
                              return const CommonLoading();
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
                                return _buildMessageRow(index, message);
                              },
                            );
                          }),
                          _buildLoadingMoreIndicator(),
                          _buildScrollToBottomButton(),
                        ],
                      ),
              ),
              _buildMessageInput(context),
            ],
          ),
        ),
      ),
    );
  }

  // Top spinner shown while older message history is being paged in.
  Widget _buildLoadingMoreIndicator() {
    return Positioned(
      top: 12,
      left: 0,
      right: 0,
      child: Obx(
        () => controller.isLoadingMore.value
            ? const Center(child: CommonLoading(size: 22))
            : const SizedBox.shrink(),
      ),
    );
  }

  // Floating jump-to-bottom button — only visible once the user scrolls up
  // away from the newest message (controller.showScrollToBottom).
  Widget _buildScrollToBottomButton() {
    return Positioned(
      right: 16,
      bottom: 16,
      child: Obx(() {
        if (!controller.showScrollToBottom.value) {
          return const SizedBox.shrink();
        }
        return GestureDetector(
          onTap: controller.scrollToBottom,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.primaryBrand,
              size: 26,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEmptyChatView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
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
            'Say Hello to !',
            style: AppTextStyles.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.v8,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Click below to start your conversation.',
              textAlign: TextAlign.center,
              style: AppTextStyles.outfit(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          AppSpacing.v24,
          AppButton(
            label: 'Say Hello',
            backgroundColor: AppColors.primaryBrand,
            borderRadius: 12,
            width: 200,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            onPressed: () {
              controller.messageController.text = "Hello";
              controller.sendMessage();
            },
          ),
        ],
      ),
    );
  }

  // Wraps a bubble with a day separator ("Today" / "Yesterday" / date) when
  // this message starts a new calendar day relative to the previous one.
  Widget _buildMessageRow(int index, Message message) {
    final bubble = _buildMessageBubble(message);
    final createdAt = message.createdAt;
    if (createdAt == null) return bubble;

    final prevAt = index > 0 ? controller.messages[index - 1].createdAt : null;
    final showSeparator =
        index == 0 || DateFormatUtils.isDifferentDay(prevAt, createdAt);
    if (!showSeparator) return bubble;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ChatDateSeparator(label: DateFormatUtils.chatDaySeparator(createdAt)),
        bubble,
      ],
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
                style: AppTextStyles.outfit(
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
                    style: AppTextStyles.outfit(
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
                      AppStrings.labelTapToRetry,
                      style: AppTextStyles.outfit(
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
    if (url.isEmpty) return const SizedBox.shrink();

    final content = ChatAttachmentView(
      url: url,
      type: message.messageType,
      isMe: isMe,
    );

    // While the optimistic message is still uploading, overlay a progress
    // ring with the live percentage so the user can watch the upload move.
    // Once bytes finish uploading but the server is still processing, we
    // fall back to an indeterminate spinner for the short tail.
    if (isMe && message.status == MessageStatus.sending) {
      return Stack(
        children: [
          content,
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: Colors.black.withValues(alpha: 0.35),
                alignment: Alignment.center,
                child: _UploadProgressOverlay(localPath: url),
              ),
            ),
          ),
        ],
      );
    }
    return content;
  }

  Widget _buildStatusTick(MessageStatus status) {
    const sentColor = AppColors.fieldBg;
    const readColor = AppColors.subjectPhysics;

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
      child: Obx(
        () => controller.isRecording.value
            ? _buildRecordingBar()
            : _buildComposerRow(context),
      ),
    );
  }

  Widget _buildComposerRow(BuildContext context) {
    return Row(
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
                    style: AppTextStyles.outfit(fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: AppStrings.hintTypeMessage,
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
        const SizedBox(width: 8),
        // Mic — starts voice recording.
        GestureDetector(
          onTap: controller.startRecording,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.paleSilver.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mic_rounded,
              color: AppColors.primaryBrand,
              size: 22,
            ),
          ),
        ),
        const SizedBox(width: 8),
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
    );
  }

  // WhatsApp-style recording bar: cancel (trash) · red dot + timer · send.
  Widget _buildRecordingBar() {
    return Row(
      children: [
        IconButton(
          onPressed: controller.cancelRecording,
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: AppColors.bohoRed,
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.bohoRed,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Obx(
                () => Text(
                  controller.recordTimeLabel,
                  style: AppTextStyles.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                AppStrings.labelRecording,
                style: AppTextStyles.outfit(
                  fontSize: 13,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: controller.stopAndSendRecording,
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
            style: AppTextStyles.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteConversation(Chat? chat) {
    if (chat == null) return;
    CommonDialog.showDeleteConfirmation(
      title: AppStrings.labelDeleteChat,
      description:
          'Are you sure you want to delete your chat with '
          '${chat.participantName}? This will permanently remove all '
          'messages in this conversation.',
      onConfirm: () => controller.deleteConversation(chat),
    );
  }

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

/// Overlay shown on top of a sending attachment bubble. Reads live progress
/// from [ChatController.uploadingPath] / [ChatController.uploadProgress] and
/// shows a determinate ring + percentage while bytes are flowing. Falls back
/// to an indeterminate spinner for the brief window between 100% upload and
/// the server's response (so the overlay never blinks off prematurely).
class _UploadProgressOverlay extends StatelessWidget {
  final String localPath;
  const _UploadProgressOverlay({required this.localPath});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    return Obx(() {
      final isThisUpload = controller.uploadingPath.value == localPath;
      final percent = controller.uploadProgress.value;
      final showDeterminate = isThisUpload && percent > 0 && percent < 100;

      if (!showDeterminate) {
        return const SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.white,
          ),
        );
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              value: percent / 100,
              color: AppColors.white,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${percent.toInt()}%',
            style: AppTextStyles.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ],
      );
    });
  }
}
