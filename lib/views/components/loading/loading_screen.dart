import 'dart:async';
import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:testingriverpod/views/components/constants/strings.dart';
import 'package:testingriverpod/views/components/loading/loading_screen_controller.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

/// 로딩 화면 구현
class LoadingScreen {
  //Singleton pattern :클래스내에 생성자가 정의되고 하나 존재함.

  //private 생성자
  LoadingScreen._sharedInstance();

  //private 생성자는 모두 _shared에 집어 넣기
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  // LoadingScreen.instance() 호출시 _shared를 불러드리기 즉, LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _shared;

  //loading_screen_controller.dart에서 정의되었으며, close 및 update 함수를 제어함
  LoadingScreenController? controller;

  /// loading 화면 열기
  void show({
    required BuildContext context,
    String text = Strings.loading,
  }) {
    if (controller?.update(text) ?? false) {
      return;
    } else {
      controller = showOverlay(
        context: context,
        text: text,
      );
    }
  }

  /// loading 화면 닫기
  void hide() {
    controller?.close();
    controller = null;
  }

  /// show 메소드의 내에 있는 showOverlay 메소드 구현
  LoadingScreenController? showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final textController = StreamController<String>();
    textController.add(text);

    final state = Overlay.of(context);
    if (state == null) {
      return null;
    }

    // 컨테이너의 사이즈를 구하는 코드
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    ///devtools debug하기
    size.log();

    // OverlayEntry는 stack의 일종으로 화면위에 화면을 띄움. 마치 dialog처럼
    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      StreamBuilder(
                        stream: textController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data as String,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.black),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        textController.close();
        overlay.remove();
        return true;
      },
      update: (text) {
        textController.add(text);
        return true;
      },
    );
  }
}
