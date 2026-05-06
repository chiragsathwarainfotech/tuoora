import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/models/resource_model.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_bottom_button.dart';
import 'package:fee_easy/data/repositories_impl/institute_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fee_easy/presentation/institute/controllers/resource_detail_controller.dart';
import 'package:fee_easy/core/widgets/common_loading.dart';
import 'package:chewie/chewie.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceDetailScreen extends StatelessWidget {
  const ResourceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ResourceModel resource = Get.arguments;
    final controller = Get.put(
      ResourceDetailController(Get.find<InstituteRepositoryImpl>()),
      tag: resource.id,
    );

    if (resource.type == ResourceType.video && resource.fileUrl != null) {
      controller.initializeVideo(resource.fileUrl!);
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            InstituteAppBar(
              title: AppStrings.instResourceDetailTitle,
              onBackTap: () => Get.back(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.x24.add(AppSpacing.y16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildPreviewSection(resource, controller),
                    AppSpacing.v32,
                    Text(
                      resource.subject,
                      style: AppTextStyles.manrope(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    AppSpacing.v12,
                    Text(
                      resource.description,
                      style: AppTextStyles.manrope(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    AppSpacing.v40,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => InstituteBottomButton(
          label: controller.isDownloading.value
              ? 'Downloading (${(controller.downloadProgress.value * 100).toInt()}%)'
              : AppStrings.instDownloadResourceBtn,
          icon: controller.isDownloading.value ? null : Icons.download_rounded,
          onTap: controller.isDownloading.value
              ? null
              : () => controller.downloadResource(
                  int.parse(resource.id),
                  resource.displayFileName,
                  resource.fileName.contains('.')
                      ? resource.fileName.split('.').last
                      : null,
                ),
        ),
      ),
    );
  }

  Widget _buildPreviewSection(
    ResourceModel resource,
    ResourceDetailController controller,
  ) {
    return Container(
      height: resource.type == ResourceType.video
          ? 240
          : (resource.type == ResourceType.image ? 400 : 200),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildMediaTypeContent(resource, controller),
    );
  }

  Widget _buildMediaTypeContent(
    ResourceModel resource,
    ResourceDetailController controller,
  ) {
    switch (resource.type) {
      case ResourceType.image:
        return GestureDetector(
          onTap: () => _showFullScreenImage(resource.fileUrl!),
          child: Hero(
            tag: 'resource_image_${resource.id}',
            child: Image.network(
              resource.fileUrl ?? '',
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const CommonLoading();
              },
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error),
            ),
          ),
        );
      case ResourceType.video:
        return Obx(() {
          if (!controller.isVideoInitialized.value) {
            return const CommonLoading();
          }
          return Chewie(controller: controller.chewieController!);
        });
      case ResourceType.document:
        return Container(
          color: AppColors.scaffoldBg,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.description_rounded,
                size: 80,
                color: AppColors.primaryBrand,
              ),
              AppSpacing.v16,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  resource.displayFileName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              AppSpacing.v16,
              if (resource.fileUrl != null)
                ElevatedButton.icon(
                  onPressed: () {
                    final url = resource.fileUrl!;
                    final previewUrl =
                        url.toLowerCase().endsWith('.pdf') ||
                            url.toLowerCase().endsWith('.doc') ||
                            url.toLowerCase().endsWith('.docx')
                        ? 'https://docs.google.com/viewer?url=$url'
                        : url;
                    launchUrl(
                      Uri.parse(previewUrl),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  icon: const Icon(Icons.visibility),
                  label: const Text('View Document'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBrand,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
            ],
          ),
        );
    }
  }

  void _showFullScreenImage(String url) {
    Get.to(
      Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: AppColors.white),
        ),
        body: Center(
          child: InteractiveViewer(
            child: Image.network(
              url,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const CommonLoading();
              },
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error),
            ),
          ),
        ),
      ),
      fullscreenDialog: true,
    );
  }
}
