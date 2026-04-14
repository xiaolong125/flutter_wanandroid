import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wanandroid/core/router/app_routes.dart';
import 'package:flutter_wanandroid/features/auth/presentation/auth_notifier.dart';
import 'package:flutter_wanandroid/features/auth/presentation/auth_state.dart';
import 'package:go_router/go_router.dart';

/// 登录页面 - 用户账号登录界面
///
/// 功能特点：
/// - 用户名/密码输入框
/// - 密码显示/隐藏切换
/// - 用户头像显示
/// - 服务协议和隐私政策勾选
/// - 登录状态管理（加载中、错误提示）
/// - 输入框清空功能

/// 登录页面组件 - ConsumerStatefulWidget 版本
///
/// ConsumerStatefulWidget 的使用场景：
/// - 需要持有可变状态（如表单值）
/// - 需要响应状态变化（如密码显示/隐藏）
/// - 需要 dispose 资源（控制器、手势识别器等）
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

/// 登录页面的状态管理类
///
/// ConsumerState 模型：
/// - 与对应的 StatefulWidget 一一对应
/// - 负责管理组件的状态和生命周期
/// - 可以访问父组件传递的参数
class _LoginScreenState extends ConsumerState<LoginScreen> {
  // === 常量定义 ===
  static const _primaryColor = Color(0xFF2196F3); // 主色调 - Material Design 的蓝色
  static const _secondaryTextColor = Color(0x8A000000); // 次要文字颜色 - 半透黑色
  static const _fieldBackgroundColor = Color(0xFFF5F5F5); // 输入框背景色 - 浅灰色
  static const _agreementUrl =
      'https://rule.tencent.com/rule/46a15f24-e42c-4cb6-a308-2347139b1201'; // 协议URL

  // === 控制器和手势识别器 ===
  /// 用户名输入框控制器
  /// 用于管理输入框的文本内容和焦点
  late final TextEditingController _usernameController;

  /// 密码输入框控制器
  /// 用于管理密码文本内容
  late final TextEditingController _passwordController;

  /// 服务协议文本点击手势识别器
  /// 使文本"服务协议"可点击
  late final TapGestureRecognizer _termsRecognizer;

  /// 隐私政策文本点击手势识别器
  /// 使文本"隐私政策"可点击
  late final TapGestureRecognizer _privacyRecognizer;

  // === 本地状态变量 ===
  /// 控制密码是否显示/隐藏
  /// true=隐藏（显示圆点），false=显示明文
  bool _obscurePassword = true;

  /// 用户是否已勾选服务协议和隐私政策
  /// 未勾选时无法登录
  bool _isAgreementSelected = false;

  /// 组件初始化生命周期方法
  ///
  /// 执行顺序：先调用父类的 initState，再执行自己的初始化逻辑
  ///
  /// 初始化内容：
  /// 1. 创建输入框控制器并添加输入监听
  /// 2. 创建文本点击手势识别器
  /// 3. 设置点击回调函数
  @override
  void initState() {
    super.initState();

    // 创建用户名输入框控制器
    _usernameController = TextEditingController()
      ..addListener(_refreshInput); // 监听输入变化

    // 创建密码输入框控制器
    _passwordController = TextEditingController()
      ..addListener(_refreshInput); // 监听输入变化

    // 创建服务协议文本点击手势识别器
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () => _showPolicy('服务协议');

    // 创建隐私政策文本点击手势识别器
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () => _showPolicy('隐私政策');
  }

  /// 刷新输入状态
  ///
  /// 当输入框内容发生变化时调用，触发 UI 重新构建
  /// mounted 检查确保组件仍然处于活动状态
  void _refreshInput() {
    if (mounted) {
      setState(() {});
    }
  }

  /// 组件销毁生命周期方法
  ///
  /// 用于释放资源，防止内存泄漏：
  /// 1. 移除所有输入监听器
  /// 2. 释放手势识别器
  /// 3. 释放输入框控制器
  @override
  void dispose() {
    // 移除输入监听器，避免无效回调
    _usernameController.removeListener(_refreshInput);
    _passwordController.removeListener(_refreshInput);

    // 释放手势识别器，避免资源泄漏
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();

    // 释放输入框控制器，避免内存泄漏
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose(); // 最后调用父类的 dispose
  }

