class StudentHomeworkAttachmentModel {
  final int homeworkId;
  final String homeworkTitle;
  final String filename;
  final String extension;
  final String fileType;
  final String fileSize;
  final String previewUrl;
  final String downloadUrl;

  StudentHomeworkAttachmentModel({
    required this.homeworkId,
    required this.homeworkTitle,
    required this.filename,
    required this.extension,
    required this.fileType,
    required this.fileSize,
    required this.previewUrl,
    required this.downloadUrl,
  });

  factory StudentHomeworkAttachmentModel.fromJson(Map<String, dynamic> json) {
    return StudentHomeworkAttachmentModel(
      homeworkId: json['homework_id'] ?? 0,
      homeworkTitle: json['homework_title'] ?? '',
      filename: json['filename'] ?? '',
      extension: json['extension'] ?? '',
      fileType: json['file_type'] ?? '',
      fileSize: json['file_size'] ?? '',
      previewUrl: json['preview_url'] ?? '',
      downloadUrl: json['download_url'] ?? '',
    );
  }
}
