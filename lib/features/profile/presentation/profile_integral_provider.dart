import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:flutter_wanandroid/features/auth/presentation/auth_notifier.dart';
import 'package:flutter_wanandroid/features/auth/presentation/auth_state.dart';
import 'package:flutter_wanandroid/features/profile/data/repository/profile_repository.dart';
import 'package:flutter_wanandroid/features/profile/domain/model/profile_integral.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_integral_provider.g.dart';

@riverpod
Future<ProfileIntegral?> profileIntegral(Ref ref) async {
  final authState = ref.watch(authNotifierProvider);
  if (!authState.isAuthenticated) {
    return null;
  }

  return ref.watch(profileRepositoryProvider).fetchIntegral();
}
