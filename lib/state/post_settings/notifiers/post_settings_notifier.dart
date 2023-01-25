import 'dart:collection' show UnmodifiableMapView;

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:testingriverpod/state/post_settings/models/post_setting.dart';

class PostSettingNotifier extends StateNotifier<Map<PostSetting, bool>> {
  PostSettingNotifier()
      : super(
          UnmodifiableMapView(
            {
              for (final setting in PostSetting.values) setting: true,
            },
          ),
        );

  ///ref.read(postSettingProvider.notifier).setSetting(postSetting, isOn)
  ///ref.refresh(postSettingProivder) setting : true로 초기화
  void setSetting(
    PostSetting setting,
    bool value,
  ) {
    final existingValue = state[setting];
    if (existingValue == null || existingValue == value) {
      return;
    }
    state = Map.unmodifiable(
      Map.from(state)..[setting] = value,
    );
  }
}
