import 'package:hooks_riverpod/hooks_riverpod.dart' show StateNotifierProvider;
import 'package:testingriverpod/state/auth/models/auth_state.dart';
import 'package:testingriverpod/state/auth/notifiers/auth_state_notifier.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) => AuthStateNotifier(),
);
