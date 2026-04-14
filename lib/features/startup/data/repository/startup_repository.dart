import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:flutter_wanandroid/core/storage/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'startup_repository.g.dart';

const startupSeenKey = 'startup_seen';
const startupPolicyAgreedKey = 'startup_policy_agreed';

class StartupRepository {
  StartupRepository(this._preferencesFuture);

  final Future<SharedPreferences> _preferencesFuture;

  Future<bool> hasSeenWelcome() async {
    final preferences = await _preferencesFuture;
    return preferences.getBool(startupSeenKey) ?? false;
  }

  Future<bool> hasAgreedPolicy() async {
    final preferences = await _preferencesFuture;
    return preferences.getBool(startupPolicyAgreedKey) ?? false;
  }

  Future<void> markWelcomeSeen() async {
    final preferences = await _preferencesFuture;
    await preferences.setBool(startupSeenKey, true);
  }

  Future<void> markPolicyAgreed() async {
    final preferences = await _preferencesFuture;
    await preferences.setBool(startupPolicyAgreedKey, true);
  }
}

@riverpod
StartupRepository startupRepository(Ref ref) {
  return StartupRepository(ref.watch(sharedPreferencesProvider.future));
}
