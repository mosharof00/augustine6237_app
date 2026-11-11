class ReviewAuthor {
  final String id;
  final String name;
  final String? username;
  final String? avatarUrl;

  ReviewAuthor({
    required this.id,
    required this.name,
    this.username,
    this.avatarUrl,
  });

  factory ReviewAuthor.fromJson(Map<String, dynamic> json) {
    return ReviewAuthor(
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

class UserReviewModel {
  final String id;
  final int rating;
  final String? comment;
  final String? createdAt;
  final ReviewAuthor? author;

  UserReviewModel({
    required this.id,
    required this.rating,
    this.comment,
    this.createdAt,
    this.author,
  });

  factory UserReviewModel.fromJson(Map<String, dynamic> json) {
    return UserReviewModel(
      id: json['id']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 5,
      comment: json['comment']?.toString(),
      createdAt: json['created_at']?.toString() ?? json['createdAt']?.toString(),
      author: json['author'] is Map<String, dynamic>
          ? ReviewAuthor.fromJson(json['author'] as Map<String, dynamic>)
          : null,
    );
  }

  static List<UserReviewModel> fromJsonList(dynamic json) {
    final list = json is Map<String, dynamic> && json['data'] is List
        ? json['data'] as List
        : (json is List ? json : []);

    return list
        .map((item) => UserReviewModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

