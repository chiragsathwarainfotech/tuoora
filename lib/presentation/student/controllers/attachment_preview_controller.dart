import 'dart:io' as io;
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:tuoora/core/constants/api_constants.dart';
import 'package:tuoora/core/enums/app_enums.dart';
import 'package:tuoora/core/services/download_service.dart';
import 'package:tuoora/core/services/auth_service.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/presentation/student/models/assignment_model.dart';

class AttachmentPreviewArgs {
  final AssignmentAttachment attachment;
  final AttachmentSourceType sourceType;
  final String sourceId;
  final Future<void> Function()? onLoadPreview;

  AttachmentPreviewArgs({
    required this.attachment,
    required this.sourceType,
    required this.sourceId,
    this.onLoadPreview,
  });
}

class AttachmentPreviewController extends GetxController {
  final Rxn<AssignmentAttachment> selectedAttachment =
      Rxn<AssignmentAttachment>();
  final RxBool isAttachmentLoading = false.obs;
  final RxBool isDownloading = false.obs;
  final RxDouble downloadProgress = 0.0.obs;

  late final AttachmentSourceType sourceType;
  late final String sourceId;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is AttachmentPreviewArgs) {
      final args = Get.arguments as AttachmentPreviewArgs;
      selectedAttachment.value = args.attachment;
      sourceType = args.sourceType;
      sourceId = args.sourceId;

      if (args.onLoadPreview != null) {
        _loadPreview(args.onLoadPreview!);
      }
    }
  }

  Future<void> _loadPreview(Future<void> Function() loadFunc) async {
    isAttachmentLoading.value = true;
    try {
      await loadFunc();
    } finally {
      isAttachmentLoading.value = false;
    }
  }

  Future<void> downloadAttachment() async {
    final attachment = selectedAttachment.value;
    if (attachment == null) return;

    try {
      isDownloading.value = true;
      downloadProgress.value = 0.0;

      AppSnackBar.success(
        'Please wait, your file is being downloaded...',
        title: 'Downloading',
      );

      final downloadService = Get.find<DownloadService>();
      final authService = Get.find<AuthService>();
      final client = io.HttpClient();

      String endpoint = '';
      if (sourceType == AttachmentSourceType.assignment) {
        endpoint = '/student/homeworks/$sourceId/attachment/download';
      } else if (sourceType == AttachmentSourceType.resource) {
        endpoint = '/student/resources/$sourceId/download';
      }

      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final request = await client.getUrl(uri);
      request.headers.set(io.HttpHeaders.acceptHeader, '*/*');

      if (authService.isAuthenticated) {
        request.headers.set(
          io.HttpHeaders.authorizationHeader,
          'Bearer ${authService.token}',
        );
      }

      final response = await request.close();

      if (response.statusCode == 200) {
        final totalBytes = response.contentLength;
        int receivedBytes = 0;
        final List<int> byteList = [];

        await for (var data in response) {
          byteList.addAll(data);
          receivedBytes += data.length;
          if (totalBytes > 0) {
            downloadProgress.value = receivedBytes / totalBytes;
          }
        }

        final bytes = Uint8List.fromList(byteList);
        final ext = attachment.inferredExtension.toLowerCase();
        final fullFileName = attachment.name.contains('.')
            ? attachment.name
            : '${attachment.name}.$ext';

        await downloadService.saveFile(bytes: bytes, fileName: fullFileName);
      } else {
        throw Exception(
          'Failed to download file. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      AppSnackBar.error(
        'Failed to download file: ${e.toString().replaceAll('Exception: ', '')}',
      );
    } finally {
      isDownloading.value = false;
      downloadProgress.value = 0.0;
    }
  }
}
