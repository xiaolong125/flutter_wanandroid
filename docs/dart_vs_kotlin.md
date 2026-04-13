# Dart vs Kotlin 语法对比

基于本项目（flutter_reader）的实际代码，系统对比 Dart 与 Kotlin 的语法异同。

---

## 目录

1. [基本类型与变量](#1-基本类型与变量)
2. [空安全](#2-空安全)
3. [函数与方法](#3-函数与方法)
4. [类与对象](#4-类与对象)
5. [数据类 / 不可变模型](#5-数据类--不可变模型)
6. [集合操作](#6-集合操作)
7. [异步编程](#7-异步编程)
8. [扩展](#8-扩展)
9. [泛型](#9-泛型)
10. [模式匹配 / 条件表达式](#10-模式匹配--条件表达式)
11. [异常处理](#11-异常处理)
12. [作用域函数](#12-作用域函数)
13. [接口与抽象类](#13-接口与抽象类)
14. [导入与模块](#14-导入与模块)
15. [注解](#15-注解)
16. [总览速查表](#16-总览速查表)

---

## 1. 基本类型与变量

### 变量声明

| 场景 | Dart | Kotlin |
|------|------|--------|
| 可变变量 | `var name = 'Tom'` | `var name = "Tom"` |
| 不可变变量 | `final name = 'Tom'` | `val name = "Tom"` |
| 编译期常量 | `const pi = 3.14` | `const val PI = 3.14` |
| 显式类型 | `String name = 'Tom'` | `val name: String = "Tom"` |
| 延迟初始化 | `late String name;` | `lateinit var name: String` |

**Dart 示例**（来自 `dio_client.dart`）：
```dart
// 顶层常量
const _tokenKey = 'auth_token';

// Duration 字面量
connectTimeout: const Duration(seconds: 15),
```

**Kotlin 等价写法**：
```kotlin
private const val TOKEN_KEY = "auth_token"

connectTimeout = Duration.ofSeconds(15)
```

### 字符串插值

```dart
// Dart：$变量 或 ${表达式}
options.headers['Authorization'] = 'Bearer $token';
body: Center(child: Text('页面不存在: ${state.error}')),
```

```kotlin
// Kotlin：$变量 或 ${表达式}
options.headers["Authorization"] = "Bearer $token"
Center(text = "页面不存在: ${state.error}")
```

> **相同点**：两者都使用 `$` 和 `${}` 进行字符串插值，语法几乎一致。

---

## 2. 空安全

两者都有完整的空安全系统，语法也高度相似。

| 操作 | Dart | Kotlin |
|------|------|--------|
| 可空类型 | `String?` | `String?` |
| 非空断言 | `value!` | `value!!` |
| 安全调用 | `obj?.method()` | `obj?.method()` |
| Elvis 操作符 | `value ?? defaultValue` | `value ?: defaultValue` |
| 空值合并赋值 | `value ??= defaultValue` | — |
| let 安全块 | — | `value?.let { ... }` |

**Dart 示例**（来自 `user.dart`、`app_router.dart`）：
```dart
// 可空字段
String? email;
String? avatar;

// 非空断言（明确知道不为 null）
final id = state.pathParameters['id']!;

// 安全调用 + Elvis
final token = await storage.read(key: _tokenKey);
if (token != null) { ... }
```

**Kotlin 等价写法**：
```kotlin
val email: String? = null
val avatar: String? = null

val id = state.pathParameters["id"]!!

val token = storage.read(key = TOKEN_KEY)
token?.let { options.headers["Authorization"] = "Bearer $it" }
```

> **差异**：Dart 用 `??` 做空值合并，Kotlin 用 `?:`。Dart 的 `!` 是单感叹号，Kotlin 是 `!!`。Kotlin 有 `let`/`run`/`also` 等作用域函数可配合空安全使用，Dart 没有对应语法糖。

---

## 3. 函数与方法

### 命名参数与默认值

**Dart**（来自 `auth_notifier.dart`）：
```dart
// 命名参数用 {} 包裹，required 表示必填
Future<void> login({
  required String username,
  required String password,
}) async { ... }

// 调用时必须写参数名
await login(username: 'tom', password: '123');
```

**Kotlin 等价写法**：
```kotlin
// Kotlin 所有参数默认都可以用名称调用
suspend fun login(
    username: String,
    password: String
) { ... }

// 调用（可选择是否写名称）
login(username = "tom", password = "123")
login("tom", "123")  // 也合法
```

> **差异**：Dart 的命名参数必须用 `{}` 声明，调用时强制写名称；Kotlin 所有参数都支持具名调用，更灵活。Dart 还有位置可选参数 `[]`，Kotlin 没有对应概念（用默认值替代）。

### 箭头函数

```dart
// Dart：=> 用于单表达式函数
String get displayName => nickname ?? userId;

// 匿名函数
dio.interceptors.add(InterceptorsWrapper(
  onError: (error, handler) {
    handler.next(error);
  },
));
```

```kotlin
// Kotlin：单表达式函数
val displayName get() = nickname ?: userId

// Lambda
dio.interceptors.add(InterceptorsWrapper(
    onError = { error, handler -> handler.next(error) }
))
```

### 顶层函数

```dart
// Dart 支持顶层函数（非类成员）
void main() {
  runApp(const ProviderScope(child: FlutterReaderApp()));
}
```

```kotlin
// Kotlin 同样支持顶层函数
fun main() {
    runApp(ProviderScope(child = FlutterReaderApp()))
}
```

> **相同点**：两者都支持顶层函数，无需强制包在类里（与 Java 不同）。

---

## 4. 类与对象

### 构造函数

**Dart**（来自 `main.dart`）：
```dart
class FlutterReaderApp extends ConsumerWidget {
  // 使用 super 参数简写（Dart 2.17+）
  const FlutterReaderApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(routerConfig: router);
  }
}
```

**Kotlin 等价写法**：
```kotlin
class FlutterReaderApp(key: Key? = null) : ConsumerWidget(key) {
    override fun build(context: BuildContext, ref: WidgetRef): Widget {
        val router = ref.watch(appRouterProvider)
        return MaterialApp.router(routerConfig = router)
    }
}
```

### 工厂构造函数

**Dart**（来自 `user.dart`）：
```dart
// factory 关键字：可返回已有实例或子类实例
factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
```

**Kotlin 等价写法**（companion object）：
```kotlin
companion object {
    fun fromJson(json: Map<String, Any?>): User = UserSerializer.fromJson(json)
}
```

> **差异**：Dart 有专门的 `factory` 构造函数关键字；Kotlin 用 `companion object` + 工厂方法，或 `object` 实现单例/工厂模式。

### 抽象类 / 静态成员

**Dart**（来自 `app_router.dart`）：
```dart
// 用抽象类聚合常量（Dart 无 object 关键字）
abstract class AppRoutes {
  static const login = '/login';
  static const main = '/main';
  static const detail = '/detail/:id';
}
```

**Kotlin 等价写法**：
```kotlin
// Kotlin 用 object 或 companion object
object AppRoutes {
    const val LOGIN = "/login"
    const val MAIN = "/main"
    const val DETAIL = "/detail/{id}"
}
```

> **差异**：Kotlin 有 `object` 关键字天然支持单例，Dart 通常用 `abstract class` + `static` 成员来模拟。

---

## 5. 数据类 / 不可变模型

这是两者差异最显著的地方之一。

### Kotlin data class（内置）

```kotlin
data class User(
    val userId: String,
    val nickname: String,
    val email: String? = null,
    val avatar: String? = null,
    val coin: Int? = null,
    val bonus: Int? = null
)

// 自动生成：equals、hashCode、toString、copy
val updated = user.copy(coin = 100)
```

### Dart Freezed（代码生成）

**Dart**（来自 `user.dart`）：
```dart
// 需要 freezed_annotation 包 + build_runner 生成代码
@freezed
abstract class User with _$User {
  const factory User({
    required String userId,
    required String nickname,
    String? email,
    String? avatar,
    int? coin,
    int? bonus,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

// 使用 copyWith（Freezed 生成）
final updated = user.copyWith(coin: 100);
```

> **差异**：Kotlin `data class` 是语言内置特性，零依赖；Dart 需要借助 `freezed` 第三方包 + `build_runner` 代码生成，但 Freezed 额外提供了 Union Type（密封类）、模式匹配等高级功能。

---

## 6. 集合操作

### 基本集合

| 类型 | Dart | Kotlin |
|------|------|--------|
| 列表 | `List<String>` / `[1, 2, 3]` | `List<String>` / `listOf(1, 2, 3)` |
| 可变列表 | `<String>[]` | `mutableListOf<String>()` |
| Map | `Map<String, int>` / `{'a': 1}` | `Map<String, Int>` / `mapOf("a" to 1)` |
| Set | `Set<String>` / `{'a', 'b'}` | `Set<String>` / `setOf("a", "b")` |

### 集合变换

```dart
// Dart
final titles = articles.map((a) => a.title).toList();
final published = articles.where((a) => a.isBookmarked).toList();
final total = articles.fold(0, (sum, a) => sum + (a.coin ?? 0));

// spread 操作符（展开）
final combined = [...list1, ...list2];

// collection if / for（Dart 独有）
final items = [
  for (final a in articles) a.title,
  if (isAdmin) 'Admin Panel',
];
```

```kotlin
// Kotlin
val titles = articles.map { it.title }
val published = articles.filter { it.isBookmarked }
val total = articles.fold(0) { sum, a -> sum + (a.coin ?: 0) }

// spread 不直接支持，用 plus 或 buildList
val combined = list1 + list2
```

> **差异**：Dart 支持 **collection if/for**（在字面量中直接写条件和循环），这是 Kotlin 没有的语法。Dart 还有 `...` 展开操作符用于集合字面量。

---

## 7. 异步编程

两者都支持 `async/await`，但底层模型不同。

| 概念 | Dart | Kotlin |
|------|------|--------|
| 异步函数 | `Future<T>` | `suspend fun` |
| 等待结果 | `await` | `await`（协程中） |
| 异步流 | `Stream<T>` | `Flow<T>` |
| 无返回值异步 | `Future<void>` | `suspend fun` (Unit) |

**Dart**（来自 `auth_notifier.dart`）：
```dart
Future<void> login({
  required String username,
  required String password,
}) async {
  state = state.copyWith(isLoading: true);
  try {
    final result = await ref.read(authRepositoryProvider).login(
      username: username.trim(),
      password: password,
    );
    state = AuthUiState(isLoggedIn: true, user: result.user);
  } catch (e) {
    state = state.copyWith(isLoading: false, errorMessage: _parseError(e));
  }
}
```

**Kotlin 等价写法**：
```kotlin
suspend fun login(username: String, password: String) {
    state = state.copy(isLoading = true)
    try {
        val result = authRepository.login(
            username = username.trim(),
            password = password
        )
        state = AuthUiState(isLoggedIn = true, user = result.user)
    } catch (e: Exception) {
        state = state.copy(isLoading = false, errorMessage = parseError(e))
    }
}
```

> **差异**：Dart 用 `Future<T>` 作为异步返回类型，函数标 `async`；Kotlin 用 `suspend` 修饰符，返回类型是正常类型（`T` 而非 `Future<T>`）。Kotlin 的协程更强大，可以取消、有结构化并发；Dart 的 `Future` 类似 JS Promise，更简单直接。

---

## 8. 扩展

**Dart**（扩展方法）：
```dart
extension StringExt on String {
  bool get isValidEmail => contains('@') && contains('.');
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}

// 使用
'hello'.capitalize();  // "Hello"
```

**Kotlin**（扩展函数）：
```kotlin
fun String.isValidEmail(): Boolean = contains('@') && contains('.')
fun String.capitalize(): String = this[0].uppercaseChar() + substring(1)

// 使用
"hello".capitalize()  // "Hello"
```

> **相同点**：两者都支持对已有类添加扩展函数，语法相似。  
> **差异**：Dart 用 `extension Name on Type { }` 块语法，且可以给扩展命名（便于导入控制）；Kotlin 直接在顶层定义扩展函数，更简洁。

---

## 9. 泛型

**Dart**（来自 `home_notifier.dart`）：
```dart
@Default([]) List<Article> articles,

// 泛型类
class AsyncValue<T> { ... }

// 泛型函数
T firstOrDefault<T>(List<T> list, T defaultValue) =>
    list.isEmpty ? defaultValue : list.first;
```

**Kotlin 等价写法**：
```kotlin
val articles: List<Article> = emptyList()

class AsyncValue<T> { ... }

fun <T> firstOrDefault(list: List<T>, defaultValue: T): T =
    if (list.isEmpty()) defaultValue else list.first()
```

> **相同点**：泛型语法基本一致，都用 `<T>`。  
> **差异**：Kotlin 有 `reified`（具化泛型）可在运行时获取类型信息；Dart 泛型在运行时会保留类型（不像 Java 有类型擦除），但没有 `reified` 关键字。Kotlin 还有 `in`/`out` 型变修饰符，Dart 没有。

---

## 10. 模式匹配 / 条件表达式

**Dart 3.0+ 模式匹配**（switch 表达式）：
```dart
// switch 表达式（Dart 3.0+）
final label = switch (status) {
  AuthStatus.loading => '加载中',
  AuthStatus.loggedIn => '已登录',
  AuthStatus.loggedOut => '未登录',
};

// 密封类模式匹配（Freezed union）
state.when(
  loading: () => CircularProgressIndicator(),
  data: (articles) => ArticleList(articles),
  error: (e, _) => ErrorWidget(e.toString()),
);
```

**Kotlin `when` 表达式**：
```kotlin
val label = when (status) {
    AuthStatus.LOADING -> "加载中"
    AuthStatus.LOGGED_IN -> "已登录"
    AuthStatus.LOGGED_OUT -> "未登录"
}

// 密封类
when (val s = state) {
    is UiState.Loading -> CircularProgressIndicator()
    is UiState.Data -> ArticleList(s.articles)
    is UiState.Error -> ErrorWidget(s.error.message)
}
```

> **差异**：Kotlin 的 `when` 更强大，支持任意条件、范围、类型检查（`is`）且自动智能转换（smart cast）；Dart 3.0 的 `switch` 表达式也在追赶，支持模式解构，但生态中更常用 Freezed 的 `.when()`/`.map()` 方法。

---

## 11. 异常处理

**Dart**（来自 `auth_notifier.dart`）：
```dart
try {
  final token = await ref.read(authRepositoryProvider).getToken();
  state = AuthUiState(isLoggedIn: token != null);
} catch (e) {
  // Dart catch 不区分异常类型（默认捕获所有）
  state = const AuthUiState(isLoggedIn: false);
} finally {
  // 可选的 finally 块
}

// 捕获特定类型
} on DioException catch (e) {
  logger.e('网络错误', error: e);
}
```

**Kotlin 等价写法**：
```kotlin
try {
    val token = authRepository.getToken()
    state = AuthUiState(isLoggedIn = token != null)
} catch (e: Exception) {
    state = AuthUiState(isLoggedIn = false)
} finally {
    // 可选
}

// 捕获特定类型
} catch (e: IOException) {
    logger.e("网络错误", e)
}
```

> **差异**：Kotlin 所有异常都是非受检异常（unchecked），和 Dart 一致。Dart 的 `catch (e)` 可以不指定类型捕获所有；用 `on Type catch (e)` 指定类型。Kotlin 始终要在 `catch` 后写类型。

---

## 12. 作用域函数

Kotlin 有丰富的作用域函数（`let`/`run`/`with`/`apply`/`also`），Dart 没有内置等价物，通常用普通代码或级联操作符替代。

**Kotlin**：
```kotlin
// let：非空时执行
token?.let { options.headers["Authorization"] = "Bearer $it" }

// apply：配置对象
val dio = Dio().apply {
    baseUrl = "https://api.example.com"
    connectTimeout = 15.seconds
}

// also：链式副作用
createUser()
    .also { logger.d("创建用户: $it") }
    .also { database.save(it) }
```

**Dart 等价写法**：
```dart
// let → if 判断 + 临时变量
if (token != null) {
  options.headers['Authorization'] = 'Bearer $token';
}

// apply → 级联操作符 ..
final dio = Dio()
  ..options.baseUrl = 'https://api.example.com'
  ..options.connectTimeout = const Duration(seconds: 15);

// also → 没有直接等价，用临时变量
final user = createUser();
logger.d('创建用户: $user');
database.save(user);
```

> **差异**：Dart 的 `..` 级联操作符（cascade）可以替代 `apply`，但其他作用域函数没有内置替代品。Dart 代码通常更"直白"，少一些函数式链式风格。

---

## 13. 接口与抽象类

| 概念 | Dart | Kotlin |
|------|------|--------|
| 接口 | 任何类都可作为接口（`implements`） | `interface` 关键字 |
| 抽象类 | `abstract class` | `abstract class` |
| Mixin | `mixin` 关键字，用 `with` 混入 | 无直接对应（可用接口+默认实现） |
| 密封类 | `sealed class`（Dart 3.0+） | `sealed class` |

**Dart**（来自 `auth_notifier.dart`）：
```dart
// Mixin 用于代码复用
class AuthNotifier extends _$AuthNotifier {
  // _$AuthNotifier 是 Riverpod 代码生成的 mixin
}

// Freezed 生成的 mixin
abstract class User with _$User { ... }
```

**Kotlin 等价写法**：
```kotlin
// Kotlin 用接口默认方法替代 mixin
interface Serializable {
    fun toJson(): String = gson.toJson(this)
}

class User : Serializable, Copyable
```

> **差异**：Dart 的 `mixin` 是独立语言特性，可以单独定义可复用行为块，然后用 `with` 混入多个类；Kotlin 通过接口+默认实现来近似，但没有 `mixin` 语义上的"纯行为复用"。

---

## 14. 导入与模块

**Dart**（来自 `main.dart`）：
```dart
// 包导入
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 相对路径导入
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

// part 文件（代码生成）
part 'auth_notifier.freezed.dart';
part 'auth_notifier.g.dart';

// 导入时重命名
import 'package:some_lib/types.dart' as types;

// 只导入指定成员
import 'package:flutter/material.dart' show Widget, BuildContext;
```

**Kotlin 等价写法**：
```kotlin
import androidx.compose.material3.MaterialTheme
import com.example.reader.core.router.AppRouter

// Kotlin 没有 part 概念，生成代码通常在同包下单独文件
// 别名
import com.example.types as types

// 指定成员（Kotlin 不支持，用全限定名代替）
```

> **差异**：Dart 有 `part`/`part of` 机制，用于代码生成（Freezed、Riverpod）将生成文件关联到源文件；Kotlin 的代码生成（kapt/ksp）生成独立文件，不需要这种关联机制。

---

## 15. 注解

**Dart**（本项目大量使用）：
```dart
// Riverpod 注解
@Riverpod(keepAlive: true)
@riverpod

// Freezed 注解
@freezed
@Default(false)

// JSON 序列化
@JsonSerializable()
@JsonKey(name: 'user_id')

// Flutter 注解
@override
@immutable
```

**Kotlin 等价写法**：
```kotlin
// 注解语法类似
@Singleton
@Inject

@Parcelize
@JsonClass(generateAdapter = true)

@JsonName("user_id")

override  // 关键字，非注解
```

> **相同点**：注解语法都用 `@`，用法基本相同。  
> **差异**：Kotlin 的 `override` 是关键字；Dart 的 `@override` 是注解（不加也不会报错，只是最佳实践）。Kotlin 注解可以指定作用目标（`@get:`、`@field:`）；Dart 注解没有这类修饰。

---

## 16. 总览速查表

| 特性 | Dart | Kotlin | 相似度 |
|------|------|--------|--------|
| 变量声明 | `var` / `final` / `const` | `var` / `val` / `const val` | ★★★★☆ |
| 空安全 | `?` / `!` / `??` | `?` / `!!` / `?:` | ★★★★☆ |
| 字符串插值 | `'$var ${expr}'` | `"$var ${expr}"` | ★★★★★ |
| 命名参数 | `{required T param}` | `fun f(param: T)` | ★★★☆☆ |
| 数据类 | `@freezed` + 代码生成 | `data class`（内置） | ★★☆☆☆ |
| 集合字面量 | `[...]` / `{...}` | `listOf()` / `mapOf()` | ★★★☆☆ |
| 集合 if/for | `[if (c) x, for (v in l) v]` | 不支持 | ★☆☆☆☆ |
| 异步 | `Future<T>` / `async/await` | `suspend` / `async/await` | ★★★★☆ |
| 流 | `Stream<T>` | `Flow<T>` | ★★★☆☆ |
| 扩展方法 | `extension Name on Type {}` | `fun Type.ext()` | ★★★★☆ |
| 模式匹配 | `switch` 表达式（Dart 3+） | `when` 表达式 | ★★★☆☆ |
| 作用域函数 | `..` 级联 | `let/run/apply/also/with` | ★★☆☆☆ |
| Mixin | `mixin` / `with` | 接口默认方法（近似） | ★★☆☆☆ |
| 单例/对象 | `abstract class` + `static` | `object` 关键字 | ★★☆☆☆ |
| 泛型 | `<T>` | `<T>` / `reified T` | ★★★★☆ |
| 注解 | `@annotation` | `@annotation` | ★★★★★ |
| 顶层函数 | 支持 | 支持 | ★★★★★ |
| 异常处理 | `try/catch/on/finally` | `try/catch/finally` | ★★★★☆ |

---

## 小结

**语法高度相似（可直接迁移）：**
- 字符串插值（`$var`）
- 空安全操作符（`?`、`??` vs `?:`）
- 泛型（`<T>`）
- `async/await` 异步
- 扩展方法
- 注解（`@`）
- 顶层函数

**Dart 独有或显著不同：**
- `collection if/for`（集合字面量中的条件/循环）
- `..` 级联操作符
- `part`/`part of` 代码分割
- `mixin` 作为独立语言特性
- 数据类需要 `freezed` 包（语言层没有 `data class`）
- `late` 延迟初始化（比 Kotlin `lateinit` 更灵活，可用于 final）

**Kotlin 独有或显著不同：**
- `object`/`companion object`（内置单例）
- 丰富的作用域函数（`let`/`run`/`apply`/`also`/`with`）
- `data class`（内置，零依赖）
- `reified` 泛型（具化类型参数）
- `sealed class` 配合 `when` 的穷举检查更强
- 协程结构化并发（`CoroutineScope`/`Job`）比 Dart `Future` 更完整
