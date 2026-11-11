import 'package:augustine6237/app/core/theme/app_color.dart';
import 'package:augustine6237/app/core/utils/helper_utils.dart';
import 'package:augustine6237/app/data/models/bet_models/bet_comment_model.dart';
import 'package:augustine6237/app/data/repositories/bet_repository.dart';
import 'package:augustine6237/app/global/widgets/global_snackbar.dart';
import 'package:get/get.dart';

class BetCommentsController extends GetxController {
  final IBetRepository _betRepo;

  BetCommentsController(this._betRepo);

  final isLoading = false.obs;
  final isSending = false.obs;
  final RxList<BetCommentModel> comments = <BetCommentModel>[].obs;
  final RxString selectedStance = 'BACK'.obs; // 'BACK', 'OPPOSE', 'SPECTATOR'
  final RxString activeBetId = ''.obs;

  Future<void> loadComments(String betId) async {
    activeBetId.value = betId;
    try {
      isLoading.value = true;
      final res = await _betRepo.getBetComments(betId);
      comments.assignAll(res);
    } catch (_) {
      // Non-blocking for discussion stream
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> sendComment(String content) async {
    final betId = activeBetId.value;
    if (betId.isEmpty || content.trim().isEmpty) return false;

    try {
      isSending.value = true;
      final newComment = await _betRepo.postBetComment(
        betId: betId,
        content: content.trim(),
        stance: selectedStance.value,
      );
      comments.add(newComment);
      return true;
    } catch (e) {
      globalSnackBar(
        title: 'Error',
        message: 'Failed to post comment: $e',
        backgroundColor: AppColor.error,
      );
      return false;
    } finally {
      isSending.value = false;
    }
  }

  Future<void> deleteComment(String commentId) async {
    final betId = activeBetId.value;
    if (betId.isEmpty) return;

    final original = List<BetCommentModel>.from(comments);
    comments.removeWhere((c) => c.id == commentId);

    try {
      await _betRepo.deleteBetComment(betId: betId, commentId: commentId);
    } catch (e) {
      comments.assignAll(original);
      globalSnackBar(
        title: 'Error',
        message: 'Failed to delete comment: $e',
        backgroundColor: AppColor.error,
      );
    }
  }

  bool isOwnComment(BetCommentModel comment) {
    return comment.author?.id != null &&
        comment.author!.id == HelperUtils.userId;
  }
}