  /// 构建 UI 组件 - Flutter 的核心方法
  ///
  /// 每次状态变化时都会重新调用，用于构建 Widget 树
  ///
  /// 监听逻辑：
  /// 1. 使用 ref.listen 监听登录状态变化
  /// 2. 如果出现错误消息，自动弹窗提示
  /// 3. 使用 ref.watch 获取当前登录状态
  @override
  Widget build(BuildContext context) {
    // 监听登录状态变化，错误时自动显示提示
    // ref.listen 会在数据变化时触发回调函数
    ref.listen(authNotifierProvider, (previous, next) {
      final previousMessage = previous?.errorMessage;
      final nextMessage = next.errorMessage;

      // 如果有新的错误消息，且组件仍然挂载，显示提示
      if (nextMessage != null &&
          nextMessage != previousMessage &&
          context.mounted) {
        _showMessage(nextMessage);
      }
    });

    // 监听登录状态，获取当前是否正在处理中
    // ref.watch 会获取最新值并自动重建组件
    final authState = ref.watch(authNotifierProvider);
    final isBusy = authState.isBusy; // 是否正在加载

    // === 页面结构 ===
    return Scaffold(
      // Scaffold Flutter 应用的基本容器，提供 Material Design 布局结构
      backgroundColor: Colors.white,

      // 应用栏 - 页面顶部的标题栏
      appBar: AppBar(
        title: const Text('登录'), // 标题文本
        backgroundColor: _primaryColor, // 背景色
        foregroundColor: Colors.white, // 前景色（文字和图标颜色）
      ),

      // 页面主体内容
      body: SafeArea(
        top: false, // 顶部不保留安全区域（避免被刘海屏遮挡）
        child: SingleChildScrollView(
          // 可滚动容器，当内容超出屏幕时可以滚动
          child: Container(
            // 内边距，左右各 18 像素
            padding: const EdgeInsets.symmetric(horizontal: 18),
            alignment: Alignment.center,
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              // 垂直排列的列布局
              children: [
                // === 头像部分 ===
                const SizedBox(height: 48), // 顶部间距
                // 头像容器
                Container(
                  width: 100,
                  height: 100,
                  // 装饰属性：圆形形状 + 阴影
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle, // 圆形
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x55000000), // 半透明黑色阴影
                        blurRadius: 12, // 模糊程度
                        offset: Offset(0, 4), // 阴影偏移（向下4像素）
                      ),
                    ],
                  ),
                  // 圆形裁剪器，使图片显示为圆形
                  child: ClipOval(
                    child: Image.asset(
                      // 从 assets 加载头像图片
                      'assets/images/login_avatar.jpg',
                      fit: BoxFit.cover, // 保持比例并填充整个区域
                    ),
                  ),
                ),
                        
                // === 输入框部分 ===
                const SizedBox(height: 48), // 头像下方间距
                // 用户名输入框
                _LoginInputField(
                  controller: _usernameController,
                  enabled: !isBusy, // 登录中时禁用
                  hintText: '账号',
                  // 限制最多输入20个字符
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                  // 清空图标
                  trailing: _TrailingIcon(
                    visible: _usernameController.text.isNotEmpty,
                    icon: Icons.cancel,
                    onTap: _usernameController.clear,
                  ),
                ),
                        
                const SizedBox(height: 30), // 输入框间距
                // 密码输入框
                _LoginInputField(
                  controller: _passwordController,
                  enabled: !isBusy, // 登录中时禁用
                  hintText: '密码',
                  obscureText: _obscurePassword, // 是否隐藏密码
                  // 密码显示/隐藏切换图标
                  trailing: _TrailingIcon(
                    visible: _passwordController.text.isNotEmpty,
                    icon: _obscurePassword
                        ? Icons
                              .visibility_off // 隐藏图标
                        : Icons.visibility, // 显示图标
                    onTap: () {
                      // 点击时切换密码显示状态
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                        
                // === 登录按钮 ===
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity, // 宽度占满父容器
                  height: 48, // 固定高度
                  child: ElevatedButton(
                    // 登录中时禁用按钮
                    onPressed: isBusy ? null : _submitLogin,
                    // 按钮样式自定义
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor, // 背景色
                      disabledBackgroundColor: _primaryColor.withValues(
                        alpha: 0.55, // 禁用时透明度降低
                      ),
                      foregroundColor: Colors.white, // 文字颜色
                      disabledForegroundColor: Colors.white, // 禁用时的文字颜色
                      elevation: 0, // 阴影高度
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4), // 圆角4像素
                      ),
                      textStyle: const TextStyle(fontSize: 16), // 字体大小
                    ),
                    // 根据状态显示加载动画或登录文字
                    child: isBusy
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2, // 圆环粗细
                              color: Colors.white,
                            ),
                          )
                        : const Text('登录'),
                  ),
                ),
                        
                // === 协议勾选部分 ===
                const SizedBox(height: 20),
                GestureDetector(
                  // 手势检测器，使整个行可点击
                  behavior: HitTestBehavior.opaque, // 扩大点击区域
                  onTap: _toggleAgreement, // 点击回调
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 协议勾选图标
                      Icon(
                        _isAgreementSelected
                            ? Icons
                                  .check_circle // 选中：实心圆圈
                            : Icons.radio_button_unchecked, // 未选中：空心圆圈
                        color: _isAgreementSelected
                            ? _primaryColor // 选中时蓝色
                            : const Color(0xFF515151), // 未选中时灰色
                        size: 18,
                      ),
                      const SizedBox(width: 6), // 图标与文本间距
                      // 协议文本（使用 RichText 实现不同颜色和点击效果）
                      Expanded(
                        child: RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // 超出时省略
                          text: TextSpan(
                            // 默认文本样式
                            style: const TextStyle(
                              color: _secondaryTextColor,
                              fontSize: 14,
                            ),
                            // 文本内容片段
                            children: [
                              const TextSpan(text: '已阅读并同意'),
                              // 服务协议 - 可点击
                              TextSpan(
                                text: '《服务协议》',
                                style: const TextStyle(
                                  color: _primaryColor,
                                ),
                                recognizer: _termsRecognizer,
                              ),
                              const TextSpan(text: '与'),
                              // 隐私政策 - 可点击
                              TextSpan(
                                text: '《隐私政策》',
                                style: const TextStyle(
                                  color: _primaryColor,
                                ),
                                recognizer: _privacyRecognizer,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                        
                // === 注册链接 ===
                Align(
                  alignment: Alignment.centerRight, // 右对齐
                  child: TextButton(
                    onPressed: isBusy
                        ? null
                        : () => context.push(AppRoutes.register),
                    style: TextButton.styleFrom(
                      foregroundColor: _primaryColor, // 文字颜色
                      padding: const EdgeInsets.only(
                        left: 18,
                        top: 18,
                        bottom: 18,
                      ),
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                    child: const Text('去注册'),
                  ),
                ),
                        
                const SizedBox(height: 12), // 底部间距
              ],
            ),
          ),
        ),
      ),
    );
  }

  // === 事件处理方法 ===

  /// 切换协议勾选状态
  ///
  /// 点击协议文本时调用，切换选中/未选中状态
  void _toggleAgreement() {
    setState(() {
      _isAgreementSelected = !_isAgreementSelected;
    });
  }

  /// 提交登录
  ///
  /// 验证输入内容并触发登录流程：
  /// 1. 检查用户名是否为空
  /// 2. 检查密码是否为空
  /// 3. 检查是否勾选协议
  /// 4. 调用 AuthNotifier 的登录方法
  void _submitLogin() {
    final username = _usernameController.text.trim(); // 去除首尾空格
    final password = _passwordController.text.trim();

    // 验证用户名
    if (username.isEmpty) {
      _showMessage('请填写账号');
      return;
    }
    // 验证密码
    if (password.isEmpty) {
      _showMessage('请填写密码');
      return;
    }
    // 验证协议勾选
    if (!_isAgreementSelected) {
      _showMessage('请阅读并勾选协议');
      return;
    }

    // 获取 AuthNotifier 的实例并调用登录方法
    // 使用 ref.read 直接获取 notifer 实例（用于执行操作而非监听）
    ref
        .read(authNotifierProvider.notifier)
        .login(username: username, password: password);
  }

  /// 显示协议内容
  ///
  /// 点击协议文本时调用，显示协议标题和链接
  void _showPolicy(String title) {
    _showMessage('$title\n$_agreementUrl');
  }

  /// 显示消息弹窗
  ///
  /// 使用 AlertDialog 显示提示信息
  /// Flutter 中的对话框都是通过 showDialog 实现的
  void _showMessage(String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        // AlertDialog - Material Design 的标准对话框
        return AlertDialog(
          title: const Text('提示'), // 对话框标题
          content: Text(message), // 对话框内容
          actions: [
            // 对话框按钮
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }
}

// === 内部组件类 ===

/// 登录输入框组件 - 自定义样式的 TextField
///
/// StatelessWidget 的使用场景：
/// - 纯展示组件，没有自己的状态
/// - 根据输入参数渲染固定的 UI
/// - 可复用的简单组件
class _LoginInputField extends StatelessWidget {
  const _LoginInputField({
    required this.controller,
    required this.hintText,
    required this.trailing,
    this.enabled = true,
    this.obscureText = false,
    this.inputFormatters,
  });

  // === 参数说明 ===
  /// 输入框控制器
  final TextEditingController controller;

  /// 提示文本
  final String hintText;

  /// 尾部组件（如清空按钮、显示/隐藏按钮）
  final Widget trailing;

  /// 是否启用输入框
  final bool enabled;

  /// 是否隐藏输入内容（用于密码框）
  final bool obscureText;

  /// 输入格式化器（如限制长度）
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    // 使用 Container 作为输入框的容器，设置背景和圆角
    return Container(
      height: 48,
      // 装饰：背景色 + 圆角
      decoration: BoxDecoration(
        color: _LoginScreenState._fieldBackgroundColor,
        borderRadius: BorderRadius.circular(3),
      ),
      // 行布局：输入框 + 尾部组件
      child: Row(
        children: [
          // Expanded - 占据剩余空间
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              obscureText: obscureText,
              inputFormatters: inputFormatters,
              maxLines: 1,
              // 文字样式
              style: const TextStyle(color: Colors.black, fontSize: 15),
              // 输入框装饰
              decoration: InputDecoration(
                // 移除默认边框
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                filled: false,
                hintText: hintText,
                counterText: '', // 隐藏字符计数器
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
          // 尾部组件
          trailing,
          const SizedBox(width: 6), // 尾部组件与输入框的间距
        ],
      ),
    );
  }
}

/// 尾部图标按钮组件
///
/// 功能：
/// - 点击清空输入框
/// - 切换密码显示/隐藏
/// - 当输入为空时自动隐藏
class _TrailingIcon extends StatelessWidget {
  const _TrailingIcon({
    required this.visible,
    required this.icon,
    required this.onTap,
  });

  // === 参数说明 ===
  /// 是否显示图标
  final bool visible;

  /// 图标类型
  final IconData icon;

  /// 点击回调函数
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // IgnorePointer - 忽略触摸事件（当 visible=false 时）
    // Opacity - 控制透明度
    // InkResponse - 水波纹效果
    return IgnorePointer(
      ignoring: !visible, // 当 visible=false 时忽略触摸
      child: Opacity(
        opacity: visible ? 1 : 0, // 当 visible=false 时透明度为0
        child: InkResponse(
          onTap: onTap, // 点击回调
          radius: 18, // 点击区域半径
          child: Icon(icon, size: 24, color: const Color(0xFF515151)),
        ),
      ),
    );
  }
}
