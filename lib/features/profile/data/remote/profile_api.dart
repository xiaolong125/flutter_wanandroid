import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:flutter_wanandroid/core/network/dio_client.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_api.g.dart';

@RestApi()
abstract class ProfileApi {
  factory ProfileApi(Dio dio, {String? baseUrl}) = _ProfileApi;

  @GET('/lg/coin/userinfo/json')
  Future<dynamic> getIntegral();
}

@riverpod
ProfileApi profileApi(Ref ref) {
  return ProfileApi(ref.watch(dioClientProvider));
}
