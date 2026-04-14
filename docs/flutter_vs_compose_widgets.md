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
13. [常用布局与组件速查表](#13-常用布局与组件速查表)
14. [Compose Modifier → Flutter 写法对照表](#14-compose-modifier--flutter-写法对照表)

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

---

## 13. 常用布局与组件速查表

> 前文偏详细说明；本节整理成速查版，适合从 Compose 切到 Flutter 时快速对照。

### 13.1 常用布局

| Compose | Flutter | 说明 |
|---------|---------|------|
| `Column` | `Column` | 垂直布局 |
| `Row` | `Row` | 水平布局 |
| `Box` | `Stack` / `Container` | 叠放或通用容器 |
| `Spacer()` | `Spacer()` / `SizedBox()` | 占位与间距 |
| `Modifier.weight(1f)` | `Expanded(flex: 1)` / `Flexible` | 按比例分配剩余空间 |
| `fillMaxSize()` | `SizedBox.expand()` | 宽高同时铺满 |
| `fillMaxWidth()` | `SizedBox(width: double.infinity)` / `Container(width: double.infinity)` | 宽度铺满 |
| `fillMaxHeight()` | `SizedBox(height: double.infinity)` / `Container(height: double.infinity)` | 高度铺满 |
| `wrapContentSize()` | 默认尺寸行为 | 按内容包裹 |
| `LazyColumn` | `ListView.builder` | 懒加载纵向列表 |
| `LazyRow` | `ListView(scrollDirection: Axis.horizontal)` | 懒加载横向列表 |
| `LazyVerticalGrid` | `GridView.builder` / `GridView.count` | 网格布局 |
| `Box(contentAlignment = Alignment.Center)` | `Center` / `Stack(alignment: Alignment.center)` | 内容居中 |
| `Arrangement.spacedBy(8.dp)` | 子项间插入 `SizedBox(height: 8)` / `SizedBox(width: 8)` | 固定间距 |
| `FlowRow` / `FlowColumn` | `Wrap` | 自动换行布局 |

### 13.2 常用布局包装组件

| Compose 思路 | Flutter 常用写法 | 说明 |
|-------------|------------------|------|
| `padding(...)` | `Padding` | 内边距优先单独包一层 |
| `align(...)` | `Align` / `Center` | 对齐优先单独包一层 |
| `size(...)` | `SizedBox` | 固定宽高 |
| `background(...)` | `ColoredBox` / `Container(color: ...)` | 纯背景色 |
| `clip(...)` | `ClipRRect` / `ClipOval` | 裁切形状 |
| `border(...)` | `Container(decoration: BoxDecoration(border: ...))` | 边框 |
| `clickable {}` | `InkWell` / `GestureDetector` | 点击事件 |
| `alpha(...)` | `Opacity` | 透明度 |
| `aspectRatio(...)` | `AspectRatio` | 固定比例 |

### 13.3 常用组件

| Compose | Flutter | 说明 |
|---------|---------|------|
| `Text` | `Text` | 文本 |
| `Image(painterResource(...))` | `Image.asset(...)` | 本地图片 |
| `AsyncImage(...)` / `Image(...)` | `Image.network(...)` / `CachedNetworkImage` | 网络图片 |
| `Icon` | `Icon` | 图标 |
| `Button` | `FilledButton` / `ElevatedButton` | Material 3 主按钮 |
| `OutlinedButton` | `OutlinedButton` | 描边按钮 |
| `TextButton` | `TextButton` | 文字按钮 |
| `TextField` / `OutlinedTextField` | `TextField` / `TextFormField` | 输入框 |
| `Checkbox` | `Checkbox` | 复选框 |
| `RadioButton` | `Radio` | 单选框 |
| `Switch` | `Switch` | 开关 |
| `Card` | `Card` | 卡片 |
| `Divider` | `Divider` | 分隔线 |
| `CircularProgressIndicator` | `CircularProgressIndicator` | 圆形加载 |
| `LinearProgressIndicator` | `LinearProgressIndicator` | 线形加载 |
| `Scaffold` | `Scaffold` | 页面骨架 |
| `Snackbar` | `ScaffoldMessenger.of(context).showSnackBar(...)` | 底部提示 |
| `AlertDialog` | `showDialog(...) + AlertDialog(...)` | 弹窗 |
| `ModalBottomSheet` | `showModalBottomSheet(...)` | 底部弹层 |

### 13.4 状态与导航速查

| Compose | Flutter | 说明 |
|---------|---------|------|
| `remember {}` | `StatefulWidget` 中的状态字段 | 保存页面内状态 |
| `mutableStateOf()` | `setState` | 最基础本地状态更新 |
| `LaunchedEffect` | `initState()` / `WidgetsBinding.instance.addPostFrameCallback` | 初始化副作用 |
| `DisposableEffect` | `dispose()` | 资源释放 |
| `collectAsState()` | `StreamBuilder` / `ValueListenableBuilder` / `ref.watch(...)` | 订阅状态 |
| `NavController.navigate()` | `Navigator.push(...)` / `context.push(...)` | 页面跳转 |
| `popBackStack()` | `Navigator.pop(...)` / `context.pop()` | 返回上一页 |

### 13.5 常见代码片段

**Compose：**
```kotlin
Row {
    A(Modifier.weight(1f))
    B(Modifier.weight(1f))
}
```

**Flutter：**
```dart
Row(
  children: [
    Expanded(child: A()),
    Expanded(child: B()),
  ],
)
```

**Compose：**
```kotlin
Modifier
    .fillMaxWidth()
    .padding(16.dp)
```

**Flutter：**
```dart
Padding(
  padding: const EdgeInsets.all(16),
  child: SizedBox(
    width: double.infinity,
    child: YourWidget(),
  ),
)
```

---

## 14. Compose Modifier → Flutter 写法对照表

> Compose 常把布局、样式、交互串在一条 `Modifier` 链里；Flutter 更常见的写法是通过外层 Widget 一层层包裹。

| Compose Modifier | Flutter 常用写法 | 说明 |
|------------------|------------------|------|
| `Modifier.padding(16.dp)` | `Padding(padding: EdgeInsets.all(16))` | 内边距 |
| `Modifier.padding(horizontal = 16.dp)` | `Padding(padding: EdgeInsets.symmetric(horizontal: 16))` | 对称内边距 |
| `Modifier.size(48.dp)` | `SizedBox(width: 48, height: 48)` | 固定宽高 |
| `Modifier.width(120.dp)` | `SizedBox(width: 120)` | 固定宽度 |
| `Modifier.height(56.dp)` | `SizedBox(height: 56)` | 固定高度 |
| `Modifier.fillMaxSize()` | `SizedBox.expand()` | 铺满父容器 |
| `Modifier.fillMaxWidth()` | `SizedBox(width: double.infinity)` | 铺满可用宽度 |
| `Modifier.fillMaxHeight()` | `SizedBox(height: double.infinity)` | 铺满可用高度 |
| `Modifier.weight(1f)` | `Expanded(flex: 1)` | 按比例占剩余空间 |
| `Modifier.background(Color.Red)` | `ColoredBox(color: Colors.red)` / `Container(color: Colors.red)` | 背景色 |
| `Modifier.background(color, shape = RoundedCornerShape(12.dp))` | `Container(decoration: BoxDecoration(color: ..., borderRadius: ...))` | 带圆角背景 |
| `Modifier.border(1.dp, Color.Gray)` | `Container(decoration: BoxDecoration(border: Border.all(...)))` | 边框 |
| `Modifier.clip(RoundedCornerShape(12.dp))` | `ClipRRect(borderRadius: BorderRadius.circular(12))` | 圆角裁切 |
| `Modifier.clip(CircleShape)` | `ClipOval(...)` / `CircleAvatar` | 圆形裁切 |
| `Modifier.clickable { ... }` | `InkWell(onTap: ...)` / `GestureDetector(onTap: ...)` | 点击事件 |
| `Modifier.alpha(0.5f)` | `Opacity(opacity: 0.5)` | 透明度 |
| `Modifier.align(Alignment.Center)` | `Align(alignment: Alignment.center)` / `Center` | 子组件对齐 |
| `Modifier.offset(x = 8.dp, y = 4.dp)` | `Transform.translate(offset: Offset(8, 4))` | 位移 |
| `Modifier.rotate(45f)` | `Transform.rotate(angle: math.pi / 4)` | 旋转 |
| `Modifier.scale(1.2f)` | `Transform.scale(scale: 1.2)` | 缩放 |
| `Modifier.aspectRatio(16f / 9f)` | `AspectRatio(aspectRatio: 16 / 9)` | 宽高比 |
| `Modifier.shadow(4.dp, RoundedCornerShape(12.dp))` | `Material(elevation: 4, borderRadius: ...)` / `Container(decoration: BoxDecoration(boxShadow: ...))` | 阴影 |
| `Modifier.verticalScroll(rememberScrollState())` | `SingleChildScrollView` | 普通滚动容器 |
| `Modifier.horizontalScroll(rememberScrollState())` | `SingleChildScrollView(scrollDirection: Axis.horizontal)` | 横向滚动 |
| `Modifier.safeDrawingPadding()` | `SafeArea` | 安全区域 |
| `Modifier.wrapContentSize(Alignment.Center)` | `Align(alignment: Alignment.center)` | 按内容包裹并对齐 |

### Modifier 使用习惯对照

| Compose 写法习惯 | Flutter 思路 |
|------------------|-------------|
| 一个组件后面接一串 `Modifier` | 外层连续包多个 Widget |
| 样式、布局、交互常写在同一处 | 布局、装饰、点击通常拆给不同 Widget |
| `Modifier` 顺序会影响最终效果 | Flutter 包裹顺序同样会影响效果 |

### 记忆法

- 要间距：先想 `SizedBox`
- 要内边距：先想 `Padding`
- 要对齐：先想 `Align` / `Center`
- 要平分：先想 `Expanded`
- 要叠层：先想 `Stack`
- 要列表：先想 `ListView.builder`
