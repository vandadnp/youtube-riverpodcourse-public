import 'package:flutter/foundation.dart' show immutable;
import 'package:testingriverpod/state/auth/models/auth_result.dart';
import 'package:testingriverpod/state/posts/typedefs/user_id.dart';

/// immutable를 이용하여 AuthState를 임의적으로 변경 못하게 하기 위해
@immutable
class AuthState {
  ///AuthResult의 리턴은 enum이며 success, failed, absorted
  final AuthResult? result;
  final bool isLoading;
  final UserId? userId;

  /// 일반적인 우리가 알고 있는 생성자
  const AuthState({
    required this.result,
    required this.isLoading,
    required this.userId,
  });

  /// AuthState.unknown() 메소드 생성자
  /// AuthState unknown이라는 메소드(클래스인가?)에는 result =null, isLoading = false, userId =null을 상속시킴. 즉, 초기화 시킴.
  /// 앱 처음 시작 또는 로그아웃되어졌을때 말함.
  const AuthState.unknown()
      : result = null,
        isLoading = false,
        userId = null;

  /// copiedWithIsLoading 생성자
  /// isLoading만 변경시킴.
  /// 실제로 변경이 아니라 새로운 복사하여 상태를 만들어내는거임. 불변성은 변경이 아닌 새로운 상태를 만들어내는거임
  /// 개발자가 코드유지보수시, 실수로 다른 곳(예, 앱내에 개인정보 메뉴)에서 AuthState를 건드려서 코딩이 꼬일수 있음.
  AuthState copiedWithIsLoading(bool isLoading) => AuthState(
        result: result,
        isLoading: isLoading,
        userId: userId,
      );

  /// class operator
  /// 클래스내에서 연산자 규칙을 정의함.
  /// 클래스의 인스턴스끼리 연산할수 있기 위해 정의함. AuthState내에 (result, isLoading, userId)가 같은지 아닌지
  /// authstate1 = AuthState();
  /// authstate2 = AuthState();
  /// print( 'authstate1 == authstate2'); true인가 false인가
  @override
  bool operator ==(covariant AuthState other) =>
      identical(this, other) ||
      (result == other.result &&
          isLoading == other.isLoading &&
          userId == other.userId);


  /// class operator 적용시 무조건 넣어야함.
  @override
  int get hashCode => Object.hash(
        result,
        isLoading,
        userId,
      );
}
