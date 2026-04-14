# Auth 模块完整调用链

> 基于当前项目源码，按“应用启动 → 路由判断 → 登录提交 → 网络请求 → 本地持久化 → 路由跳转”的顺序讲清认证流程。
>
> 如果你对 `*.g.dart` / `*.freezed.dart` 还不熟，可以先配合阅读 `docs/auth_generated_files_guide.md`。

---

## 目录

1. [先看整体：Auth 调用链全景](#1-先看整体auth-调用链全景)
2. [应用启动时发生了什么](#2-应用启动时发生了什么)
3. [从登录页点击按钮后发生了什么](#3-从登录页点击按钮后发生了什么)
4. [AuthNotifier 在中间做了什么](#4-authnotifier-在中间做了什么)
5. [AuthRepository 在中间做了什么](#5-authrepository-在中间做了什么)
6. [AuthApi 和 Dio 在中间做了什么](#6-authapi-和-dio-在中间做了什么)
7. [为什么登录成功后页面会自动跳转](#7-为什么登录成功后页面会自动跳转)
8. [失败时错误是怎么显示到页面上的](#8-失败时错误是怎么显示到页面上的)
9. [注册和退出登录的调用链](#9-注册和退出登录的调用链)
10. [你应该重点阅读哪些文件](#10-你应该重点阅读哪些文件)
11. [调试这条链路时建议看哪里](#11-调试这条链路时建议看哪里)

---

## 1. 先看整体：Auth 调用链全景

先用一张图把主链路串起来：

```text
main.dart
  ↓
ProviderScope
  ↓
FlutterWanandroidApp
  ↓
MaterialApp.router
  ↓
appRouterProvider (GoRouter)
  ↓
authNotifierProvider
  ↓
AuthNotifier.build()
  ↓
_checkAuthState()
  ↓
authRepositoryProvider
  ↓
AuthRepository.readToken() / readUser()
  ↓
FlutterSecureStorage
  ↓
更新 AuthState
  ↓
GoRouter redirect
  ↓
/login 或 /
```

用户点击登录按钮后的链路：

```text
LoginScreen._submitLogin()
  ↓
ref.read(authNotifierProvider.notifier).login(...)
  ↓
AuthNotifier.login()
  ↓
AuthRepository.login()
  ↓
AuthApi.login()
  ↓
Dio 发起 POST /user/login
  ↓
WanAndroid 返回用户数据 + Set-Cookie
  ↓
AuthRepository._persistSession()
  ↓
写入 secure storage
  ↓
state = AuthState.authenticated(user)
  ↓
GoRouter redirect
  ↓
跳转到 /
```

你可以先记住一句话：

> 登录页本身不负责“决定跳转到首页”，真正决定跳转的是全局 `AuthState` + `GoRouter redirect`。

---

## 2. 应用启动时发生了什么

### 2.1 应用入口

入口在：

- `lib/main.dart`

这里最重要的一行是：

```dart
runApp(const ProviderScope(child: FlutterWanandroidApp()));
```

含义是：

- `ProviderScope` 是 Riverpod 的全局容器
- 整个 App 里的所有 Provider 都在这个容器里运行

### 2.2 挂载 Router

然后进入：

- `lib/app.dart`

这里通过：

```dart
final router = ref.watch(appRouterProvider);
```

把路由对象拿出来，并交给：

```dart
MaterialApp.router(routerConfig: router)
```

也就是说，整个 App 的页面跳转逻辑最终都收敛到：

- `appRouterProvider`
- `GoRouter`

### 2.3 初始路由先进入启动页

在：

- `lib/core/router/app_router.dart`

里可以看到：

```dart
initialLocation: '/startup'
```

所以 App 启动后不是直接进登录页，而是先进：

- `StartupScreen`

这是一个“启动/欢迎/协议确认”页面。

### 2.4 Router 会监听 AuthState

`appRouterProvider` 里有一段很关键的代码：

```dart
ref.listen<AuthState>(
  authNotifierProvider,
  (_, __) => refreshNotifier.refresh(),
);
```

意思是：

- 只要认证状态变化
- Router 就刷新一次
- 刷新后重新执行 `redirect`

这就是为什么登录成功后，即使登录页没有手写 `context.go('/')`，页面也能自动跳转。

### 2.5 AuthNotifier 会在第一次被读取时初始化

在 Router 的 `redirect` 里，有这句：

```dart
final authState = ref.read(authNotifierProvider);
```

这是第一次真正读取认证状态。

一旦第一次读取 `authNotifierProvider`，就会触发：

- `AuthNotifier.build()`

也就是：

- `lib/features/auth/presentation/auth_notifier.dart`

里的初始化逻辑开始执行。

### 2.6 AuthNotifier.build() 的作用

`build()` 里做了两件事：

1. 先立刻返回：

```dart
const AuthState.checking()
```

表示：

- 现在还没确定是否登录
- 先进入“检查中”状态

2. 然后异步执行：

```dart
Future.microtask(_checkAuthState);
```

也就是去本地读取：

- token
- user

### 2.7 `_checkAuthState()` 如何判断是否登录

`_checkAuthState()` 内部会调用：

```dart
final repository = ref.read(authRepositoryProvider);
final token = await repository.readToken();
final user = await repository.readUser();
```

如果满足：

- `token != null`
- `token.isNotEmpty`
- `user != null`

则设置：

```dart
state = AuthState.authenticated(user);
```

否则设置：

```dart
state = const AuthState.unauthenticated();
```

这一步非常关键，因为它决定了启动后最终应该去：

- `/`
- 还是 `/login`

### 2.8 StartupScreen 如何衔接这个过程

启动页在：

- `lib/features/startup/presentation/startup_screen.dart`

里面会监听：

```dart
ref.listen<AuthState>(authNotifierProvider, (_, next) {
  _scheduleEnterIfReady(next);
});
```

而 `_enterApp()` 最终会根据：

```dart
authState.isAuthenticated ? '/' : '/login'
```

进行跳转。

所以启动流程不是“写死去登录页”，而是：

1. 先进入 `/startup`
2. 等欢迎页/协议逻辑准备完成
3. 再结合 `AuthState` 决定去首页还是登录页

---

## 3. 从登录页点击按钮后发生了什么

### 3.1 登录页监听的是全局认证状态

登录页在：

- `lib/features/auth/presentation/login_screen.dart`

它先通过：

```dart
final authState = ref.watch(authNotifierProvider);
```

得到当前认证状态。

然后通过：

```dart
final isBusy = authState.isBusy;
```

来决定：

- 按钮是否禁用
- 是否显示加载动画

也就是说，登录按钮“转圈圈”不是它自己管理的，而是来自全局 `AuthState`。

### 3.2 点击登录按钮先做本地校验

点击按钮后会执行：

```dart
_submitLogin()
```

它先做 3 个前置检查：

1. 用户名是否为空
2. 密码是否为空
3. 是否勾选协议

如果任何一个不满足，就直接弹框，不会发网络请求。

### 3.3 真正提交登录的代码

校验通过后，执行的是：

```dart
ref
  .read(authNotifierProvider.notifier)
  .login(username: username, password: password);
```

这句可以拆成两部分理解：

- `authNotifierProvider.notifier`：拿到状态控制器本身
- `.login(...)`：调用认证业务方法

这里用的是 `read` 而不是 `watch`，因为：

- 这是一次“动作触发”
- 不是为了监听 UI 自动刷新

---

## 4. AuthNotifier 在中间做了什么

`AuthNotifier` 位于：

- `lib/features/auth/presentation/auth_notifier.dart`

你可以把它理解成：

> 认证流程的“状态总调度器”

它不直接发网络请求，而是负责：

- 切换状态
- 调用 Repository
- 把错误转换成 UI 可展示文本

### 4.1 登录时的状态变化

`login()` 的顺序是：

#### 第一步：先进入 loading

```dart
state = const AuthState.loading();
```

这会立刻影响 UI：

- 登录页按钮变灰
- 按钮文字变成 loading 圈
- Router 也会看到当前是 busy 状态

#### 第二步：调用仓库层

```dart
final user = await ref
  .read(authRepositoryProvider)
  .login(username: username, password: password);
```

说明：

- Notifier 不关心 HTTP 细节
- 它只关心“仓库层能不能返回一个 User”

#### 第三步：根据结果切状态

成功：

```dart
state = AuthState.authenticated(user);
```

失败：

```dart
state = AuthState.failure(readableMessage(error));
```

这里的 `readableMessage(error)` 负责把底层异常转换成适合显示给用户的话。

### 4.2 为什么 Notifier 不直接操作 UI

因为在这个架构里：

- UI 只负责展示和收集输入
- Notifier 负责状态变化
- Repository 负责数据获取和持久化

这样分层以后：

- 更容易测试
- 更容易定位问题
- UI 不会和网络请求强耦合

---

## 5. AuthRepository 在中间做了什么

`AuthRepository` 位于：

- `lib/features/auth/data/repository/auth_repository.dart`

它是“业务数据中间层”，位于：

- Notifier 和 API 之间

### 5.1 它的职责

这个类主要负责：

1. 处理登录/注册的输入规范化
2. 做基础参数校验
3. 调用远程 API
4. 解析服务端返回
5. 提取登录 Cookie
6. 把 token 和 user 写入本地存储
7. 读取本地登录态
8. 退出登录时清空本地数据

### 5.2 登录流程在 Repository 里怎么走

#### 第一步：清洗输入

```dart
final normalizedUsername = username.trim();
final normalizedPassword = password.trim();
```

这样可以避免：

- 用户前后误输入空格

#### 第二步：校验空值

```dart
if (normalizedUsername.isEmpty || normalizedPassword.isEmpty) {
  throw Exception('请输入用户名和密码');
}
```

这层校验和 UI 层校验并不冲突。

你可以把它理解成：

- UI 校验：给用户更快反馈
- Repository 校验：兜底，防止非法调用

#### 第三步：发起 API 请求

```dart
final response = await _api.login(normalizedUsername, normalizedPassword);
```

这里的 `_api` 是 `AuthApi`。

#### 第四步：持久化登录态

```dart
final user = await _persistSession(response);
```

`_persistSession()` 做了最关键的事情：

1. 从响应体里解析用户 JSON
2. 从响应头里提取 `Set-Cookie`
3. 写入本地安全存储

### 5.3 本地存储了什么

在：

- `lib/core/network/dio_client.dart`

里定义了两个 key：

```dart
const authTokenStorageKey = 'auth_token';
const authUserStorageKey = 'auth_user';
```

也就是说，登录成功后会把两份数据写到本地：

1. `auth_token`
   - 实际上保存的是从响应头提取出的 Cookie 串

2. `auth_user`
   - 用户 JSON 字符串

### 5.4 为什么这里保存的是 Cookie，不是 Bearer Token

因为 WanAndroid 的登录态是通过 Cookie 维持的。

你可以看到 Dio 拦截器里写的是：

```dart
options.headers['Cookie'] = authCookie;
```

而不是：

```dart
Authorization: Bearer xxx
```

这说明当前项目的认证方式是：

- Cookie 会话认证

### 5.5 Repository 里的日志在记录什么

目前仓库层已经接了 `appLoggerProvider`，会记录：

- 读取本地 token 是否存在
- 读取本地用户是否成功
- 登录/注册请求是否开始
- 登录/注册是否成功
- 远端退出登录是否成功
- 本地 session 是否写入成功

这非常适合你调试“到底是哪一层出错了”。

---

## 6. AuthApi 和 Dio 在中间做了什么

### 6.1 AuthApi 只负责声明接口

`AuthApi` 位于：

- `lib/features/auth/data/remote/auth_api.dart`

它使用 Retrofit 注解声明接口：

#### 登录

```dart
@POST('/user/login')
Future<HttpResponse<dynamic>> login(...)
```

#### 注册

```dart
@POST('/user/register')
Future<HttpResponse<dynamic>> register(...)
```

#### 退出

```dart
@GET('/user/logout/json')
Future<dynamic> logout()
```

注意：

- `AuthApi` 自己不写请求细节
- Retrofit 生成器会根据注解自动生成真正的实现

### 6.2 Dio 是真正发请求的人

`Dio` 的创建在：

- `lib/core/network/dio_client.dart`

这里配置了：

- `baseUrl = https://www.wanandroid.com`
- 超时时间
- `responseType: ResponseType.json`

### 6.3 请求发出前会自动注入 Cookie

在 `onRequest` 拦截器里：

```dart
final authCookie = await storage.read(key: authTokenStorageKey);
if (authCookie != null && authCookie.isNotEmpty) {
  options.headers['Cookie'] = authCookie;
}
```

意思是：

- 每次请求前，都先看看本地有没有登录 Cookie
- 如果有，就自动带上

这样登录后，后续所有需要登录态的请求都能自动复用这份 Cookie。

### 6.4 网络日志在哪里打印

`dio_client.dart` 里注册了：

```dart
dio.interceptors.add(_NetworkLogInterceptor(logger));
```

这个拦截器会记录：

- 请求方法和 URL
- Query 参数
- 请求头
- 请求体
- 响应状态码
- 响应体
- 错误信息
- 请求耗时

同时它还会对敏感 Header 做脱敏：

- `authorization`
- `cookie`
- `set-cookie`

所以你能看到网络日志，又不会把敏感信息完整打出来。

---

## 7. 为什么登录成功后页面会自动跳转

这是很多新手最容易疑惑的地方。

### 7.1 登录页没有直接跳首页

在 `LoginScreen` 中，点击登录后只是调用了：

```dart
ref.read(authNotifierProvider.notifier).login(...)
```

它没有写：

```dart
context.go('/')
```

所以页面跳转不是登录页自己做的。

### 7.2 真正做跳转判断的是 Router

在：

- `lib/core/router/app_router.dart`

里有核心逻辑：

```dart
if (!authState.isAuthenticated && !isAuthRoute) {
  return '/login';
}

if (authState.isAuthenticated && isAuthRoute) {
  return '/';
}
```

它的意思是：

- 未登录还想进业务页 → 强制去 `/login`
- 已登录还停留在登录/注册页 → 强制去 `/`

### 7.3 为什么状态一变，Router 就知道

因为 Router 在监听：

```dart
authNotifierProvider
```

一旦 `AuthNotifier.login()` 成功，执行：

```dart
state = AuthState.authenticated(user);
```

Router 就会刷新并重新执行 `redirect`。

于是：

- 当前页面如果是 `/login`
- 且当前状态是 `authenticated`

就会自动跳到：

- `/`

### 7.4 这套设计的好处

好处是“跳转规则统一放在 Router 层”。

这样可以避免：

- 登录页自己跳一次
- 启动页自己跳一次
- 某些页面又手动判断一次

统一后，整个项目会更稳定。

---

## 8. 失败时错误是怎么显示到页面上的

### 8.1 底层先抛异常

比如：

- 参数校验不通过
- 服务端返回 `errorCode != 0`
- Cookie 提取失败
- JSON 结构异常

这些错误会先在 Repository 里抛出异常。

### 8.2 Notifier 把异常转成失败状态

`AuthNotifier.login()` 里：

```dart
catch (error) {
  state = AuthState.failure(readableMessage(error));
}
```

所以 UI 最终看到的不是原始异常对象，而是：

- `AuthState.failure(message)`

### 8.3 LoginScreen 监听错误消息

登录页里有：

```dart
ref.listen(authNotifierProvider, (previous, next) {
  final previousMessage = previous?.errorMessage;
  final nextMessage = next.errorMessage;
  if (nextMessage != null && nextMessage != previousMessage) {
    _showMessage(nextMessage);
  }
});
```

意思是：

- 只要新的状态里出现错误消息
- 并且这条消息和上一条不同
- 就弹出对话框提示用户

所以错误展示的链路是：

```text
Repository throw Exception
  ↓
AuthNotifier.catch
  ↓
state = AuthState.failure(message)
  ↓
LoginScreen ref.listen(...)
  ↓
showDialog(...)
```

---

## 9. 注册和退出登录的调用链

### 9.1 注册流程

注册和登录几乎完全一样，只是入口换成：

- `AuthNotifier.register()`
- `AuthRepository.register()`
- `AuthApi.register()`

差别主要在：

- 多了确认密码参数
- Repository 里多了“密码一致性”和“长度”校验

注册成功后同样会：

1. 保存 Cookie
2. 保存用户信息
3. 设置 `AuthState.authenticated(user)`
4. Router 自动跳到首页

### 9.2 退出登录流程

退出登录走的是：

```text
某个页面调用 authNotifier.logout()
  ↓
AuthRepository.logout()
  ↓
AuthApi.logout()
  ↓
删除 auth_token / auth_user
  ↓
state = AuthState.unauthenticated()
  ↓
Router redirect 到 /login
```

这里有一个很实用的设计：

- 即使远端 logout 失败
- 本地数据仍然会被清掉

这样用户依然能退出当前设备的登录状态。

---

## 10. 你应该重点阅读哪些文件

如果你第一次学 Flutter，这个认证链路建议按这个顺序读：

### 第 1 步：先看页面怎么触发动作

- `lib/features/auth/presentation/login_screen.dart`

重点看：

- `ref.watch(authNotifierProvider)`
- `ref.listen(authNotifierProvider, ...)`
- `_submitLogin()`

### 第 2 步：再看状态如何变化

- `lib/features/auth/presentation/auth_notifier.dart`
- `lib/features/auth/presentation/auth_state.dart`

重点看：

- `build()`
- `_checkAuthState()`
- `login()`
- `logout()`
- `AuthState` 的 5 种状态

### 第 3 步：再看数据从哪来

- `lib/features/auth/data/repository/auth_repository.dart`

重点看：

- `readToken()`
- `readUser()`
- `login()`
- `register()`
- `logout()`
- `_persistSession()`

### 第 4 步：最后看网络层

- `lib/features/auth/data/remote/auth_api.dart`
- `lib/core/network/dio_client.dart`

重点看：

- Retrofit 接口声明
- Dio 拦截器
- Cookie 注入
- 网络日志

### 第 5 步：回头看为什么会跳转

- `lib/core/router/app_router.dart`
- `lib/features/startup/presentation/startup_screen.dart`

重点看：

- `redirect`
- `authState.isBusy`
- `authState.isAuthenticated`

---

## 11. 调试这条链路时建议看哪里

如果你想真正掌握这个模块，我建议你按下面方式打断点或看日志。

### 11.1 最适合打断点的地方

1. `LoginScreen._submitLogin()`
2. `AuthNotifier.login()`
3. `AuthRepository.login()`
4. `AuthRepository._persistSession()`
5. `app_router.dart` 里的 `redirect`

只看这 5 个点，你就能看清 80% 的认证流程。

### 11.2 最适合观察的日志

现在项目里已经有两类很有价值的日志：

#### Repository 业务日志

可以看到：

- 登录请求是否发起
- 登录是否成功
- 本地 session 是否写入
- 本地 token/user 是否读取成功

#### Dio 网络日志

可以看到：

- 请求 URL
- 请求参数
- 响应结果
- 错误信息
- 请求耗时

### 11.3 推荐你用“顺藤摸瓜”的方式理解

你可以只追一条链：

```text
点登录按钮
  ↓
按钮调用哪个方法？
  ↓
这个方法调用哪个 provider？
  ↓
provider 里又调用哪个 repository？
  ↓
repository 里什么时候发请求？
  ↓
什么时候写本地存储？
  ↓
什么时候 state 变成 authenticated？
  ↓
router 为什么跳转？
```

只要这条链看懂，Flutter 里很多“页面 → 状态 → 数据 → 路由”的模式你都会越来越熟。

---

## 一句话总结

这个项目的认证模块本质上是 4 层协作：

```text
UI（LoginScreen）
  ↓
状态层（AuthNotifier / AuthState）
  ↓
数据层（AuthRepository）
  ↓
网络层（AuthApi / Dio）
```

然后再加一个全局路由守卫：

```text
AuthState 变化
  ↓
GoRouter redirect
  ↓
自动决定去首页还是登录页
```

如果你把这条链理解透了，你就已经掌握了这个项目里 Flutter + Riverpod + Freezed + Dio + GoRouter 的核心协作方式。
