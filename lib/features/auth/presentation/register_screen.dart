import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wanandroid/core/router/app_routes.dart';
import 'package:flutter_wanandroid/features/auth/presentation/auth_notifier.dart';
import 'package:flutter_wanandroid/features/auth/presentation/auth_state.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  static const _primaryColor = Color(0xFF2196F3);
  static const _secondaryTextColor = Color(0x8A000000);
  static const _fieldBackgroundColor = Color(0xFFF5F5F5);
  static const _agreementUrl =
      'https://rule.tencent.com/rule/46a15f24-e42c-4cb6-a308-2347139b1201';

  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isAgreementSelected = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController()..addListener(_refreshInput);
    _passwordController = TextEditingController()..addListener(_refreshInput);
    _confirmPasswordController = TextEditingController()
      ..addListener(_refreshInput);
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () => _showPolicy('服务协议');
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () => _showPolicy('隐私政策');
  }

  @override
  void dispose() {
    _usernameController.removeListener(_refreshInput);
    _passwordController.removeListener(_refreshInput);
    _confirmPasswordController.removeListener(_refreshInput);
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  void _refreshInput() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (previous, next) {
      final previousMessage = previous?.errorMessage;
      final nextMessage = next.errorMessage;
      if (nextMessage != null &&
          nextMessage != previousMessage &&
          context.mounted) {
        _showMessage(nextMessage);
      }
    });

    final authState = ref.watch(authNotifierProvider);
    final isBusy = authState.isBusy;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('注册'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  children: [
                    const SizedBox(height: 48),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x55000000),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/login_avatar.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    _RegisterInputField(
                      controller: _usernameController,
                      enabled: !isBusy,
                      hintText: '账号',
                      inputFormatters: [LengthLimitingTextInputFormatter(16)],
                      trailing: _TrailingIcon(
                        visible: _usernameController.text.isNotEmpty,
                        icon: Icons.cancel,
                        onTap: _usernameController.clear,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _RegisterInputField(
                      controller: _passwordController,
                      enabled: !isBusy,
                      hintText: '密码',
                      obscureText: _obscurePassword,
                      trailing: _TrailingIcon(
                        visible: _passwordController.text.isNotEmpty,
                        icon: _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        onTap: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    _RegisterInputField(
                      controller: _confirmPasswordController,
                      enabled: !isBusy,
                      hintText: '确认密码',
                      obscureText: _obscureConfirmPassword,
                      trailing: _TrailingIcon(
                        visible: _confirmPasswordController.text.isNotEmpty,
                        icon: _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        onTap: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isBusy ? null : _submitRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          disabledBackgroundColor: _primaryColor.withValues(
                            alpha: 0.55,
                          ),
                          foregroundColor: Colors.white,
                          disabledForegroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: isBusy
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('注册并登录'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _toggleAgreement,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            _isAgreementSelected
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: _isAgreementSelected
                                ? _primaryColor
                                : const Color(0xFF515151),
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: const TextStyle(
                                  color: _secondaryTextColor,
                                  fontSize: 14,
                                ),
                                children: [
                                  const TextSpan(text: '已阅读并同意'),
                                  TextSpan(
                                    text: '《服务协议》',
                                    style: const TextStyle(
                                      color: _primaryColor,
                                    ),
                                    recognizer: _termsRecognizer,
                                  ),
                                  const TextSpan(text: '与'),
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: isBusy
                            ? null
                            : () {
                                if (context.canPop()) {
                                  context.pop();
                                } else {
                                  context.go(AppRoutes.login);
                                }
                              },
                        style: TextButton.styleFrom(
                          foregroundColor: _primaryColor,
                          padding: const EdgeInsets.only(
                            left: 18,
                            top: 18,
                            bottom: 18,
                          ),
                          textStyle: const TextStyle(fontSize: 15),
                        ),
                        child: const Text('去登录'),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _toggleAgreement() {
    setState(() {
      _isAgreementSelected = !_isAgreementSelected;
    });
  }

  void _submitRegister() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty) {
      _showMessage('请填写账号');
      return;
    }

    if (password.isEmpty) {
      _showMessage('请填写密码');
      return;
    }

    if (confirmPassword.isEmpty) {
      _showMessage('请填写确认密码');
      return;
    }

    if (password.length < 6) {
      _showMessage('密码最少6位');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('密码不一致');
      return;
    }

    if (!_isAgreementSelected) {
      _showMessage('请阅读并勾选协议');
      return;
    }

    ref
        .read(authNotifierProvider.notifier)
        .register(
          username: username,
          password: password,
          confirmPassword: confirmPassword,
        );
  }

  void _showPolicy(String title) {
    _showMessage('$title\n$_agreementUrl');
  }

  void _showMessage(String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('提示'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }
}

class _RegisterInputField extends StatelessWidget {
  const _RegisterInputField({
    required this.controller,
    required this.hintText,
    required this.trailing,
    this.enabled = true,
    this.obscureText = false,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String hintText;
  final Widget trailing;
  final bool enabled;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: _RegisterScreenState._fieldBackgroundColor,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              obscureText: obscureText,
              inputFormatters: inputFormatters,
              maxLines: 1,
              style: const TextStyle(color: Colors.black, fontSize: 15),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                filled: false,
                hintText: hintText,
                counterText: '',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
          trailing,
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}

class _TrailingIcon extends StatelessWidget {
  const _TrailingIcon({
    required this.visible,
    required this.icon,
    required this.onTap,
  });

  final bool visible;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible,
      child: Opacity(
        opacity: visible ? 1 : 0,
        child: InkResponse(
          onTap: onTap,
          radius: 18,
          child: Icon(icon, size: 24, color: const Color(0xFF515151)),
        ),
      ),
    );
  }
}
