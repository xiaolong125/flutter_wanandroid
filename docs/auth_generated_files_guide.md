# Auth 生成文件说明

这份文档专门解释认证模块里的 3 个“生成文件”：

- `lib/features/auth/data/repository/auth_repository.g.dart`
- `lib/features/auth/presentation/auth_notifier.g.dart`
- `lib/features/auth/presentation/auth_state.freezed.dart`

如果你是第一次接触 Flutter + Riverpod + Freezed，可以把它理解成：

- 你平时主要写“源文件”
- `build_runner` 根据注解自动帮你生成“样板代码”
- 生成文件**不要手改**

---

## 1. 为什么这些文件会自动生成

在 Dart / Flutter 里，很多库会通过“注解 + 代码生成”减少重复劳动。

比如你写了这些注解：

- `@riverpod`
- `@Riverpod`
- `@freezed`

然后运行：

```bash
dart run build_runner build --delete-conflicting-outputs
```

生成器就会扫描项目中的注解，并自动创建对应的：

- `*.g.dart`
- `*.freezed.dart`

所以这些文件不是你手写的，而是“根据源文件推导出来的结果”。

---

## 2. 为什么你加的注释/日志会被覆盖

因为生成文件每次都会被重新生成。

生成器的逻辑大致是：

1. 读取源文件，例如 `auth_notifier.dart`
2. 根据注解重新计算应该生成什么代码
3. 直接覆盖旧的 `auth_notifier.g.dart`

所以：

- 你在生成文件里手动加的注释，会丢失
- 你在生成文件里手动加的日志，也会丢失
- 这是正常现象，不是 Flutter 出 bug

**结论：**

- 需要长期保留的说明，写到源文件或 `docs/`
- 需要真正运行时执行的日志，写到源文件的方法里

---

## 3. 三类文件的分工

| 文件 | 来源 | 负责什么 | 能不能手改 |
|---|---|---|---|
| `auth_repository.g.dart` | `@riverpod` 函数 | 生成 Provider | 不要 |
| `auth_notifier.g.dart` | `@Riverpod` 类 | 生成 Notifier Provider 和基类 | 不要 |
| `auth_state.freezed.dart` | `@freezed` | 生成联合类型、模式匹配、相等性、`toString()` 等 | 不要 |

可以简单记成：

- Riverpod 负责“依赖注入 / 状态入口”
- Freezed 负责“数据结构 / 状态类型”

---

## 4. `auth_repository.g.dart` 是什么

对应源文件：

- `lib/features/auth/data/repository/auth_repository.dart`

你在源文件里写的是：

```dart
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    ref.watch(authApiProvider),
    ref.watch(secureStorageProvider),
    ref.watch(appLoggerProvider),
  );
}
```

生成器会帮你生成：

- `authRepositoryProvider`
- Provider 的类型定义
- 调试用的 hash

### 它的作用

它的本质是把这个函数：

```dart
AuthRepository authRepository(Ref ref)
```

变成一个可以被 Riverpod 管理和读取的 Provider。

之后你才能在别的地方这样写：

```dart
ref.read(authRepositoryProvider)
ref.watch(authRepositoryProvider)
```

### 你最需要理解的点

- 你真正维护的是 `auth_repository.dart`
- `.g.dart` 只是把它包装成 Riverpod 能识别的 Provider
- 业务逻辑、日志、参数校验，都应该写在 `auth_repository.dart`

---

## 5. `auth_notifier.g.dart` 是什么

对应源文件：

- `lib/features/auth/presentation/auth_notifier.dart`

你在源文件里写的是：

```dart
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    ...
  }
}
```

生成器会帮你生成：

- `authNotifierProvider`
- `typedef _$AuthNotifier = Notifier<AuthState>`

### 它的作用

它解决了两个问题：

1. 给 `AuthNotifier` 生成对应的 Provider
2. 给你的类提供一个“可继承的基类别名” `_$AuthNotifier`

所以你才能这样写：

```dart
class AuthNotifier extends _$AuthNotifier
```

以及在 UI 中这样用：

```dart
final state = ref.watch(authNotifierProvider);
final notifier = ref.read(authNotifierProvider.notifier);
```

### `keepAlive: true` 的意义

认证状态是全局重要状态，不希望页面切换时被销毁，所以这里用了：

```dart
@Riverpod(keepAlive: true)
```

这也是为什么登录状态能在路由跳转时持续存在。

### 你最需要理解的点

- `auth_notifier.dart` 负责“状态变化逻辑”
- `auth_notifier.g.dart` 负责“把这个状态类注册成 Provider”
- 真正的日志要写在 `login()`、`register()`、`logout()`、`_checkAuthState()` 这些方法里

---

## 6. `auth_state.freezed.dart` 是什么

对应源文件：

- `lib/features/auth/presentation/auth_state.dart`

你在源文件里写的是：

```dart
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.checking() = AuthStateChecking;
  const factory AuthState.loading() = AuthStateLoading;
  const factory AuthState.authenticated(User user) = AuthStateAuthenticated;
  const factory AuthState.unauthenticated() = AuthStateUnauthenticated;
  const factory AuthState.failure(String message) = AuthStateFailure;
}
```

