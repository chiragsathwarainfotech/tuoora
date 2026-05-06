class Note {
  final String id;
  final String title;
  final String content;
  final String createdAt;
  final bool isBookmarked;
  final String? tag;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.isBookmarked = false,
    this.tag,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['created_at'] ?? '',
      isBookmarked: json['is_bookmarked'] ?? false,
      tag: json['tag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt,
      'is_bookmarked': isBookmarked,
      'tag': tag,
    };
  }

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? createdAt,
    bool? isBookmarked,
    String? tag,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      tag: tag ?? this.tag,
    );
  }
}
