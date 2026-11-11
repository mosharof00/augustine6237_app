class CommentAuthor {
  final String id;
  final String name;
  final String? username;
  final String? avatarUrl;

  CommentAuthor({
    required this.id,
    required this.name,
    this.username,
    this.avatarUrl,
  });

  factory CommentAuthor.fromJson(Map<String, dynamic> json) {
    return CommentAuthor(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      username: json['username']?.toString(),
      avatarUrl: json['avatar_url']?.toString() ?? json['avatar']?.toString(),
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

class BetCommentModel {
  final String id;
  final String betId;
  final String content;
  final String stance;
  final String? createdAt;
  final CommentAuthor? author;

  BetCommentModel({
    required this.id,
    required this.betId,
    required this.content,
    required this.stance,
    this.createdAt,
    this.author,
  });

  factory BetCommentModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return BetCommentModel(
      id: data['id']?.toString() ?? '',
      betId: data['bet_id']?.toString() ?? '',
      content: data['content']?.toString() ?? '',
      stance: data['stance']?.toString() ?? 'SPECTATOR',
      createdAt: data['created_at']?.toString() ?? data['createdAt']?.toString(),
      author: data['author'] is Map<String, dynamic>
          ? CommentAuthor.fromJson(data['author'] as Map<String, dynamic>)
          : null,
    );
  }

  static List<BetCommentModel> fromJsonList(dynamic json) {
    final list = json is Map<String, dynamic> && json['data'] is List
        ? json['data'] as List
        : (json is List ? json : []);

    return list
        .map((item) => BetCommentModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

