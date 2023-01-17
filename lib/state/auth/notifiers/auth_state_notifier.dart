import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:testingriverpod/state/auth/backend/authenticator.dart';
import 'package:testingriverpod/state/auth/models/auth_result.dart';
import 'package:testingriverpod/state/auth/models/auth_state.dart';
import 'package:testingriverpod/state/posts/typedefs/user_id.dart';
import 'package:testingriverpod/state/user_info/backend/user_info_storage.dart';


/// 
///
class AuthStateNotifier extends StateNotifier<AuthState> {

  /// 상수 연산자를 이용하여 단 하나의 인스턴스를 생성함.
  /// _ private를 넣어서 AuthStateNotifier에서만 가지고 놀수 있음.
  final _authenticator = const Authenticator();
  final _userInfoStorage = const UserInfoStorage();


  /// model/auth_state에서 정의한 AuthState.unknown를 초기화로 넣음
  /// AuthState의 구조, 즉 필드구성은 AuthResult? result; bool isLoading; UserId? userId;
  /// StateNotifier는 state를 default로 갖고 초기화시 AuthState.unknwon()이다
  /// 만약에 로그인 되어있다면(_authenticator.isAlreadyLoggedIn), 현재 AuthState(로그인 성공, 로딩이 마침, firebase userId)을 StateNotifier(즉, provider)에게 전달.  
  AuthStateNotifier() : super(const AuthState.unknown()) {
    if (_authenticator.isAlreadyLoggedIn) {
      state = AuthState(
        result: AuthResult.success,
        isLoading: false,
        userId: _authenticator.userId,
      );
    }
    
  }

  /// front-end와 back-end간의 코드 비교
  /// 
  /// back-end (authenticator.dart)
  ///    Future<void> logOut() async {
  ///      await FirebaseAuth.instance.signOut();
  ///      await GoogleSignIn().signOut();
  ///      await FacebookAuth.instance.logOut();
  ///    }
  ///
  ///
  Future<void> logOut() async {
    state = state.copiedWithIsLoading(true);
    await _authenticator.logOut();
    state = const AuthState.unknown();
  }


  /// front-end와 back-end 간의 코드 비교 
  ///
  // Future<AuthResult> loginWithGoogle() async {
  //   final GoogleSignIn googleSignIn = GoogleSignIn(
  //     scopes: [
  //       Constants.emailScope,
  //     ],
  //   );
  //   final signInAccount = await googleSignIn.signIn();
  //   if (signInAccount == null) {
  //     return AuthResult.aborted;
  //   }

  //   final googleAuth = await signInAccount.authentication;
  //   final oauthCredentials = GoogleAuthProvider.credential(
  //     idToken: googleAuth.idToken,
  //     accessToken: googleAuth.accessToken,
  //   );
  //   try {
  //     await FirebaseAuth.instance.signInWithCredential(
  //       oauthCredentials,
  //     );
  //     return AuthResult.success;
  //   } catch (e) {
  //     return AuthResult.failure;
  //   }
  // }
  /// front-end는 AuthState의 상태(result, isLoading, userId)관리만 함.
  Future<void> loginWithGoogle() async {
    state = state.copiedWithIsLoading(true);
    final result = await _authenticator.loginWithGoogle();
    final userId = _authenticator.userId;
    if (result == AuthResult.success && userId != null) {
      await saveUserInfo(userId: userId);
    }
    state = AuthState(
      result: result,
      isLoading: false,
      userId: _authenticator.userId,
    );
  }

  Future<void> loginWithFacebook() async {
    state = state.copiedWithIsLoading(true);
    final result = await _authenticator.loginWithFacebook();
    final userId = _authenticator.userId;
    if (result == AuthResult.success && userId != null) {
      await saveUserInfo(userId: userId);
    }
    state = AuthState(
      result: result,
      isLoading: false,
      userId: _authenticator.userId,
    );
  }

  /// auth 폴더 밖에 있는 user_info
  /// authenticator.dart안에 firebase에서 가져온 userId를 앱에 저장시키는 메소드
  Future<void> saveUserInfo({
    required UserId userId,
  }) =>
      _userInfoStorage.saveUserInfo(
        userId: userId,
        displayName: _authenticator.displayName,
        email: _authenticator.email,
      );
}
