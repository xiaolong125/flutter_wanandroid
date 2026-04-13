import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:flutter_wanandroid/core/network/dio_client.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_api.g.dart';

@RestApi()
abstract class SearchApi {
  factory SearchApi(Dio dio, {String? baseUrl}) = _SearchApi;

  @GET('/hotkey/json')
  Future<dynamic> getHotKeywords();

  @FormUrlEncoded()
  @POST('/article/query/{page}/json')
  Future<dynamic> searchArticles(
    @Path('page') int page,
    @Field('k') String keyword,
  );
}

@riverpod
SearchApi searchApi(Ref ref) {
  return SearchApi(ref.watch(dioClientProvider));
}
