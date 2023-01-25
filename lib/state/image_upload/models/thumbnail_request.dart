import 'dart:io' show File;

import 'package:flutter/foundation.dart' show immutable;
import 'package:testingriverpod/state/image_upload/models/file_type.dart';

/// Thumbnail로서 file 파일(파일경로 (url, path, etc))과 filetype(이미지인지 비디오인지)
@immutable
class ThumbnailRequest {
  final File file;
  final FileType fileType;

  const ThumbnailRequest({
    required this.file,
    required this.fileType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThumbnailRequest &&
          runtimeType == other.runtimeType &&
          file == other.file &&
          fileType == other.fileType;

  @override
  int get hashCode => Object.hashAll(
        [
          runtimeType,
          file,
          fileType,
        ],
      );
}
