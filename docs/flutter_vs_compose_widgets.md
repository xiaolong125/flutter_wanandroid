# Flutter 与 Jetpack Compose 控件对比

> 基于 `flutter_reader` 项目实际使用的控件，与 Jetpack Compose 等价控件进行对照。

---

## 目录

1. [核心概念差异](#1-核心概念差异)
2. [布局控件](#2-布局控件)
3. [导航控件](#3-导航控件)
4. [列表控件](#4-列表控件)
5. [表单与输入控件](#5-表单与输入控件)
6. [按钮控件](#6-按钮控件)
7. [文本与图标控件](#7-文本与图标控件)
8. [图片控件](#8-图片控件)
9. [反馈与状态控件](#9-反馈与状态控件)
10. [主题与样式](#10-主题与样式)
11. [状态管理对比](#11-状态管理对比)
12. [代码示例对比](#12-代码示例对比)

---

## 1. 核心概念差异

| 概念 | Flutter | Jetpack Compose |
|------|---------|-----------------|
| 基本单元 | Widget（不可变描述） | Composable 函数（`@Composable`） |
| 树结构 | Widget Tree → Element Tree → RenderObject Tree | Composition → SlotTable → LayoutNode |
| 可变状态 | `StatefulWidget` + `setState` / Riverpod | `remember` + `mutableStateOf` / ViewModel |
| 布局方式 | 嵌套 Widget | 嵌套 Composable，配合 Modifier |
| 样式系统 | 参数直接传递 | `Modifier` 链式调用 |
| 重建粒度 | Widget 子树重建 | 智能重组（Recomposition），跳过未变化部分 |
| 入口 | `runApp(ProviderScope(child: MaterialApp.router(...)))` | `setContent { MaterialTheme { NavHost(...) } }` |

---

## 2. 布局控件

### Scaffold

**Flutter：**
```dart
Scaffold(
  appBar: AppBar(title: Text('首页')),
  body: Center(child: Text('内容')),
  bottomNavigationBar: NavigationBar(...),
)
```

**Compose：**
```kotlin
Scaffold(
  topBar = { TopAppBar(title = { Text("首页") }) },
  bottomBar = { NavigationBar { ... } }
) { paddingValues ->
  Box(modifier = Modifier.padding(paddingValues)) {
    Text("内容")
  }
}
```

> **关键差异：** Compose 的 `Scaffold` 通过 lambda 的 `PaddingValues` 参数强制处理内边距，避免内容被系统栏遮挡；Flutter 由框架自动处理。

---

### Column / Row

| Flutter | Compose | 说明 |
|---------|---------|------|
| `Column` | `Column` | 垂直排列 |
| `Row` | `Row` | 水平排列 |
| `mainAxisAlignment` | `verticalArrangement` / `horizontalArrangement` | 主轴对齐 |
| `crossAxisAlignment` | `horizontalAlignment` / `verticalAlignment` | 交叉轴对齐 |
| `Expanded` | `Modifier.weight(1f)` | 占满剩余空间 |
| `SizedBox(width: x)` | `Spacer(modifier = Modifier.width(x))` 或 `Spacer()` | 间距 |

**Flutter：**
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Expanded(child: Text('标题')),
    SizedBox(width: 8),
    Icon(Icons.arrow_forward),
  ],
)
```

**Compose：**
```kotlin
Row(
  modifier = Modifier.fillMaxWidth(),
  horizontalArrangement = Arrangement.SpaceBetween
) {
  Text("标题", modifier = Modifier.weight(1f))
  Spacer(modifier = Modifier.width(8.dp))
  Icon(Icons.Default.ArrowForward, contentDescription = null)
}
```

---

### Container / Box

| Flutter | Compose | 说明 |
|---------|---------|------|
| `Container` | `Box` + `Modifier` | 通用容器 |
| `decoration: BoxDecoration(...)` | `Modifier.background(...).border(...)` | 背景/边框 |
| `borderRadius: BorderRadius.circular(x)` | `Modifier.clip(RoundedCornerShape(x.dp))` | 圆角 |
| `padding: EdgeInsets.all(x)` | `Modifier.padding(x.dp)` | 内边距 |

**Flutter（来自 login_screen.dart）：**
```dart
Container(
  decoration: BoxDecoration(
    color: colorScheme.surface,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
  ),
  padding: const EdgeInsets.all(24),
  child: Column(...),
)
```

**Compose：**
```kotlin
Box(
  modifier = Modifier
    .background(
      color = MaterialTheme.colorScheme.surface,
      shape = RoundedCornerShape(16.dp)
    )
    .shadow(elevation = 4.dp, shape = RoundedCornerShape(16.dp))
    .padding(24.dp)
) {
  Column { ... }
}
```

---

### Padding / Center / SafeArea

| Flutter | Compose | 说明 |
|---------|---------|------|
| `Padding(padding: EdgeInsets.all(x), child: ...)` | `Modifier.padding(x.dp)` | 内边距 |
| `Center(child: ...)` | `Box(contentAlignment = Alignment.Center)` | 居中 |
| `SafeArea(child: ...)` | `WindowInsets` + `Modifier.safeDrawingPadding()` | 安全区域 |

---

### ClipRRect / 形状裁切

| Flutter | Compose | 说明 |
|---------|---------|------|
| `ClipRRect(borderRadius: ..., child: ...)` | `Modifier.clip(RoundedCornerShape(...))` | 圆角裁切 |
| `ClipOval(child: ...)` | `Modifier.clip(CircleShape)` | 圆形裁切 |

---

## 3. 导航控件

### 底部导航栏

| Flutter | Compose |
|---------|---------|
| `NavigationBar` | `NavigationBar` |
| `NavigationDestination` | `NavigationBarItem` |
| `selectedIndex` | `selectedItemIndex` / NavController |

**Flutter（来自 main_screen.dart）：**
```dart
NavigationBar(
  selectedIndex: _selectedIndex,
  onDestinationSelected: (index) => setState(() => _selectedIndex = index),
  destinations: const [
    NavigationDestination(icon: Icon(Icons.home_outlined), label: '首页'),
    NavigationDestination(icon: Icon(Icons.book_outlined), label: '书架'),
    NavigationDestination(icon: Icon(Icons.person_outlined), label: '我的'),
  ],
)
```

**Compose：**
```kotlin
NavigationBar {
  val navBackStackEntry by navController.currentBackStackEntryAsState()
  val currentRoute = navBackStackEntry?.destination?.route

  items.forEach { item ->
    NavigationBarItem(
      selected = currentRoute == item.route,
      onClick = { navController.navigate(item.route) },
      icon = { Icon(item.icon, contentDescription = item.label) },
      label = { Text(item.label) }
    )
  }
}
```

> **关键差异：** Flutter 用 `IndexedStack` 保持页面状态；Compose 配合 NavController，通过 `popUpTo` 和 `launchSingleTop` 实现同等效果。

---

### AppBar

| Flutter | Compose |
|---------|---------|
| `AppBar(title: Text('...'), actions: [...])` | `TopAppBar(title = { Text("...") }, actions = { ... })` |
| `leading: IconButton(...)` | `navigationIcon = { IconButton(...) }` |

---

### 页面内容切换

| Flutter | Compose |
|---------|---------|
| `IndexedStack(index: x, children: [...])` | `when(selectedTab) { ... }` 或 NavHost |

---

## 4. 列表控件

### ListView

| Flutter | Compose | 说明 |
|---------|---------|------|
| `ListView.builder(itemCount: n, itemBuilder: ...)` | `LazyColumn { items(list) { item -> ... } }` | 懒加载列表 |
| `ListView(children: [...])` | `Column { list.forEach { ... } }` | 静态列表（小数据量） |
| `RefreshIndicator(onRefresh: ..., child: ListView(...))` | `SwipeRefresh(state, onRefresh) { LazyColumn {...} }` | 下拉刷新 |
| `ListTile` | `ListItem` | 标准列表项 |

**Flutter（来自 home_screen.dart）：**
```dart
RefreshIndicator(
  onRefresh: () => ref.refresh(homeNotifierProvider.future),
  child: ListView.builder(
    itemCount: articles.length,
    itemBuilder: (context, index) => ArticleCard(article: articles[index]),
  ),
)
```

**Compose（使用 Accompanist SwipeRefresh）：**
```kotlin
val isRefreshing by viewModel.isRefreshing.collectAsState()

SwipeRefresh(
  state = rememberSwipeRefreshState(isRefreshing),
  onRefresh = { viewModel.refresh() }
) {
  LazyColumn {
    items(articles, key = { it.id }) { article ->
      ArticleCard(article = article)
    }
  }
}
```

---

### Card / InkWell

| Flutter | Compose |
|---------|---------|
| `Card(child: ...)` | `Card(modifier = Modifier.clickable {...}) { ... }` |
| `InkWell(onTap: ..., child: ...)` | `Modifier.clickable { ... }` |

**Flutter（来自 home_screen.dart）：**
```dart
Card(
  child: InkWell(
    onTap: () => context.push('/detail/${article.id}'),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(...),
    ),
  ),
)
```

**Compose：**
```kotlin
Card(
  modifier = Modifier
    .fillMaxWidth()
    .clickable { navController.navigate("detail/${article.id}") }
) {
  Row(modifier = Modifier.padding(12.dp)) { ... }
}
```

---

## 5. 表单与输入控件

### TextField

| 属性 | Flutter | Compose |
|------|---------|---------|
| 基本控件 | `TextField` | `TextField` / `OutlinedTextField` |
| 标签 | `decoration: InputDecoration(labelText: '...')` | `label = { Text("...") }` |
| 占位符 | `hintText: '...'` | `placeholder = { Text("...") }` |
| 前缀图标 | `prefixIcon: Icon(...)` | `leadingIcon = { Icon(...) }` |
| 密码输入 | `obscureText: true` | `visualTransformation = PasswordVisualTransformation()` |
| 边框样式 | `border: OutlineInputBorder(...)` | 使用 `OutlinedTextField` |
| 状态管理 | `TextEditingController` | `remember { mutableStateOf("") }` |

**Flutter（来自 login_screen.dart）：**
```dart
TextField(
  controller: _passwordController,
  obscureText: _obscurePassword,
  decoration: InputDecoration(
    labelText: '密码',
    prefixIcon: const Icon(Icons.lock_outline),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    suffixIcon: IconButton(
      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
    ),
  ),
)
```

**Compose：**
```kotlin
var password by remember { mutableStateOf("") }
var passwordVisible by remember { mutableStateOf(false) }

OutlinedTextField(
  value = password,
  onValueChange = { password = it },
  label = { Text("密码") },
  leadingIcon = { Icon(Icons.Outlined.Lock, contentDescription = null) },
  visualTransformation = if (passwordVisible) VisualTransformation.None
                         else PasswordVisualTransformation(),
  trailingIcon = {
    IconButton(onClick = { passwordVisible = !passwordVisible }) {
      Icon(
        if (passwordVisible) Icons.Default.Visibility else Icons.Default.VisibilityOff,
        contentDescription = null
      )
    }
  },
  shape = RoundedCornerShape(12.dp)
)
```

---

## 6. 按钮控件

| Flutter | Compose | 说明 |
|---------|---------|------|
| `FilledButton` | `Button` | 实心填充按钮（Material 3） |
| `ElevatedButton` | `ElevatedButton` | 带阴影按钮 |
| `OutlinedButton` | `OutlinedButton` | 描边按钮 |
| `TextButton` | `TextButton` | 纯文字按钮 |
| `IconButton` | `IconButton` | 图标按钮 |
| `FloatingActionButton` | `FloatingActionButton` | 悬浮按钮 |

**Flutter：**
```dart
FilledButton(
  onPressed: _isLoading ? null : _handleLogin,
  style: FilledButton.styleFrom(
    minimumSize: const Size(double.infinity, 52),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  child: _isLoading
    ? const CircularProgressIndicator(color: Colors.white)
    : const Text('登录'),
)
```

**Compose：**
```kotlin
Button(
  onClick = { if (!isLoading) handleLogin() },
  enabled = !isLoading,
  modifier = Modifier.fillMaxWidth().height(52.dp),
  shape = RoundedCornerShape(12.dp)
) {
  if (isLoading) {
    CircularProgressIndicator(color = Color.White, modifier = Modifier.size(20.dp))
  } else {
    Text("登录")
  }
}
```

---

## 7. 文本与图标控件

### Text

| 属性 | Flutter | Compose |
|------|---------|---------|
| 基本用法 | `Text('内容')` | `Text("内容")` |
| 样式 | `style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)` | `style = MaterialTheme.typography.titleMedium` |
| 主题样式 | `style: Theme.of(context).textTheme.titleMedium` | `style = MaterialTheme.typography.titleMedium` |
| 最大行数 | `maxLines: 2` | `maxLines = 2` |
| 溢出处理 | `overflow: TextOverflow.ellipsis` | `overflow = TextOverflow.Ellipsis` |
| 对齐 | `textAlign: TextAlign.center` | `textAlign = TextAlign.Center` |

### Icon

| Flutter | Compose |
|---------|---------|
| `Icon(Icons.home)` | `Icon(Icons.Default.Home)` |
| `Icon(Icons.home, size: 24, color: Colors.blue)` | `Icon(Icons.Default.Home, modifier = Modifier.size(24.dp), tint = Color.Blue)` |

### CircleAvatar

| Flutter | Compose |
|---------|---------|
| `CircleAvatar(radius: 30, backgroundImage: NetworkImage('...'))` | `AsyncImage(model = url, modifier = Modifier.size(60.dp).clip(CircleShape))` |

---

## 8. 图片控件

| Flutter | Compose | 说明 |
|---------|---------|------|
| `Image.network('...')` | `AsyncImage(model = '...')` （Coil） | 网络图片 |
| `CachedNetworkImage(imageUrl: '...')` | `AsyncImage(model = '...')` （Coil 内置缓存） | 带缓存网络图片 |
| `Image.asset('...')` | `Image(painterResource(R.drawable.xxx))` | 本地资源图片 |

**Flutter（来自 home_screen.dart）：**
```dart
ClipRRect(
  borderRadius: BorderRadius.circular(8),
  child: CachedNetworkImage(
    imageUrl: article.coverUrl,
    width: 80,
    height: 80,
    fit: BoxFit.cover,
    placeholder: (context, url) => ColoredBox(
      color: colorScheme.surfaceVariant,
      child: const SizedBox(width: 80, height: 80),
    ),
    errorWidget: (context, url, error) => const Icon(Icons.broken_image),
  ),
)
```

**Compose（使用 Coil）：**
```kotlin
AsyncImage(
  model = article.coverUrl,
  contentDescription = null,
  modifier = Modifier
    .size(80.dp)
    .clip(RoundedCornerShape(8.dp)),
  contentScale = ContentScale.Crop,
  placeholder = painterResource(R.drawable.placeholder),
  error = painterResource(R.drawable.broken_image)
)
```

---

## 9. 反馈与状态控件

| Flutter | Compose | 说明 |
|---------|---------|------|
| `CircularProgressIndicator()` | `CircularProgressIndicator()` | 圆形加载指示器 |
| `LinearProgressIndicator()` | `LinearProgressIndicator()` | 线形加载指示器 |
| `SnackBar` / `ScaffoldMessenger` | `SnackbarHost` + `snackbarHostState.showSnackbar()` | 底部提示条 |
| `AlertDialog` | `AlertDialog` | 对话框 |
| `Divider()` | `Divider()` 或 `HorizontalDivider()` | 分隔线 |
| `SingleChildScrollView` | `verticalScroll(rememberScrollState())` Modifier | 可滚动视图 |

---

## 10. 主题与样式

### 主题配置

**Flutter（来自 app_theme.dart）：**
```dart
ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF6750A4),
    brightness: Brightness.light,
  ),
  useMaterial3: true,
  appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
)
```

**Compose：**
```kotlin
MaterialTheme(
  colorScheme = lightColorScheme(
    primary = Color(0xFF6750A4),
    // ...
  ),
  typography = Typography(),
  shapes = Shapes(
    medium = RoundedCornerShape(12.dp)
  )
) {
  // 应用内容
}
```

### 颜色与排版访问

| Flutter | Compose |
|---------|---------|
| `Theme.of(context).colorScheme.primary` | `MaterialTheme.colorScheme.primary` |
| `Theme.of(context).textTheme.titleLarge` | `MaterialTheme.typography.titleLarge` |
| `Theme.of(context).cardTheme` | `MaterialTheme.shapes.medium` |

---

## 11. 状态管理对比

本项目使用 **Riverpod** 管理状态，对应 Android 的 **ViewModel + StateFlow**。

| 概念 | Flutter (Riverpod) | Android (ViewModel) |
|------|-------------------|---------------------|
| 状态容器 | `@riverpod class XxxNotifier extends _$XxxNotifier` | `class XxxViewModel : ViewModel()` |
| 状态类型 | `AsyncValue<T>` | `StateFlow<UiState>` |
| 状态读取 | `ref.watch(xxxNotifierProvider)` | `viewModel.uiState.collectAsState()` |
| 状态变更 | `state = await AsyncValue.guard(() => ...)` | `_uiState.update { ... }` |
| 副作用 | `ref.listen(...)` | `LaunchedEffect` / `lifecycleScope.launch` |
| 依赖注入 | `ref.watch(xxxRepositoryProvider)` | Hilt `@HiltViewModel` + `@Inject` |
| 全局持久 | `@Riverpod(keepAlive: true)` | `Application`级 ViewModel / Hilt SingletonComponent |

---

## 12. 代码示例对比

### 文章列表页完整对比

**Flutter（简化自 home_screen.dart）：**
```dart
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('发现')),
      body: switch (state) {
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
        AsyncError(:final error) => Center(child: Text('错误: $error')),
        AsyncData(:final value) => RefreshIndicator(
          onRefresh: () => ref.refresh(homeNotifierProvider.future),
          child: ListView.builder(
            itemCount: value.articles.length,
            itemBuilder: (ctx, i) => ArticleCard(article: value.articles[i]),
          ),
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
```

**Compose 等价实现：**
```kotlin
@Composable
fun HomeScreen(
  viewModel: HomeViewModel = hiltViewModel(),
  onArticleClick: (String) -> Unit
) {
  val uiState by viewModel.uiState.collectAsState()

  Scaffold(
    topBar = { TopAppBar(title = { Text("发现") }) }
  ) { padding ->
    Box(modifier = Modifier.padding(padding)) {
      when (val state = uiState) {
        is HomeUiState.Loading -> {
          CircularProgressIndicator(modifier = Modifier.align(Alignment.Center))
        }
        is HomeUiState.Error -> {
          Text("错误: ${state.message}", modifier = Modifier.align(Alignment.Center))
        }
        is HomeUiState.Success -> {
          val pullRefreshState = rememberPullRefreshState(
            refreshing = state.isRefreshing,
            onRefresh = { viewModel.refresh() }
          )
          Box(modifier = Modifier.pullRefresh(pullRefreshState)) {
            LazyColumn {
              items(state.articles, key = { it.id }) { article ->
                ArticleCard(article = article, onClick = { onArticleClick(article.id) })
              }
            }
            PullRefreshIndicator(
              refreshing = state.isRefreshing,
              state = pullRefreshState,
              modifier = Modifier.align(Alignment.TopCenter)
            )
          }
        }
      }
    }
  }
}
```

---

## 总结

| 维度 | Flutter 优势 | Compose 优势 |
|------|-------------|-------------|
| 跨平台 | iOS/Android/Web/Desktop 统一代码 | 仅 Android（Compose Multiplatform 扩展到其他平台但成熟度不同） |
| 样式系统 | 参数直接传递，结构清晰 | Modifier 链式调用，灵活组合 |
| 状态管理 | Riverpod 生态完善，与框架解耦 | 与 Android ViewModel/Hilt 深度集成 |
| 热重载 | 支持 Hot Reload | 支持 Live Edit |
| 性能 | Skia/Impeller 自绘，一致性强 | 与平台组件集成更好，无需自绘 |
| 学习曲线 | Dart + Widget 体系需适应 | Kotlin + Composable 与现有 Android 知识衔接好 |
| 控件命名 | 与 Compose 高度相似（均来自 Material Design） | 同上 |
