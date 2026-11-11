import 'package:augustine6237/app/core/network/api_client.dart';
import 'package:augustine6237/app/core/network/api_endpoints.dart';
import 'package:augustine6237/app/data/models/post_models/user_post_model.dart';
import 'package:augustine6237/app/data/models/review_models/user_review_model.dart';
import 'package:augustine6237/app/data/models/user_models/user_profile_model.dart';

abstract class IProfileRepository {
  Future<UserProfileModel> getProfile(String id);
  Future<Map<String, dynamic>> toggleFollow(String id);
  Future<List<UserReviewModel>> getReviews(String id);
  Future<dynamic> createReview({
    required String userId,
    required int rating,
    String? comment,
  });
  Future<List<UserPostModel>> getPosts(String userId);
  Future<UserPostModel> createPost({
    required String caption,
    String? imageUrl,
    String? locationTag,
  });
  Future<void> deletePost(String postId);
  Future<Map<String, dynamic>> toggleLikePost(String postId);
}

class ProfileRepository implements IProfileRepository {
  final ApiClient _client;

  ProfileRepository(this._client);

  @override
  Future<UserProfileModel> getProfile(String id) {
    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.userProfile(id)),
      (dynamic data) => UserProfileModel.fromJson(data as Map<String, dynamic>),
      'Get Profile',
    );
  }

  @override
  Future<Map<String, dynamic>> toggleFollow(String id) {
    return _client.handleRequest(
      () => _client.dio.post(ApiEndpoint.userFollow(id)),
      (dynamic data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
      'Toggle Follow',
    );
  }

  @override
  Future<List<UserReviewModel>> getReviews(String id) {
    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.userReviews(id)),
      (dynamic data) => UserReviewModel.fromJsonList(data),
      'Get Reviews',
    );
  }

  @override
  Future<dynamic> createReview({
    required String userId,
    required int rating,
    String? comment,
  }) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.userReviews(userId),
        data: {
          'rating': rating,
          if (comment != null && comment.isNotEmpty) 'comment': comment,
        },
      ),
      (dynamic data) => data,
      'Create Review',
    );
  }

  @override
  Future<List<UserPostModel>> getPosts(String userId) {
    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.userPosts(userId)),
      (dynamic data) => UserPostModel.fromJsonList(data),
      'Get Posts',
    );
  }

  @override
  Future<UserPostModel> createPost({
    required String caption,
    String? imageUrl,
    String? locationTag,
  }) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.createPost,
        data: {
          'caption': caption,
          if (imageUrl != null && imageUrl.isNotEmpty) 'image_url': imageUrl,
          if (locationTag != null && locationTag.isNotEmpty)
            'location_tag': locationTag,
        },
      ),
      (dynamic data) => UserPostModel.fromJson(data as Map<String, dynamic>),
      'Create Post',
    );
  }

  @override
  Future<void> deletePost(String postId) {
    return _client.handleRequest(
      () => _client.dio.delete(ApiEndpoint.deletePost(postId)),
      (dynamic data) {},
      'Delete Post',
    );
  }

  @override
  Future<Map<String, dynamic>> toggleLikePost(String postId) {
    return _client.handleRequest(
      () => _client.dio.post(ApiEndpoint.likePost(postId)),
      (dynamic data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
      'Toggle Like Post',
    );
  }
}

