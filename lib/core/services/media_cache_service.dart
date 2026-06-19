import 'dart:io';

import 'package:get/get.dart';

enum MediaDownloadStatus { idle, downloading, done, failed }

class MediaDownloadState {
  final MediaDownloadStatus status;
  final double progress; // 0.0 – 1.0
  final String? localPath;

  const MediaDownloadState({
    this.status = MediaDownloadStatus.idle,
    this.progress = 0,
    this.localPath,
  });

  MediaDownloadState copyWith({
    MediaDownloadStatus? status,
    double? progress,
    String? localPath,
  }) => MediaDownloadState(
    status: status ?? this.status,
    progress: progress ?? this.progress,
    localPath: localPath ?? this.localPath,
  );

  int get percent => (progress * 100).clamp(0, 100).round();
}

/// Downloads remote chat attachments to a temp cache directory and exposes
/// the live download state (idle / downloading-with-% / done / failed) per
/// URL. Backed by `dart:io` so it needs no extra packages, and caches files
/// under [Directory.systemTemp] keyed by a hash of the URL so re-opening the
/// same attachment is instant.
class MediaCacheService extends GetxService {
  final Map<String, Rx<MediaDownloadState>> _states = {};

  /// Reactive state for [url]. Always returns the same Rx instance for a
  /// given URL so multiple bubbles (and re-builds) observe one source.
  Rx<MediaDownloadState> stateFor(String url) =>
      _states.putIfAbsent(url, () => const MediaDownloadState().obs);

  /// Ensures [url] is available locally, returning the local file path.
  /// Streams the download and updates [stateFor] progress as bytes arrive.
  /// Returns null on failure (state is set to failed) or if a download for
  /// the same URL is already running.
  Future<String?> ensureDownloaded(String url, {String? suggestedName}) async {
    final state = stateFor(url);

    // Already downloaded this session — reuse if the file is still there.
    if (state.value.status == MediaDownloadStatus.done &&
        state.value.localPath != null) {
      if (await File(state.value.localPath!).exists()) {
        return state.value.localPath;
      }
    }
    if (state.value.status == MediaDownloadStatus.downloading) return null;

    try {
      final file = await _cacheFileFor(url, suggestedName);
      // On-disk cache hit from a previous run.
      if (await file.exists() && await file.length() > 0) {
        state.value = MediaDownloadState(
          status: MediaDownloadStatus.done,
          progress: 1,
          localPath: file.path,
        );
        return file.path;
      }

      state.value = const MediaDownloadState(
        status: MediaDownloadStatus.downloading,
      );

      final client = HttpClient();
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final total = response.contentLength;
      int received = 0;
      final sink = file.openWrite();
      await for (final chunk in response) {
        sink.add(chunk);
        received += chunk.length;
        if (total > 0) {
          state.value = state.value.copyWith(progress: received / total);
        }
      }
      await sink.close();
      client.close();

      state.value = MediaDownloadState(
        status: MediaDownloadStatus.done,
        progress: 1,
        localPath: file.path,
      );
      return file.path;
    } catch (_) {
      state.value = const MediaDownloadState(status: MediaDownloadStatus.failed);
      return null;
    }
  }

  Future<File> _cacheFileFor(String url, String? suggestedName) async {
    final dir = Directory('${Directory.systemTemp.path}/tuoora_chat_media');
    if (!await dir.exists()) await dir.create(recursive: true);
    return File('${dir.path}/${_safeNameFor(url, suggestedName)}');
  }

  String _safeNameFor(String url, String? suggestedName) {
    final base = url.hashCode.toUnsigned(32).toRadixString(16);
    final ext = _extensionFor(url);
    if (suggestedName != null && suggestedName.contains('.')) {
      return '${base}_$suggestedName';
    }
    return '$base$ext';
  }

  String _extensionFor(String url) {
    try {
      final last = Uri.parse(url).pathSegments.last;
      if (last.contains('.')) return '.${last.split('.').last}';
    } catch (_) {}
    return '';
  }
}
