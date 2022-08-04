import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:testingriverpod/state/comments/notifiers/delete_comment_notifier.dart';
import 'package:testingriverpod/state/image_upload/typedefs/is_loading.dart';

final deleteCommentProvider =
    StateNotifierProvider<DeleteCommentStateNotifier, IsLoading>(
  (ref) => DeleteCommentStateNotifier(),
);
