import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:testingriverpod/state/image_upload/models/file_type.dart';
import 'package:testingriverpod/state/post_settings/models/post_setting.dart';
import 'package:testingriverpod/state/posts/models/post_key.dart';

@immutable
class Post {
  final String postId;
  final String userId;
  final String message;
  final DateTime createdAt;
  final String thumbnailUrl;
  final String fileUrl;
  final FileType fileType;
  final String fileName;
  final double aspectRatio;
  final String thumbnailStorageId;
  final String originalFileStorageId;
  final Map<PostSetting, bool> postSettings;

  /// postId 및 json[userId~ postSettings]으로 초기화된 생성자
  Post({
    required this.postId,
    required Map<String, dynamic> json,
  })  : userId = json[PostKey.userId],
        message = json[PostKey.message],
        createdAt = (json[PostKey.createdAt] as Timestamp).toDate(),
        thumbnailUrl = json[PostKey.thumbnailUrl],
        fileUrl = json[PostKey.fileUrl],
        fileType = FileType.values.firstWhere(
          (fileType) => fileType.name == json[PostKey.fileType],
          orElse: () => FileType.image,
        ),
        fileName = json[PostKey.fileName],
        aspectRatio = json[PostKey.aspectRatio],
        thumbnailStorageId = json[PostKey.thumbnailStorageId],
        originalFileStorageId = json[PostKey.originalFileStorageId],
        postSettings = {
          for (final entry in json[PostKey.postSettings].entries)
            PostSetting.values.firstWhere(
              (element) => element.storageKey == entry.key,
            ): entry.value,
        };

  bool get allowsLikes => postSettings[PostSetting.allowLikes] ?? false;
  bool get allowsComments => postSettings[PostSetting.allowComments] ?? false;
}


/// PostKey
/// static const userId = 'uid';
/// static const message = 'message';
/// static const createdAt = 'created_at';
/// static const thumbnailUrl = 'thumbnail_url';
/// static const fileUrl = 'file_url';
/// static const fileType = 'file_type';
/// static const fileName = 'file_name';
/// static const aspectRatio = 'aspect_ratio';
/// static const postSettings = 'post_settings';
/// static const thumbnailStorageId = 'thumbnail_storage_id';
/// static const originalFileStorageId = 'original_file_storage_id';
