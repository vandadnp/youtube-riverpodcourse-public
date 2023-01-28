import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:testingriverpod/state/auth/providers/user_id_provider.dart';
import 'package:testingriverpod/state/image_upload/models/file_type.dart';
import 'package:testingriverpod/state/image_upload/models/thumbnail_request.dart';
import 'package:testingriverpod/state/image_upload/providers/image_uploader_provider.dart';
import 'package:testingriverpod/state/post_settings/models/post_setting.dart';
import 'package:testingriverpod/state/post_settings/providers/post_settings_provider.dart';
import 'package:testingriverpod/views/components/file_thumbnail_view.dart';
import 'package:testingriverpod/views/constants/strings.dart';

class CreateNewPostView extends StatefulHookConsumerWidget {
  final File fileToPost;
  final FileType fileType;

  const CreateNewPostView({
    Key? key,
    required this.fileToPost,
    required this.fileType,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateNewPostViewState();
}

class _CreateNewPostViewState extends ConsumerState<CreateNewPostView> {
  @override
  Widget build(BuildContext context) {
    final thumbnailRequest = ThumbnailRequest(
      file: widget.fileToPost,
      fileType: widget.fileType,
    );
    final postSettings = ref.watch(postSettingProvider);
    final postController = useTextEditingController();

    /// Hooks_riverpod, setState를 대신하여 useState를 사용. 초기값 false.
    final isPostButtonEnabled = useState(false);

    /// 두번째 파라미터(postController)가 변경(생성, 소멸, 상태변경) 될 때 첫번째 파라미터 함수(void listener)가 실행됨
    useEffect(() {
      void listener() {
        isPostButtonEnabled.value = postController.text.isNotEmpty;
      }

      postController.addListener(listener);
      return () {
        postController.removeListener(listener);
      };
    }, [postController]);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.createNewPost,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: isPostButtonEnabled.value
                ? () async {
                    // get the user id first
                    final userId = ref.read(userIdProvider);
                    if (userId == null) {
                      return;
                    }
                    final message = postController.text;
                    final isUploaded =
                        await ref.read(imageUploaderProvider.notifier).upload(
                              file: widget.fileToPost,
                              fileType: widget.fileType,
                              message: message,
                              postSettings: postSettings,
                              userId: userId,
                            );

                    ///mounted는 stateful widget이 생성되었는지 아닌지를 확인하는 방법, createState 이후에 mounted =true이며, dispose 이후에 false
                    if (isUploaded && mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                : null,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// FileThumbnailView의 return 값
            ///     return thumbnail.when(data: (imageWithAspectRatio) {
            /// return AspectRatio(
            /// aspectRatio: imageWithAspectRatio.aspectRatio,
            /// child: imageWithAspectRatio.image,);},
            FileThumbnailView(
              thumbnailRequest: thumbnailRequest,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: Strings.pleaseWriteYourMessageHere,
                ),
                autofocus: true,
                maxLines: null,
                controller: postController,
              ),
            ),
            ...PostSetting.values.map(
              (postSetting) => ListTile(
                title: Text(postSetting.title),
                subtitle: Text(postSetting.description),
                trailing: Switch(
                  value: postSettings[postSetting] ?? false,
                  onChanged: (isOn) {
                    ref.read(postSettingProvider.notifier).setSetting(
                          postSetting,
                          isOn,
                        );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
