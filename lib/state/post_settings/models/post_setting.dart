import 'package:testingriverpod/state/post_settings/constants/constants.dart';

/// dart 2.17버전 이상부터 enum PostSetting은 class처럼 property, method, static method를 추가할수 있음
/// 파이어베이스에 게시 할 때 상태값 지정
/// title, description는 view의 텍스트이며 storagekey는 ?
enum PostSetting {
  allowLikes(
    title: Constants.allowLikesTitle,
    description: Constants.allowLikesDescription,
    storageKey: Constants.allowLikesStorageKey,
  ),
  allowComments(
    title: Constants.allowCommentsTitle,
    description: Constants.allowCommentsDescription,
    storageKey: Constants.allowCommentsStorageKey,
  );

  final String title;
  final String description;

  // firebase storage key
  final String storageKey;

  const PostSetting({
    required this.title,
    required this.description,
    required this.storageKey,
  });
}
