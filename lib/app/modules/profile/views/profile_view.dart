import 'package:augustine6237/app/core/theme/app_color.dart';
import 'package:augustine6237/app/data/models/post_models/user_post_model.dart';
import 'package:augustine6237/app/data/models/review_models/user_review_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        elevation: 0,
        title: Obx(() {
          final profile = controller.profile.value;
          return Text(
            profile?.username != null ? '@${profile!.username}' : 'Profile',
            style: const TextStyle(
              color: AppColor.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          );
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColor.textSecondary),
            onPressed: () => controller.initLoad(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.profile.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.actionBack),
          );
        }

        final profile = controller.profile.value;
        if (profile == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_off, size: 64, color: AppColor.textDim),
                const SizedBox(height: 16),
                const Text(
                  'Profile not found or offline',
                  style: TextStyle(color: AppColor.textSecondary, fontSize: 16),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.actionBack,
                  ),
                  onPressed: () => controller.initLoad(),
                  child: const Text('Try Again', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppColor.actionBack,
          backgroundColor: AppColor.surface,
          onRefresh: () => controller.initLoad(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Profile Header Card
                _buildHeaderCard(context, profile),

                const SizedBox(height: 16),

                // 2. Betting Performance Stats
                _buildStatsGrid(profile),

                const SizedBox(height: 20),

                // 3. Tab Selector (Overview, Posts, Reviews)
                _buildTabSelector(),

                const SizedBox(height: 16),

                // 4. Tab Content
                Obx(() {
                  switch (controller.selectedTab.value) {
                    case 1:
                      return _buildPostsTab(context);
                    case 2:
                      return _buildReviewsTab(context, profile);
                    default:
                      return _buildOverviewTab(profile);
                  }
                }),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeaderCard(BuildContext context, dynamic profile) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.borderSubtle),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 34,
                backgroundColor: AppColor.surfaceSubtle,
                child: Text(
                  profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: AppColor.actionBack,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: const TextStyle(
                        color: AppColor.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (profile.username != null)
                      Text(
                        '@${profile.username}',
                        style: const TextStyle(
                          color: AppColor.actionBack,
                          fontSize: 14,
                        ),
                      ),
                    if (profile.bio != null && profile.bio.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        profile.bio,
                        style: const TextStyle(
                          color: AppColor.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: AppColor.borderSubtle, height: 1),
          const SizedBox(height: 14),

          // Social Counts Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCountColumn(
                'Followers',
                profile.followersCount.toString(),
              ),
              Container(width: 1, height: 28, color: AppColor.borderSubtle),
              _buildCountColumn(
                'Following',
                profile.followingCount.toString(),
              ),
              Container(width: 1, height: 28, color: AppColor.borderSubtle),
              _buildRatingColumn(profile.rating),
            ],
          ),

          // Action Buttons: Follow & Review
          if (!controller.isOwnProfile) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: profile.isFollowing
                          ? AppColor.surfaceSubtle
                          : AppColor.actionBack,
                      foregroundColor: AppColor.textPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: profile.isFollowing
                            ? const BorderSide(color: AppColor.borderSubtle)
                            : BorderSide.none,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => controller.toggleFollow(),
                    child: Text(
                      profile.isFollowing ? 'Following ✓' : 'Follow',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColor.textPrimary,
                    side: const BorderSide(color: AppColor.borderSubtle),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () => _showReviewModal(context),
                  child: const Text('Review'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCountColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColor.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppColor.textDim,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingColumn(dynamic rating) {
    final avg = rating?.average ?? 0.0;
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: AppColor.amber, size: 16),
            const SizedBox(width: 4),
            Text(
              avg > 0 ? avg.toStringAsFixed(1) : '—',
              style: const TextStyle(
                color: AppColor.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          '${rating?.count ?? 0} reviews',
          style: const TextStyle(
            color: AppColor.textDim,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(dynamic profile) {
    final stats = profile.stats;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Betting Performance',
            style: TextStyle(
              color: AppColor.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  title: 'Win Rate',
                  value: '${stats.winRate.toStringAsFixed(1)}%',
                  badgeColor: AppColor.statusSuccess,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricTile(
                  title: 'Record (W/L)',
                  value: '${stats.wins}W / ${stats.losses}L',
                  badgeColor: AppColor.actionBack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  title: 'Total Bets',
                  value: '${stats.totalBets}',
                  badgeColor: AppColor.textDim,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricTile(
                  title: 'Est. ROI',
                  value: stats.roi >= 0 ? '+${stats.roi}%' : '${stats.roi}%',
                  badgeColor: stats.roi >= 0
                      ? AppColor.statusSuccess
                      : AppColor.actionOppose,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required Color badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.surfaceSubtle,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColor.textDim,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: badgeColor,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.borderSubtle),
      ),
      child: Obx(
        () => Row(
          children: [
            _buildTabButton(0, 'Overview'),
            _buildTabButton(1, 'Posts (${controller.posts.length})'),
            _buildTabButton(2, 'Reviews (${controller.reviews.length})'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String title) {
    final isSelected = controller.selectedTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectedTab.value = index,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColor.actionBack.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColor.actionBack : AppColor.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab(dynamic profile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account Info',
            style: TextStyle(
              color: AppColor.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (profile.location != null && profile.location.isNotEmpty) ...[
            _buildInfoRow(Icons.location_on_outlined, 'Location', profile.location),
            const SizedBox(height: 8),
          ],
          _buildInfoRow(Icons.verified_user_outlined, 'Status', 'Verified Bettor'),
          if (profile.balance != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.account_balance_wallet_outlined,
              'Wallet Balance',
              '\$${profile.balance}',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColor.actionBack, size: 18),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(color: AppColor.textDim, fontSize: 13),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColor.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPostsTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (controller.isOwnProfile) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColor.borderSubtle),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColor.surfaceSubtle,
                  child: Icon(Icons.edit, color: AppColor.actionBack, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Share an update on your profile...',
                    style: TextStyle(color: AppColor.textDim, fontSize: 13),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.actionBack,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _showCreatePostModal(context),
                  child: const Text('Post', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],

        if (controller.posts.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColor.borderSubtle),
            ),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.photo_library_outlined, size: 48, color: AppColor.textDim),
                  const SizedBox(height: 12),
                  const Text(
                    'No profile posts yet',
                    style: TextStyle(color: AppColor.textSecondary, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Personal posts live strictly on this profile tab.',
                    style: TextStyle(color: AppColor.textDim, fontSize: 12),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.posts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final post = controller.posts[index];
              return _buildPostCard(post);
            },
          ),
      ],
    );
  }

  Widget _buildPostCard(UserPostModel post) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Post Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColor.surfaceSubtle,
                  child: Text(
                    post.author?.name.isNotEmpty == true
                        ? post.author!.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: AppColor.actionBack,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.author?.name ?? 'Bettor',
                        style: const TextStyle(
                          color: AppColor.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (post.locationTag != null && post.locationTag!.isNotEmpty)
                        Text(
                          post.locationTag!,
                          style: const TextStyle(color: AppColor.textDim, fontSize: 11),
                        ),
                    ],
                  ),
                ),
                if (controller.isOwnProfile)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColor.textDim, size: 18),
                    onPressed: () => controller.deletePost(post.id),
                  ),
              ],
            ),
          ),

          // Photo if present
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
            ClipRRect(
              child: Image.network(
                post.imageUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 140,
                  color: AppColor.surfaceSubtle,
                  child: const Center(
                    child: Icon(Icons.broken_image, color: AppColor.textDim),
                  ),
                ),
              ),
            ),

          // Caption
          if (post.caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                post.caption,
                style: const TextStyle(color: AppColor.textPrimary, fontSize: 13),
              ),
            ),

          // Like action bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => controller.toggleLikePost(post.id),
                  child: Row(
                    children: [
                      Icon(
                        post.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: post.isLiked ? AppColor.actionOppose : AppColor.textDim,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${post.likesCount}',
                        style: TextStyle(
                          color: post.isLiked ? AppColor.actionOppose : AppColor.textDim,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCreatePostModal(BuildContext context) {
    final captionController = TextEditingController();
    final imageController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Create Profile Post',
              style: TextStyle(
                color: AppColor.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: captionController,
              maxLines: 3,
              style: const TextStyle(color: AppColor.textPrimary),
              decoration: InputDecoration(
                hintText: 'Share a betting update, prediction, or thoughts...',
                hintStyle: const TextStyle(color: AppColor.textDim),
                filled: true,
                fillColor: AppColor.surfaceSubtle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColor.borderSubtle),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: imageController,
              style: const TextStyle(color: AppColor.textPrimary),
              decoration: InputDecoration(
                hintText: 'Image URL (optional)...',
                hintStyle: const TextStyle(color: AppColor.textDim),
                filled: true,
                fillColor: AppColor.surfaceSubtle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColor.borderSubtle),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.actionBack,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                final caption = captionController.text.trim();
                final img = imageController.text.trim();
                if (caption.isEmpty && img.isEmpty) return;
                Get.back();
                await controller.createPost(
                  caption: caption,
                  imageUrl: img.isNotEmpty ? img : null,
                );
              },
              child: const Text('Publish Post', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildReviewsTab(BuildContext context, dynamic profile) {
    if (controller.reviews.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.borderSubtle),
        ),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.rate_review_outlined,
                  size: 48, color: AppColor.textDim),
              const SizedBox(height: 12),
              const Text(
                'No reviews yet',
                style: TextStyle(color: AppColor.textSecondary, fontSize: 15),
              ),
              const SizedBox(height: 4),
              const Text(
                'Be the first to review this bettor!',
                style: TextStyle(color: AppColor.textDim, fontSize: 12),
              ),
              if (!controller.isOwnProfile) ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.actionBack,
                  ),
                  onPressed: () => _showReviewModal(context),
                  child: const Text('Write Review',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.reviews.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final review = controller.reviews[index];
        return _buildReviewCard(review);
      },
    );
  }

  Widget _buildReviewCard(UserReviewModel review) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review.author?.name ?? 'Anonymous Bettor',
                style: const TextStyle(
                  color: AppColor.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (starIndex) => Icon(
                    starIndex < review.rating ? Icons.star : Icons.star_border,
                    color: AppColor.amber,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          if (review.comment != null && review.comment!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              review.comment!,
              style: const TextStyle(
                color: AppColor.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showReviewModal(BuildContext context) {
    int rating = 5;
    final commentController = TextEditingController();

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Rate & Review Bettor',
                  style: TextStyle(
                    color: AppColor.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                // Star Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starVal = index + 1;
                    return IconButton(
                      icon: Icon(
                        starVal <= rating ? Icons.star : Icons.star_border,
                        color: AppColor.amber,
                        size: 32,
                      ),
                      onPressed: () {
                        setModalState(() {
                          rating = starVal;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: commentController,
                  maxLines: 3,
                  style: const TextStyle(color: AppColor.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Share your experience with this bettor...',
                    hintStyle: const TextStyle(color: AppColor.textDim),
                    filled: true,
                    fillColor: AppColor.surfaceSubtle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColor.borderSubtle),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColor.actionBack),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.actionBack,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    Get.back();
                    await controller.submitReview(
                      rating: rating,
                      comment: commentController.text.trim(),
                    );
                  },
                  child: const Text(
                    'Submit Review',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}
