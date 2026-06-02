import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/widgets/common_loading.dart';

/// Full-screen in-app resource viewer. Picks the right native player per
/// resource type so each kind of media is presented properly:
///   - [InAppResourceViewer.image] → [InteractiveViewer] for pinch zoom
///   - [InAppResourceViewer.video] → [Chewie] for native video controls
///   - [InAppResourceViewer.web]   → [WebViewWidget] for documents
///     (Office / PDF are wrapped with Google Docs Viewer)
///
/// All modes share the same chrome: light-black scrim background and a
/// round X-button in the top-right that pops the route.
class InAppResourceViewer extends StatefulWidget {
  final String url;
  final String title;
  final _ViewerMode _mode;

  const InAppResourceViewer._({
    required this.url,
    required this.title,
    required _ViewerMode mode,
  }) : _mode = mode;

  factory InAppResourceViewer.image({
    required String url,
    required String title,
  }) => InAppResourceViewer._(
    url: url,
    title: title,
    mode: _ViewerMode.image,
  );

  factory InAppResourceViewer.video({
    required String url,
    required String title,
  }) => InAppResourceViewer._(
    url: url,
    title: title,
    mode: _ViewerMode.video,
  );

  factory InAppResourceViewer.audio({
    required String url,
    required String title,
  }) => InAppResourceViewer._(
    url: url,
    title: title,
    mode: _ViewerMode.audio,
  );

  factory InAppResourceViewer.web({
    required String url,
    required String title,
  }) => InAppResourceViewer._(
    url: url,
    title: title,
    mode: _ViewerMode.web,
  );

  @override
  State<InAppResourceViewer> createState() => _InAppResourceViewerState();
}

enum _ViewerMode { image, video, audio, web }

class _InAppResourceViewerState extends State<InAppResourceViewer> {
  WebViewController? _webController;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  final _loading = true.obs;
  final _errorMessage = ''.obs;

  /// A path that isn't an http(s) URL is a local cached file.
  bool get _isLocal => !widget.url.startsWith('http');

  @override
  void initState() {
    super.initState();
    switch (widget._mode) {
      case _ViewerMode.image:
        _loading.value = false;
        break;
      case _ViewerMode.video:
      case _ViewerMode.audio:
        _initVideo();
        break;
      case _ViewerMode.web:
        _initWeb();
        break;
    }
  }

  Future<void> _initVideo() async {
    try {
      // video_player handles audio-only files too — Chewie just shows the
      // transport controls over a black surface for audio.
      _videoController = _isLocal
          ? VideoPlayerController.file(File(widget.url))
          : VideoPlayerController.networkUrl(Uri.parse(widget.url));
      await _videoController!.initialize();
      final isAudio = widget._mode == _ViewerMode.audio;
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        looping: false,
        aspectRatio: isAudio ? 16 / 9 : _videoController!.value.aspectRatio,
        allowFullScreen: !isAudio,
        allowPlaybackSpeedChanging: true,
        // Hide Chewie's built-in 3-dot popup menu in the top-right — it
        // overlapped the screen's own X-close button and looked broken.
        showOptions: false,
        placeholder: const CommonLoading(color: AppColors.white),
      );
      _loading.value = false;
    } catch (e) {
      _errorMessage.value = widget._mode == _ViewerMode.audio
          ? 'Failed to load audio.'
          : 'Failed to load video.';
      _loading.value = false;
    }
  }

  void _initWeb() {
    try {
      _webController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.black)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (_) => _loading.value = false,
            onWebResourceError: (e) {
              _errorMessage.value = 'Failed to load: ${e.description}';
              _loading.value = false;
            },
          ),
        );
      if (_isLocal) {
        _webController!.loadFile(widget.url);
      } else {
        _webController!.loadRequest(Uri.parse(_resolvedUrl(widget.url)));
      }
    } catch (e) {
      _errorMessage.value = 'Viewer not available.';
      _loading.value = false;
    }
  }

  // Office / PDF won't render natively in WebView; wrap them with the
  // Google Docs Viewer so they render as HTML in-app.
  String _resolvedUrl(String raw) {
    final lower = raw.toLowerCase();
    const docExts = ['.pdf', '.doc', '.docx', '.ppt', '.pptx', '.xls', '.xlsx'];
    if (docExts.any(lower.endsWith)) {
      return 'https://docs.google.com/viewer?embedded=true&url=$raw';
    }
    return raw;
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.92),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: _buildBody()),
            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  Material(
                    color: AppColors.white.withValues(alpha: 0.15),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Get.back(),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.close_rounded,
                          color: AppColors.white,
                          size: 22,
                        ),
                      ),
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

  Widget _buildBody() {
    return Obx(() {
      if (_errorMessage.value.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Text(
              _errorMessage.value,
              textAlign: TextAlign.center,
              style: AppTextStyles.outfit(
                fontSize: 14,
                color: AppColors.white,
              ),
            ),
          ),
        );
      }

      switch (widget._mode) {
        case _ViewerMode.image:
          return _buildImage();
        case _ViewerMode.video:
        case _ViewerMode.audio:
          return _buildVideo();
        case _ViewerMode.web:
          return _buildWeb();
      }
    });
  }

  Widget _buildImage() {
    final Widget image = _isLocal
        ? Image.file(
            File(widget.url),
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.broken_image_rounded,
              color: AppColors.white,
              size: 48,
            ),
          )
        : Image.network(
            widget.url,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const CommonLoading(color: AppColors.white);
            },
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.broken_image_rounded,
              color: AppColors.white,
              size: 48,
            ),
          );
    return InteractiveViewer(child: Center(child: image));
  }

  Widget _buildVideo() {
    if (_loading.value || _chewieController == null) {
      return const Center(child: CommonLoading(color: AppColors.white));
    }
    return Center(child: Chewie(controller: _chewieController!));
  }

  Widget _buildWeb() {
    return Stack(
      children: [
        // Leave room for the X-button row at the top.
        Padding(
          padding: const EdgeInsets.only(top: 56),
          child: WebViewWidget(controller: _webController!),
        ),
        if (_loading.value)
          const Center(child: CommonLoading(color: AppColors.white)),
      ],
    );
  }
}
