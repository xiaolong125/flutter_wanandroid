import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:flutter_wanandroid/features/profile/data/remote/profile_api.dart';
import 'package:flutter_wanandroid/features/profile/domain/model/profile_integral.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_repository.g.dart';

class ProfileRepository {
  ProfileRepository(this._api);

  final ProfileApi _api;

  Future<ProfileIntegral> fetchIntegral() async {
    final response = await _api.getIntegral();
    if (response is! Map) {
      throw Exception('积分数据解析失败');
    }

    final payload = Map<String, dynamic>.from(response);
    final errorCode = payload['errorCode'];
    if (errorCode != 0) {
      final message = payload['errorMsg']?.toString().trim();
      throw Exception(message == null || message.isEmpty ? '积分加载失败' : message);
    }

    final data = payload['data'];
    if (data is! Map) {
      throw Exception('积分数据为空');
    }

    return ProfileIntegral.fromJson(Map<String, dynamic>.from(data));
  }
}

@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepository(ref.watch(profileApiProvider));
}
