import 'package:fee_easy/data/repositories_impl/institute_repository_impl.dart';
import 'package:fee_easy/core/services/download_service.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/widgets/common_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ResourceDetailController extends GetxController {
  final InstituteRepositoryImpl _repository;
  final DownloadService _downloadService = Get.find<DownloadService>();

  ResourceDetailController(this._repository);

  final isPlaying = false.obs;
  final progress = 0.0.obs;
  final downloadProgress = 0.0.obs;
  final isDownloading = false.obs;

  // Video Player
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  final isVideoInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> initializeVideo(String url) async {
    try {
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
      await videoPlayerController!.initialize();
      
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        autoPlay: false,
        looping: false,
        aspectRatio: videoPlayerController!.value.aspectRatio,
        allowFullScreen: true,
        allowPlaybackSpeedChanging: true,
        placeholder: const CommonLoading(color: AppColors.white),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: AppColors.white),
            ),
          );
        },
      );
      
      isVideoInitialized.value = true;
    } catch (e) {
      print('Video Initialization Error: $e');
    }
  }

  void togglePlay() {
    isPlaying.value = !isPlaying.value;
  }

  Future<void> downloadResource(
    int resourceId,
    String fileName,
    String? extension,
  ) async {
    try {
      isDownloading.value = true;
      downloadProgress.value = 0.0;

      Get.snackbar(
        'Downloading',
        'Please wait, your file is being downloaded...',
        snackPosition: SnackPosition.BOTTOM,
        showProgressIndicator: true,
        backgroundColor: AppColors.primaryBrand,
        colorText: AppColors.white,
      );

      final bytes = await _repository.downloadResource(
        resourceId,
        onProgress: (p) {
          downloadProgress.value = p;
        },
      );

      // If extension is not provided, we can try to guess it or just use a default
      final fullFileName = extension != null && !fileName.contains('.')
          ? '$fileName.$extension'
          : fileName;

      await _downloadService.saveFile(bytes: bytes, fileName: fullFileName);

      // We don't need a second snackbar here as saveFile already shows one on success.
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to download file: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: AppColors.white,
      );
    } finally {
      isDownloading.value = false;
      downloadProgress.value = 0.0;
    }
  }

  @override
  void onClose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.onClose();
  }
}
