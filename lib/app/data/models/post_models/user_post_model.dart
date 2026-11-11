class PostAuthor {
  final String id;
  final String name;
  final String? username;
  final String? avatarUrl;

  PostAuthor({
    required this.id,
    required this.name,
    this.username,
    this.avatarUrl,
  });

  factory PostAuthor.fromJson(Map<String, dynamic> json) {
    return PostAuthor(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      username: json['username']?.toString(),
      avatarUrl: json['avatar_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'avatar_url': avatarUrl,
    };
  }
}

class UserPostModel {
  final String id;
  final String caption;
  final String? imageUrl;
  final String? locationTag;
  final String? createdAt;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final PostAuthor? author;

  UserPostModel({
    required this.id,
    required this.caption,
    this.imageUrl,
    this.locationTag,
    this.createdAt,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    this.author,
  });

  factory UserPostModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return UserPostModel(
      id: data['id']?.toString() ?? '',
      caption: data['caption']?.toString() ?? '',
      imageUrl: data['image_url']?.toString(),
      locationTag: data['location_tag']?.toString(),
      createdAt: data['created_at']?.toString() ?? data['createdAt']?.toString(),
      likesCount: (data['likes_count'] as num?)?.toInt() ?? 0,
      commentsCount: (data['comments_count'] as num?)?.toInt() ?? 0,
      isLiked: data['is_liked'] == true,
      author: data['author'] is Map<String, dynamic>
          ? PostAuthor.fromJson(data['author'] as Map<String, dynamic>)
          : null,
    );
  }

  static List<UserPostModel> fromJsonList(dynamic json) {
    final list = json is Map<String, dynamic> && json['data'] is List
        ? json['data'] as List
        : (json is List ? json : []);

    return list
        .map((item) => UserPostModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  UserPostModel copyWith({
    bool? isLiked,
    int? likesCount,
    int? commentsCount,
  }) {
    return UserPostModel(
      id: id,
      caption: caption,
      imageUrl: imageUrl,
      locationTag: locationTag,
      createdAt: createdAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      author: author,
    );
  }
}

