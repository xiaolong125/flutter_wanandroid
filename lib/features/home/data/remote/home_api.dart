import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:flutter_wanandroid/core/network/dio_client.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_api.g.dart';

@RestApi()
abstract class HomeApi {
  factory HomeApi(Dio dio, {String? baseUrl}) = _HomeApi;

  @GET('/banner/json')
  Future<dynamic> getBanners();

  @GET('/article/top/json')
  Future<dynamic> getTopArticles();

  @GET('/article/list/{page}/json')
  Future<dynamic> getArticles(@Path('page') int page);
}

@riverpod
HomeApi homeApi(Ref ref) {
  return HomeApi(ref.watch(dioClientProvider));
}
