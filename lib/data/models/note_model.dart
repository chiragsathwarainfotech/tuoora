class NoteCategory {
  final int id;
  final String name;
  final String color;

  NoteCategory({
    required this.id,
    required this.name,
    required this.color,
  });

  factory NoteCategory.fromJson(Map<String, dynamic> json) {
    return NoteCategory(
      id: json['id'],
      name: json['name'] ?? '',
      color: json['color'] ?? '#3b82f6',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
    };
  }
}

class Note {
  final int id;
  final int userId;
  final int? categoryId;
  final String title;
  final String category;
  final String content;
  final bool isBookmarked;
  final bool isArchived;
  final String? imageUrl;
  final DateTime createdAt;
  final NoteCategory? categoryRelation;

  Note({
    required this.id,
    required this.userId,
    this.categoryId,
    required this.title,
    required this.category,
    required this.content,
    required this.isBookmarked,
    required this.isArchived,
    this.imageUrl,
    required this.createdAt,
    this.categoryRelation,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      userId: json['user_id'] ?? 0,
      categoryId: json['category_id'],
      title: json['title'] ?? '',
      category: json['category'] ?? 'Uncategorized',
      content: json['content'] ?? '',
      isBookmarked: json['is_bookmarked'] ?? false,
      isArchived: json['is_archived'] ?? false,
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      categoryRelation: json['category_relation'] != null 
          ? NoteCategory.fromJson(json['category_relation']) 
          : null,
    );
  }

  Note copyWith({
    int? id,
    int? userId,
    int? categoryId,
    String? title,
    String? category,
    String? content,
    bool? isBookmarked,
    bool? isArchived,
    String? imageUrl,
    DateTime? createdAt,
    NoteCategory? categoryRelation,
  }) {
    return Note(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      category: category ?? this.category,
      content: content ?? this.content,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isArchived: isArchived ?? this.isArchived,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      categoryRelation: categoryRelation ?? this.categoryRelation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'title': title,
      'category': category,
      'content': content,
      'is_bookmarked': isBookmarked,
      'is_archived': isArchived,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'category_relation': categoryRelation?.toJson(),
    };
  }
}

class NoteListResponse {
  final List<Note> data;
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;

  NoteListResponse({
    required this.data,
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
  });

  factory NoteListResponse.fromJson(Map<String, dynamic> json) {
    final pagination = json['pagination'] ?? {};
    return NoteListResponse(
      data: (json['data'] as List).map((i) => Note.fromJson(i)).toList(),
      total: pagination['total'] ?? 0,
      perPage: pagination['per_page'] ?? 15,
      currentPage: pagination['current_page'] ?? 1,
      lastPage: pagination['last_page'] ?? 1,
    );
  }
}
