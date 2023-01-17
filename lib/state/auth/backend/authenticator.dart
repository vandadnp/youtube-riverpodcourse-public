import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:testingriverpod/state/auth/constants/constants.dart';
import 'package:testingriverpod/state/auth/models/auth_result.dart';
import 'package:testingriverpod/state/posts/typedefs/user_id.dart';


  ///front-end (UI)와는 의존성이 없음.
  ///백엔드 API 역할로서, 
  /// 1) front-end (UI) => back-end (firebase or google) 로그인시도
  /// 2)                   back-end (firebase or google) => front-end (UI) userId, displayName, email만 제공
class Authenticator {

  /// 상수 생성자를 통해 앱에서 유일하게 하나로만 사용하게함. 왜냐하면 인증자가 두개이면 말이 안됨.
  /// auth_state_notifier.dar에서 final _authenticator = const Authenticator();로 정의
  /// 유일하게 하나로만 사용하는 방법으로, 상수 생성자 말고 팩토리 생성자를 통해 구현 가능 
  const Authenticator();

  // getters

  bool get isAlreadyLoggedIn => userId != null;

  /// 파이어베이스 인스턴스에 currentUser은 유저정보[uid, email, displayName, photonNumber]를 갖고 있으며
  /// 앱내에서 활용하기 위해 getter로 가져옴.
  UserId? get userId => FirebaseAuth.instance.currentUser?.uid;
  String get displayName =>
      FirebaseAuth.instance.currentUser?.displayName ?? '';
  String? get email => FirebaseAuth.instance.currentUser?.email;

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  ///Facebook 로그인
  ///return 값 : enum AuthResult { aborted, success, failure }
  Future<AuthResult> loginWithFacebook() async {
    final loginResult = await FacebookAuth.instance.login();
    final token = loginResult.accessToken?.token;

    if (token == null) {
      return AuthResult.aborted;
    }

    final oauthCredentials = FacebookAuthProvider.credential(token);

    /**
     *facebook에서 받은 token을 firebaseAuth을 통해 자동로그인 시도 
     */
    try {
      await FirebaseAuth.instance.signInWithCredential(oauthCredentials);
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      /**
       * 페이스북 실패 시, fetchSignInMethodsForEmail 호출하여 구글로그인 시도
       * fetchSignInMethodsForEmail : 해당되는 이메일을 기준으로 파이어베이스에 저장되어 있는 소셜로그인 기록을 가져옴.
       * linkWithCredential : 구글로그인 창으로 이동함. 
       */
      final email = e.email;
      final credential = e.credential;
      if (e.code == Constants.accountExistsWithDifferentCredentialsError &&
          email != null &&
          credential != null) {
        final providers =
            await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
        if (providers.contains(Constants.googleCom)) {
          await loginWithGoogle();
          FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
        }
        return AuthResult.success;
      }
      return AuthResult.failure;
    }
  }

  Future<AuthResult> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        Constants.emailScope,
      ],
    );
    final signInAccount = await googleSignIn.signIn();
    if (signInAccount == null) {
      return AuthResult.aborted;
    }

    final googleAuth = await signInAccount.authentication;
    final oauthCredentials = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(
        oauthCredentials,
      );
      return AuthResult.success;
    } catch (e) {
      return AuthResult.failure;
    }
  }
}
