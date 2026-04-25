import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/models/resource_model.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_bottom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResourceDetailController extends GetxController {
  final isPlaying = false.obs;
  final progress = 0.3.obs;

  void togglePlay() {
    isPlaying.value = !isPlaying.value;
  }
}

class ResourceDetailScreen extends StatelessWidget {
  const ResourceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ResourceModel resource = Get.arguments;
    final controller = Get.put(ResourceDetailController(), tag: resource.id);

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
      bottomNavigationBar: InstituteBottomButton(
        label: AppStrings.instDownloadResourceBtn,
        icon: Icons.download_rounded,
        onTap: () =>
            Get.snackbar('Success', 'Downloading ${resource.fileName}...'),
      ),
    );
  }

  Widget _buildPreviewSection(
    ResourceModel resource,
    ResourceDetailController controller,
  ) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildMediaTypeContent(resource),
          if (resource.type == ResourceType.video)
            _buildVideoControls(controller),
        ],
      ),
    );
  }

  Widget _buildMediaTypeContent(ResourceModel resource) {
    switch (resource.type) {
      case ResourceType.image:
        return Image.network(
          'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800',
          fit: BoxFit.cover,
        );
      case ResourceType.video:
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=800',
              fit: BoxFit.cover,
            ),
            Container(color: Colors.black.withValues(alpha: 0.3)),
          ],
        );
      case ResourceType.document:
        return Container(
          color: AppColors.scaffoldBg,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.description_rounded,
                size: 80,
                color: AppColors.instPrimaryBlue,
              ),
              AppSpacing.v16,
              Text(
                resource.fileName,
                style: AppTextStyles.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              AppSpacing.v8,
              Text(
                'PDF Document • 2.4 MB',
                style: AppTextStyles.lexend(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildVideoControls(ResourceDetailController controller) {
    return Obx(
      () => Stack(
        children: [
          Center(
            child: GestureDetector(
              onTap: () => controller.togglePlay(),
              child: Container(
                padding: AppSpacing.all16,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  controller.isPlaying.value
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: AppColors.instPrimaryBlue,
                  size: 40,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: AppSpacing.all12,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Text(
                    '02:15',
                    style: AppTextStyles.lexend(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 12,
                        ),
                        activeTrackColor: AppColors.instPrimaryBlue,
                        inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
                        thumbColor: Colors.white,
                      ),
                      child: Slider(
                        value: controller.progress.value,
                        onChanged: (val) => controller.progress.value = val,
                      ),
                    ),
                  ),
                  Text(
                    '10:00',
                    style: AppTextStyles.lexend(
                      fontSize: 10,
                      color: Colors.white,
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
}
