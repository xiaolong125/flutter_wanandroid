# CLAUDE.md

本文件为 Claude Code (claude.ai/code) 在此代码仓库中工作时提供指导。

## 常用命令

```bash
# 安装依赖
flutter pub get

# 运行代码生成（Riverpod、Freezed、JSON 序列化、Drift）
dart run build_runner build --delete-conflicting-outputs

# 开发时以监听模式运行代码生成
dart run build_runner watch --delete-conflicting-outputs

# 运行应用
flutter run

# 运行测试
flutter test

# 运行单个测试文件
flutter test test/widget_test.dart

# 静态分析
flutter analyze

# 格式化代码
dart format lib/
```

## 架构

**整洁架构 + 功能模块化组织：**

```
lib/
├── main.dart               # 入口：ProviderScope → MaterialApp.router
├── core/                   # 共享基础设施
│   ├── network/            # Dio HTTP 客户端（含 secureStorageProvider、认证/日志拦截器）
│   ├── router/             # GoRouter（/login、/、/detail/:id）+ 认证 redirect 逻辑
│   ├── theme/              # Material 3 明暗主题
│   ├── utils/              # 全局日志（logger 包）
│   └── database/           # Drift 数据库（占位，尚未实现）
└── features/
    ├── auth/               # 认证模块（已完整实现）
    │   ├── data/repository/    # AuthRepository（flutter_secure_storage token 管理）
    │   ├── domain/model/       # User（Freezed）
    │   └── presentation/       # AuthNotifier（keepAlive）+ LoginScreen
    ├── main/               # 主导航容器（已完整实现）
    │   └── presentation/       # MainScreen（NavigationBar：首页/书架/我的）
    ├── home/               # 文章列表（已完整实现）
    │   ├── data/               # HomeApi（Dio）+ HomeRepository
    │   ├── domain/model/       # Article（Freezed）
    │   └── presentation/       # HomeNotifier + HomeScreen
    └── detail/             # 详情页（UI 已搭建，数据层为空）
        └── presentation/       # DetailScreen
```

每个功能模块遵循：`data/`（远程 API + 仓库层）→ `domain/`（Freezed 模型）→ `presentation/`（Riverpod notifier + 页面组件）。

## 关键模式

**状态管理：** 使用带 `@riverpod` 代码生成的 Riverpod。可变状态使用 Notifier 模式（继承 `_$ClassName`）。UI 使用 `ConsumerWidget` 或 `ConsumerStatefulWidget`。状态类使用 Freezed（`@freezed abstract class`）。

**数据流：** `XxxApi`（Dio）→ `XxxRepository` → `XxxNotifier` → `XxxScreen`。使用 `switch` 表达式对状态进行模式匹配。

**认证流程：**
- `AuthNotifier`（`keepAlive: true`）在 build 时调用 `_checkAuthState()` 读取本地 token
- `appRouter` 通过 `_RouterRefreshNotifier`（`ChangeNotifier`）监听 auth 变化，触发 GoRouter `redirect`
- 未登录 → 跳转 `/login`；已登录访问 `/login` → 跳转 `/`
- Token 存储于 `flutter_secure_storage`，key = `auth_token`

**导航：** GoRouter，路由定义在 `app_router.dart`。`appRouterProvider` 使用 `keepAlive: true`。当前路由：
- `/login` — 登录页
- `/` — 主页面（MainScreen，含底部导航）
- `/detail/:id` — 详情页

**代码生成：** 所有 `*.freezed.dart`、`*.g.dart` 文件均为生成文件——禁止手动编辑。修改带注解的类（`@freezed`、`@riverpod`、`@JsonSerializable`、`@RestApi`）后需运行 `build_runner`。

**模型：** 使用 `@freezed abstract class Xxx with _$Xxx` 创建不可变数据类（自动生成 `copyWith`、相等性判断、`fromJson`/`toJson`）。

**网络请求：** Dio 客户端位于 `core/network/dio_client.dart`。`secureStorageProvider` 也定义于此（供全局共享）。Auth 拦截器自动从 secure storage 读取 token 注入 `Authorization: Bearer` header。

**图片：** 所有网络图片使用 `CachedNetworkImage`。

**keepAlive 使用规则：** 全局持久 provider 使用 `@Riverpod(keepAlive: true)`，包括 `secureStorageProvider`、`authNotifierProvider`、`appRouterProvider`。

## 新增功能模块

1. 创建 `lib/features/<name>/`，包含 `data/remote/`、`data/repository/`、`domain/model/`、`presentation/`
2. 在 `domain/model/` 中定义带 `@freezed` + `@JsonSerializable` 的 Freezed 模型
3. 在 `data/remote/` 中定义带 `@RestApi` + Dio 的 API 类
4. 在 `data/repository/` 中定义带 `@riverpod` 的仓库层
5. 在 `presentation/` 中定义带 `@riverpod` + Notifier 的 notifier
6. 创建继承 `ConsumerWidget` 或 `ConsumerStatefulWidget` 的页面组件
7. 在 `core/router/app_router.dart` 中添加路由
8. 运行 `build_runner` 生成代码
