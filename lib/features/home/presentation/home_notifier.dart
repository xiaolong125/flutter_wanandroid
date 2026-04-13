import 'package:flutter_wanandroid/core/utils/app_logger.dart';
import 'package:flutter_wanandroid/core/utils/error_message.dart';
import 'package:flutter_wanandroid/features/home/data/repository/home_repository.dart';
import 'package:flutter_wanandroid/features/home/presentation/home_ui_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_notifier.g.dart';

@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeUiState build() {
    Future.microtask(loadHome);
    return const HomeUiState.loading();
  }

  Future<void> loadHome({int page = 0}) async {
    try {
      final data = await ref.read(homeRepositoryProvider).fetchHome(page: page);
      state = HomeUiState.data(banners: data.banners, articles: data.articles);
    } catch (error, stackTrace) {
      ref
          .read(appLoggerProvider)
          .e('Load articles failed', error: error, stackTrace: stackTrace);
      state = HomeUiState.error(readableMessage(error));
    }
  }

  Future<void> refresh() {
    return loadHome();
  }
}
