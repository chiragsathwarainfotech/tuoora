enum ResourceType { image, video, document }

class ResourceModel {
  final String id;
  final String subject;
  final String description;
  final String fileName;
  final ResourceType type;
  final DateTime uploadedAt;
  final String batchId;

  ResourceModel({
    required this.id,
    required this.subject,
    required this.description,
    required this.fileName,
    required this.type,
    required this.uploadedAt,
    required this.batchId,
  });
}
