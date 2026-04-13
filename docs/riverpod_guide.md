# Riverpod 使用指南

> 基于本项目（flutter_reader）的实际代码讲解，并与 Android 生态对比。

---

## 目录

1. [Riverpod 是什么](#1-riverpod-是什么)
2. [核心概念](#2-核心概念)
3. [Provider 类型速查](#3-provider-类型速查)
4. [在本项目中的实际用法](#4-在本项目中的实际用法)
5. [Android 有没有类似的库](#5-android-有没有类似的库)
6. [概念对照表](#6-概念对照表)

---

## 1. Riverpod 是什么

Riverpod 是 Flutter/Dart 的**依赖注入 + 状态管理**框架，由 `provider` 包的作者重写。

核心解决了三个问题：
- **依赖注入**：在任意位置获取对象实例，无需手动传递
- **状态管理**：响应式地管理 UI 状态，状态变化自动驱动 UI 重建
- **生命周期**：自动管理对象的创建和销毁

```
                 ┌─────────────────────────────┐
                 │         ProviderScope        │  ← 依赖容器（全局唯一）
                 │  ┌────────┐  ┌───────────┐  │
                 │  │Provider│  │  Provider │  │  ← 各类 provider
                 │  └────────┘  └───────────┘  │
                 └─────────────────────────────┘
                          ↓ ref.watch / ref.read
              ┌───────────────────────────────────┐
              │  ConsumerWidget / ConsumerState    │  ← UI 层订阅状态
              └───────────────────────────────────┘
```

---

## 2. 核心概念

### 2.1 ProviderScope

整个应用必须被 `ProviderScope` 包裹，它是所有 provider 的容器。

```dart
// main.dart
void main() {
  runApp(
    const ProviderScope(child: FlutterReaderApp()),
  );
}
```

### 2.2 Provider 定义（代码生成方式）

本项目使用 `riverpod_annotation` + `build_runner` 生成代码，推荐这种方式：

```dart
// 函数式 provider（返回一个对象实例）
@riverpod
Dio dioClient(Ref ref) {
  return Dio(...);
}
// 生成：dioClientProvider

// 类式 provider（管理可变状态）
@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeUiState build() {
    return const HomeUiState(isLoading: true);
  }

  void someMethod() {
    state = state.copyWith(...); // 修改状态
  }
}
// 生成：homeNotifierProvider
```

### 2.3 读取 Provider

在 Widget 中有两种方式消费 provider：

| 方式 | 场景 | 是否触发重建 |
|------|------|------------|
| `ref.watch(provider)` | 需要响应状态变化 | ✅ 是 |
| `ref.read(provider)` | 只执行一次操作（如按钮点击） | ❌ 否 |

```dart
// ✅ 正确：在 build 方法中用 watch 订阅状态
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(homeNotifierProvider); // 状态变化时自动重建
  ...
}

// ✅ 正确：在事件回调中用 read 触发操作
onPressed: () => ref.read(homeNotifierProvider.notifier).refresh();

// ❌ 错误：在 build 方法中用 read，不会响应状态变化
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.read(homeNotifierProvider); // 不会自动刷新！
}
```

### 2.4 ConsumerWidget vs ConsumerStatefulWidget

```dart
// 无本地状态时用 ConsumerWidget（更简洁）
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) { ... }
}

// 需要本地状态（如 TextEditingController）时用 ConsumerStatefulWidget
class LoginScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _controller = TextEditingController(); // 本地状态

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider); // ref 直接可用
    ...
  }
}
```

### 2.5 keepAlive

默认情况下，provider 在没有订阅者时会被自动销毁（释放内存）。
全局单例需要加 `keepAlive: true`：

```dart
// 整个 App 生命周期内保活
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) => const FlutterSecureStorage();

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier { ... }

// 默认（不加 keepAlive）：没有 Widget 订阅时自动销毁
@riverpod
HomeApi homeApi(Ref ref) => HomeApi(ref.watch(dioClientProvider));
```

### 2.6 Provider 之间的依赖

```dart
// 通过 ref.watch 声明依赖，Riverpod 自动处理依赖链
@riverpod
AuthRepository authRepository(Ref ref) => AuthRepository(
  ref.watch(dioClientProvider),        // 依赖 Dio
  ref.watch(secureStorageProvider),    // 依赖 SecureStorage
);
```

依赖链示意：
```
secureStorageProvider
        ↓
dioClientProvider ──→ authRepositoryProvider ──→ authNotifierProvider
```

---

## 3. Provider 类型速查

| 注解写法 | 适用场景 | 示例 |
|---------|---------|------|
| `@riverpod` 函数 | 创建一个对象实例（无状态） | `HomeApi`、`Dio`、`Repository` |
| `@riverpod` class (Notifier) | 管理可变 UI 状态 | `HomeNotifier`、`AuthNotifier` |
| `@Riverpod(keepAlive: true)` | 全局单例，生命周期同 App | `SecureStorage`、`GoRouter` |

---

## 4. 在本项目中的实际用法

### 4.1 依赖注入链（网络层）

```dart
// 1. 最底层：安全存储（单例）
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) => const FlutterSecureStorage();

// 2. HTTP 客户端：依赖 secureStorage 注入认证拦截器
@riverpod
Dio dioClient(Ref ref) {
  final storage = ref.watch(secureStorageProvider);
  // ...配置 Dio + 拦截器
}

// 3. API 层：依赖 Dio
@riverpod
HomeApi homeApi(Ref ref) => HomeApi(ref.watch(dioClientProvider));

// 4. Repository 层：依赖 API
@riverpod
HomeRepository homeRepository(Ref ref) =>
    HomeRepository(ref.watch(homeApiProvider));
```

### 4.2 状态管理（UI 层）

```dart
// Notifier：管理 UI 状态
@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeUiState build() {
    _loadArticles(); // build 时自动触发数据加载
    return const HomeUiState(isLoading: true);
  }

  Future<void> _loadArticles() async {
    try {
      final articles = await ref.read(homeRepositoryProvider).getArticles();
      state = state.copyWith(articles: articles, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await _loadArticles();
  }
}

// Widget：消费状态
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);

    return switch (state) {
      HomeUiState(isLoading: true) => const CircularProgressIndicator(),
      HomeUiState(errorMessage: final msg) when msg != null =>
          _ErrorView(message: msg, onRetry: () =>
              ref.read(homeNotifierProvider.notifier).refresh()),
      _ => _ArticleList(articles: state.articles),
    };
  }
}
```

### 4.3 跨模块通信（路由守卫监听认证状态）

```dart
// app_router.dart 中，GoRouter 订阅 AuthNotifier 变化
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refreshNotifier = _RouterRefreshNotifier(ref);

  return GoRouter(
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      if (!authState.isLoggedIn) return '/login';
      return null;
    },
    ...
  );
}

// 桥接类：将 Riverpod 状态变化转为 ChangeNotifier 通知
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(authNotifierProvider, (_, __) => notifyListeners());
  }
}
```

---

## 5. Android 有没有类似的库

有，而且非常相似。Android 生态有两套主流方案：

### 5.1 Hilt（依赖注入）≈ Riverpod 的 Provider 体系

Hilt 是 Google 官方推荐的 DI 框架，负责创建和管理对象实例。

```kotlin
// Android Hilt
@Module
@InstallIn(SingletonComponent::class)
object NetworkModule {

    @Provides
    @Singleton
    fun provideOkHttpClient(): OkHttpClient = OkHttpClient.Builder()
        .addInterceptor(AuthInterceptor())
        .build()

    @Provides
    @Singleton
    fun provideRetrofit(client: OkHttpClient): Retrofit = Retrofit.Builder()
        .baseUrl("https://api.example.com")
        .client(client)
        .build()
}

// 注入到 ViewModel
@HiltViewModel
class HomeViewModel @Inject constructor(
    private val repository: HomeRepository
) : ViewModel() { ... }
```

```dart
// Flutter Riverpod（等价）
@riverpod
Dio dioClient(Ref ref) {
  final storage = ref.watch(secureStorageProvider);
  return Dio()..interceptors.add(AuthInterceptor(storage));
}

@riverpod
HomeRepository homeRepository(Ref ref) =>
    HomeRepository(ref.watch(dioClientProvider));
```

**相似点：**
- 都通过注解声明依赖
- 都自动管理对象的创建和生命周期
- 依赖关系由框架自动解析，不需要手动 `new`

**差异点：**
- Hilt 是编译期注入（APT 生成代码），Riverpod 是运行期注入
- Hilt 的作用域绑定到 Android 组件（Activity/Fragment/ViewModel），Riverpod 更灵活

---

### 5.2 ViewModel + StateFlow（状态管理）≈ Riverpod Notifier

```kotlin
// Android ViewModel + StateFlow
data class HomeUiState(
    val articles: List<Article> = emptyList(),
    val isLoading: Boolean = false,
    val errorMessage: String? = null,
)

@HiltViewModel
class HomeViewModel @Inject constructor(
    private val repository: HomeRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow(HomeUiState(isLoading = true))
    val uiState: StateFlow<HomeUiState> = _uiState.asStateFlow()

    init {
        loadArticles()
    }

    private fun loadArticles() {
        viewModelScope.launch {
            try {
                val articles = repository.getArticles()
                _uiState.update { it.copy(articles = articles, isLoading = false) }
            } catch (e: Exception) {
                _uiState.update { it.copy(isLoading = false, errorMessage = e.message) }
            }
        }
    }

    fun refresh() {
        _uiState.update { it.copy(isLoading = true, errorMessage = null) }
        loadArticles()
    }
}

// Compose UI 消费状态
@Composable
fun HomeScreen(viewModel: HomeViewModel = hiltViewModel()) {
    val uiState by viewModel.uiState.collectAsStateWithLifecycle()

    when {
        uiState.isLoading -> CircularProgressIndicator()
        uiState.errorMessage != null -> ErrorView(uiState.errorMessage!!)
        else -> ArticleList(uiState.articles)
    }
}
```

```dart
// Flutter Riverpod（等价）
@freezed
abstract class HomeUiState with _$HomeUiState {
  const factory HomeUiState({
    @Default([]) List<Article> articles,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _HomeUiState;
}

@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeUiState build() {
    _loadArticles(); // 等价于 init { loadArticles() }
    return const HomeUiState(isLoading: true);
  }
  // ...
}

// Flutter Widget 消费状态
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider); // 等价于 collectAsStateWithLifecycle
    // ...
  }
}
```

---

## 6. 概念对照表

| Flutter / Riverpod | Android | 说明 |
|-------------------|---------|------|
| `ProviderScope` | `Application` + Hilt `@InstallIn(SingletonComponent)` | 全局依赖容器 |
| `@riverpod` 函数 Provider | `@Provides` + `@Singleton` | 创建并提供对象实例 |
| `@Riverpod(keepAlive: true)` | `@Singleton` | 应用级单例 |
| `Notifier` / `AsyncNotifier` | `ViewModel` | 持有并管理 UI 状态 |
| `HomeUiState`（Freezed） | `HomeUiState`（data class） | 不可变 UI 状态类 |
| `ref.watch(provider)` | `collectAsStateWithLifecycle()` | 订阅状态，变化时重建 UI |
| `ref.read(provider)` | `viewModel.someMethod()` | 单次读取或触发操作 |
| `ref.listen(provider, ...)` | `Flow.collect { }` | 监听状态变化执行副作用 |
| `ConsumerWidget` | `@Composable` + `hiltViewModel()` | 可消费 provider 的 UI 组件 |
| `state = state.copyWith(...)` | `_uiState.update { it.copy(...) }` | 更新状态（不可变方式） |
| `build_runner` 生成 `.g.dart` | `kapt` / `ksp` 生成代码 | 编译期代码生成 |

---

## 总结

```
Android 技术栈          Flutter 技术栈
─────────────────       ──────────────────
Hilt                ←→  Riverpod (Provider)
ViewModel           ←→  Notifier
StateFlow           ←→  state (in Notifier)
collectAsState()    ←→  ref.watch()
data class + copy() ←→  Freezed + copyWith()
kapt / ksp          ←→  build_runner
```

如果你有 Android 开发背景，上手 Riverpod 的最快路径是：
1. 把 `ProviderScope` 理解为 Hilt 容器
2. 把 `@riverpod` 函数理解为 `@Provides` 方法
3. 把 `Notifier` 理解为 `ViewModel`
4. 把 `ref.watch()` 理解为 `collectAsStateWithLifecycle()`
