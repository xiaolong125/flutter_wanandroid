import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database.g.dart';

class AppDatabasePlaceholder {
  const AppDatabasePlaceholder();

  String get status => 'pending';
}

@Riverpod(keepAlive: true)
AppDatabasePlaceholder appDatabase(Ref ref) {
  return const AppDatabasePlaceholder();
}
