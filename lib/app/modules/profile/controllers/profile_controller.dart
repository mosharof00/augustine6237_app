import 'package:augustine6237/app/core/services/secure_storage_service.dart';
import 'package:augustine6237/app/core/theme/app_color.dart';
import 'package:augustine6237/app/core/utils/helper_utils.dart';
import 'package:augustine6237/app/data/models/post_models/user_post_model.dart';
import 'package:augustine6237/app/data/models/review_models/user_review_model.dart';
import 'package:augustine6237/app/data/models/user_models/user_profile_model.dart';
import 'package:augustine6237/app/data/repositories/profile_repository.dart';
import 'package:augustine6237/app/global/widgets/global_snackbar.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final IProfileRepository _profileRepo;

  ProfileController(this._profileRepo);

  final isLoading = false.obs;
  final isTogglingFollow = false.obs;
  final isSubmittingReview = false.obs;
  final isCreatingPost = false.obs;
  final selectedTab = 0.obs; // 0 = Overview, 1 = Posts, 2 = Reviews

  final Rxn<UserProfileModel> profile = Rxn<UserProfileModel>();
  final RxList<UserPostModel> posts = <UserPostModel>[].obs;
  final RxList<UserReviewModel> reviews = <UserReviewModel>[].obs;
  final RxString activeUserId = ''.obs;

  bool get isOwnProfile =>
      activeUserId.value.isEmpty || activeUserId.value == HelperUtils.userId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is String && args.isNotEmpty) {
      activeUserId.value = args;
    }
    initLoad();
  }

  Future<void> initLoad() async {
    if (activeUserId.value.isEmpty) {
      final storedId = HelperUtils.userId.isNotEmpty
          ? HelperUtils.userId
          : await SecureStorageService.instance.getUserID();
      if (storedId != null && storedId.isNotEmpty) {
        activeUserId.value = storedId;
      }
    }

    if (activeUserId.value.isNotEmpty) {
      await Future.wait([
        fetchProfile(activeUserId.value),
        fetchPosts(activeUserId.value),
        fetchReviews(activeUserId.value),
      ]);
    }
  }

  Future<void> fetchProfile(String userId) async {
    try {
      isLoading.value = true;
      final res = await _profileRepo.getProfile(userId);
      profile.value = res;
    } catch (e) {
      globalSnackBar(
        title: 'Error',
        message: 'Failed to load user profile: $e',
        backgroundColor: AppColor.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPosts(String userId) async {
    try {
      final res = await _profileRepo.getPosts(userId);
      posts.assignAll(res);
    } catch (_) {
      // Non-blocking for posts
    }
  }

  Future<void> fetchReviews(String userId) async {
    try {
      final res = await _profileRepo.getReviews(userId);
      reviews.assignAll(res);
    } catch (_) {
      // Non-blocking for reviews list
    }
  }

  Future<void> toggleFollow() async {
    final current = profile.value;
    if (current == null || isTogglingFollow.value) return;

    final wasFollowing = current.isFollowing;
    final newFollowersCount = wasFollowing
        ? (current.followersCount > 0 ? current.followersCount - 1 : 0)
        : current.followersCount + 1;

    // Optimistic UI update
    profile.value = current.copyWith(
      isFollowing: !wasFollowing,
      followersCount: newFollowersCount,
    );

    try {
      isTogglingFollow.value = true;
      final res = await _profileRepo.toggleFollow(current.id);
      if (res['data'] is Map<String, dynamic>) {
        final data = res['data'] as Map<String, dynamic>;
        profile.value = profile.value?.copyWith(
          isFollowing: data['is_following'] as bool?,
          followersCount: (data['followers_count'] as num?)?.toInt(),
        );
      }
    } catch (e) {
      // Revert optimistic update on failure
      profile.value = current;
      globalSnackBar(
        title: 'Follow Error',
        message: 'Unable to update follow: $e',
        backgroundColor: AppColor.error,
      );
    } finally {
      isTogglingFollow.value = false;
    }
  }

  Future<bool> createPost({
    required String caption,
    String? imageUrl,
    String? locationTag,
  }) async {
    try {
      isCreatingPost.value = true;
      final newPost = await _profileRepo.createPost(
        caption: caption,
        imageUrl: imageUrl,
        locationTag: locationTag,
      );
      posts.insert(0, newPost);
      globalSnackBar(
        title: 'Success',
        message: 'Post created on your profile!',
        backgroundColor: AppColor.statusSuccess,
      );
      return true;
    } catch (e) {
      globalSnackBar(
        title: 'Post Error',
        message: 'Failed to create post: $e',
        backgroundColor: AppColor.error,
      );
      return false;
    } finally {
      isCreatingPost.value = false;
    }
  }

  Future<void> deletePost(String postId) async {
    final original = List<UserPostModel>.from(posts);
    posts.removeWhere((p) => p.id == postId);

    try {
      await _profileRepo.deletePost(postId);
      globalSnackBar(
        title: 'Post Deleted',
        message: 'Post was removed from your profile',
        backgroundColor: AppColor.statusSuccess,
      );
    } catch (e) {
      posts.assignAll(original);
      globalSnackBar(
        title: 'Delete Error',
        message: 'Failed to delete post: $e',
        backgroundColor: AppColor.error,
      );
    }
  }

  Future<void> toggleLikePost(String postId) async {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final currentPost = posts[index];
    final wasLiked = currentPost.isLiked;
    final newCount = wasLiked
        ? (currentPost.likesCount > 0 ? currentPost.likesCount - 1 : 0)
        : currentPost.likesCount + 1;

    posts[index] = currentPost.copyWith(
      isLiked: !wasLiked,
      likesCount: newCount,
    );

    try {
      final res = await _profileRepo.toggleLikePost(postId);
      if (res['data'] is Map<String, dynamic>) {
        final data = res['data'] as Map<String, dynamic>;
        posts[index] = currentPost.copyWith(
          isLiked: data['is_liked'] as bool?,
          likesCount: (data['likes_count'] as num?)?.toInt(),
        );
      }
    } catch (_) {
      posts[index] = currentPost;
    }
  }

  Future<bool> submitReview({required int rating, String? comment}) async {
    final current = profile.value;
    if (current == null) return false;

    try {
      isSubmittingReview.value = true;
      await _profileRepo.createReview(
        userId: current.id,
        rating: rating,
        comment: comment,
      );
      globalSnackBar(
        title: 'Success',
        message: 'Review posted successfully!',
        backgroundColor: AppColor.statusSuccess,
      );
      await fetchReviews(current.id);
      await fetchProfile(current.id);
      return true;
    } catch (e) {
      globalSnackBar(
        title: 'Review Error',
        message: 'Failed to post review: $e',
        backgroundColor: AppColor.error,
      );
      return false;
    } finally {
      isSubmittingReview.value = false;
    }
  }
}
