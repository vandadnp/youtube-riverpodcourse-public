import 'package:flutter/foundation.dart' show immutable;

///
/// facebook 로그인 실패 시, google로그인 시도하도록 설정하기 위한 상수값
@immutable
class Constants {
  ///unnamed constructor : 팩토리 생성자 같은 기능.
  const Constants._();

  static const accountExistsWithDifferentCredentialsError =
      'account-exists-with-different-credential';
  static const googleCom = 'google.com';
  static const emailScope = 'email';
}


