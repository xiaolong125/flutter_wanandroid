import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:flutter_wanandroid/core/network/dio_client.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  @FormUrlEncoded()
  @POST('/user/login')
  Future<HttpResponse<dynamic>> login(
    @Field('username') String username,
    @Field('password') String password,
  );

  @FormUrlEncoded()
  @POST('/user/register')
  Future<HttpResponse<dynamic>> register(
    @Field('username') String username,
    @Field('password') String password,
    @Field('repassword') String confirmPassword,
  );

  @GET('/user/logout/json')
  Future<dynamic> logout();
}

@riverpod
AuthApi authApi(Ref ref) {
  return AuthApi(ref.watch(dioClientProvider));
}
