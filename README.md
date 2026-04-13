# flutter_wanandroid

基于 `CLAUDE.md` 约定搭建的 Flutter 应用骨架，面向熟悉 Android 原生、Compose、KMP 的开发者，采用更接近现代 Android 分层思路的 Flutter 结构。

## 技术栈

- `flutter_riverpod` + `riverpod_annotation`
- `go_router`
- `dio`
- `freezed` + `json_serializable`
- `retrofit`
- `flutter_secure_storage`
- `cached_network_image`
- `logger`

## 目录结构

```text
lib/
├── app.dart
├── main.dart
├── core/
│   ├── database/
│   ├── network/
│   ├── router/
│   ├── theme/
│   └── utils/
└── features/
    ├── auth/
    ├── detail/
    ├── home/
    └── main/
```

每个功能模块按 `data/ → domain/ → presentation/` 组织，便于你用熟悉的 Android Clean Architecture 思维继续扩展。

## 已搭建内容

- `ProviderScope -> MaterialApp.router` 应用入口
- 登录态驱动的 `GoRouter` 跳转
- `Dio` 网络层与 token 注入拦截器
- `Auth`、`Home`、`Main`、`Detail` 四个示例模块
- `Material 3` 明暗主题
- 基于 `Freezed` 的模型与 UI 状态定义

## 常用命令

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter run
```
