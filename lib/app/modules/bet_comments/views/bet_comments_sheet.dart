import 'package:augustine6237/app/core/theme/app_color.dart';
import 'package:augustine6237/app/data/models/bet_models/bet_comment_model.dart';
import 'package:augustine6237/app/data/repositories/bet_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bet_comments_controller.dart';

class BetCommentsSheet extends StatelessWidget {
  final String betId;
  final String? betTitle;

  const BetCommentsSheet({super.key, required this.betId, this.betTitle});

  static void show(
    BuildContext context, {
    required String betId,
    String? betTitle,
  }) {
    if (!Get.isRegistered<BetCommentsController>()) {
      Get.put(BetCommentsController(Get.find<IBetRepository>()));
    }
    final controller = Get.find<BetCommentsController>();
    controller.loadComments(betId);

    Get.bottomSheet(
      BetCommentsSheet(betId: betId, betTitle: betTitle),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BetCommentsController>();
    final textController = TextEditingController();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColor.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        'Bettor Discussion (${controller.comments.length})',
                        style: const TextStyle(
                          color: AppColor.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (betTitle != null)
                      Text(
                        betTitle!,
                        style: const TextStyle(
                          color: AppColor.textDim,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColor.textDim),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
          const Divider(color: AppColor.borderSubtle, height: 1),

          // Comments List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.comments.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColor.actionBack),
                );
              }

              if (controller.comments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.forum_outlined,
                        size: 48,
                        color: AppColor.textDim,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'No comments yet',
                        style: TextStyle(
                          color: AppColor.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Be the first bettor to state your position!',
                        style: TextStyle(color: AppColor.textDim, fontSize: 12),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.comments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final comment = controller.comments[index];
                  return _buildCommentTile(controller, comment);
                },
              );
            }),
          ),

          const Divider(color: AppColor.borderSubtle, height: 1),

          // Input Bar with Stance Selector
          Container(
            padding: EdgeInsets.only(
              left: 14,
              right: 14,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 12,
            ),
            color: AppColor.darkBackground,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Stance selector row
                Obx(
                  () => Row(
                    children: [
                      _buildStanceChip(
                        controller,
                        label: 'Back (Yes)',
                        value: 'BACK',
                        color: AppColor.actionBack,
                      ),
                      const SizedBox(width: 8),
                      _buildStanceChip(
                        controller,
                        label: 'Oppose (No)',
                        value: 'OPPOSE',
                        color: AppColor.actionOppose,
                      ),
                      const SizedBox(width: 8),
                      _buildStanceChip(
                        controller,
                        label: 'Neutral',
                        value: 'SPECTATOR',
                        color: AppColor.textDim,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Text field + send button
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textController,
                        style: const TextStyle(color: AppColor.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Share your analysis or stance...',
                          hintStyle: const TextStyle(
                            color: AppColor.textDim,
                            fontSize: 13,
                          ),
                          filled: true,
                          fillColor: AppColor.surfaceSubtle,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColor.borderSubtle,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColor.actionBack,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Obx(
                      () => IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: AppColor.actionBack,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(12),
                        ),
                        onPressed: controller.isSending.value
                            ? null
                            : () async {
                                final text = textController.text.trim();
                                if (text.isEmpty) return;
                                final ok = await controller.sendComment(text);
                                if (ok) textController.clear();
                              },
                        icon: controller.isSending.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.send, size: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStanceChip(
    BetCommentsController controller, {
    required String label,
    required String value,
    required Color color,
  }) {
    final isSelected = controller.selectedStance.value == value;
    return GestureDetector(
      onTap: () => controller.selectedStance.value = value,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? color : AppColor.borderSubtle),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : AppColor.textDim,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCommentTile(
    BetCommentsController controller,
    BetCommentModel comment,
  ) {
    Color stanceColor = AppColor.textDim;
    if (comment.stance == 'BACK') stanceColor = AppColor.actionBack;
    if (comment.stance == 'OPPOSE') stanceColor = AppColor.actionOppose;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.surfaceSubtle,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColor.darkBackground,
                child: Text(
                  comment.author?.name.isNotEmpty == true
                      ? comment.author!.name[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: AppColor.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      comment.author?.name ?? 'Bettor',
                      style: const TextStyle(
                        color: AppColor.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: stanceColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        comment.stance,
                        style: TextStyle(
                          color: stanceColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.isOwnComment(comment))
                GestureDetector(
                  onTap: () => controller.deleteComment(comment.id),
                  child: const Icon(
                    Icons.delete_outline,
                    size: 16,
                    color: AppColor.textDim,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            comment.content,
            style: const TextStyle(color: AppColor.textPrimary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