Freezed 会帮你自动生成大量重复代码。

### 它生成了什么

最重要的是这些能力：

1. **具体实现类**
   - `AuthStateChecking`
   - `AuthStateLoading`
   - `AuthStateAuthenticated`
   - `AuthStateUnauthenticated`
   - `AuthStateFailure`

2. **模式匹配方法**
   - `when`
   - `whenOrNull`
   - `maybeWhen`
   - `map`
   - `mapOrNull`
   - `maybeMap`

3. **常用样板代码**
   - `==`
   - `hashCode`
   - `toString()`
   - 某些场景下的 `copyWith`

### 为什么它很重要

没有 Freezed 的话，你要手写很多状态类和判断逻辑。

有了 Freezed，你可以很清楚地表达：

- 现在在检查登录态
- 现在在加载
- 现在已登录
- 现在未登录
- 现在失败了

这非常适合 UI 状态管理。

### `when` 和 `map` 怎么理解

#### `when`

更像“按状态分支处理数据”：

```dart
state.when(
  checking: () => ...,
  loading: () => ...,
  authenticated: (user) => ...,
  unauthenticated: () => ...,
  failure: (message) => ...,
);
```

适合：你关心每种状态“要显示什么 / 要做什么”。

#### `map`

更像“按具体类型对象分支”：

```dart
state.map(
  checking: (value) => ...,
  loading: (value) => ...,
  authenticated: (value) => value.user,
  unauthenticated: (value) => ...,
  failure: (value) => value.message,
);
```

适合：你想直接拿到某个具体状态对象本身。

### 你最需要理解的点

- `auth_state.dart` 才是你定义状态的地方
- `auth_state.freezed.dart` 只是 Freezed 帮你展开后的结果
- 如果你想新增一个状态，改的是 `auth_state.dart`

---

## 7. 这 3 个文件和源文件的关系

可以把它理解成下面这张关系图：

```text
auth_repository.dart
   └─ 经过 @riverpod 生成 → auth_repository.g.dart

auth_notifier.dart
   └─ 经过 @Riverpod 生成 → auth_notifier.g.dart

auth_state.dart
   └─ 经过 @freezed 生成 → auth_state.freezed.dart
```

也就是说：

- 你改源文件
- 生成器改生成文件

不是反过来。

---

## 8. 如果你想“加日志”，应该加在哪里

### 应该加在源文件

#### 给仓库层加日志

写在：

- `lib/features/auth/data/repository/auth_repository.dart`

适合记录：

- 登录请求开始
- 登录成功 / 失败
- 本地 token 是否存在
- 退出登录是否成功

#### 给状态层加日志

写在：

- `lib/features/auth/presentation/auth_notifier.dart`

适合记录：

- `build()` 触发
- `_checkAuthState()` 结果
- `state` 从什么变成什么

#### 给状态值增加“便于打印的文本”

写在：

- `lib/features/auth/presentation/auth_state.dart`

适合做：

- `debugLabel`
- 辅助 getter
- 状态解释性注释

### 不应该加在生成文件

不要把日志写在：

- `auth_repository.g.dart`
- `auth_notifier.g.dart`
- `auth_state.freezed.dart`

因为下一次运行生成命令就会被覆盖。

---

## 9. 什么时候需要重新生成

当你修改了这些源文件里的“注解相关内容”时，一般要重新生成：

- `@riverpod`
- `@Riverpod`
- `@freezed`
- `@JsonSerializable`
- `@RestApi`

常用命令：

```bash
dart run build_runner build --delete-conflicting-outputs
```

开发时持续监听：

```bash
dart run build_runner watch --delete-conflicting-outputs
```

---

## 10. 新手最容易踩的坑

### 坑 1：手改生成文件

结果：下次生成直接丢失。

### 坑 2：看到 `_$AuthNotifier` 觉得很神秘

其实它只是生成器提供的基类别名，你可以理解成：

```dart
typedef _$AuthNotifier = Notifier<AuthState>;
```

### 坑 3：不知道该改 `.dart` 还是 `.g.dart`

记住一句话：

> 业务逻辑改源文件，生成器产物不要手改。

### 坑 4：新增状态后忘了重新生成

表现：

- 报类型错误
- 找不到生成的方法
- IDE 提示不完整

这时通常重新跑一次 `build_runner` 就行。

---

## 11. 一句话总结

这 3 个文件都属于“编译辅助代码”：

- `auth_repository.g.dart`：把仓库函数变成 Riverpod Provider
- `auth_notifier.g.dart`：把状态类变成 Riverpod Notifier Provider
- `auth_state.freezed.dart`：把状态定义展开成完整的联合类型实现

你平时应该重点阅读和修改的是：

- `lib/features/auth/data/repository/auth_repository.dart`
- `lib/features/auth/presentation/auth_notifier.dart`
- `lib/features/auth/presentation/auth_state.dart`

如果你愿意，下一步我可以继续帮你再写一份“认证模块完整调用链文档”，把 `LoginScreen → AuthNotifier → AuthRepository → AuthApi → Dio` 串起来。
