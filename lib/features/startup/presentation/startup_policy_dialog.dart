import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class StartupPolicyDialog extends StatefulWidget {
  const StartupPolicyDialog({
    super.key,
    required this.onAgree,
    required this.onDecline,
    required this.onOpenTerms,
    required this.onOpenPrivacy,
  });

  final VoidCallback onAgree;
  final VoidCallback onDecline;
  final VoidCallback onOpenTerms;
  final VoidCallback onOpenPrivacy;

  @override
  State<StartupPolicyDialog> createState() => _StartupPolicyDialogState();
}

class _StartupPolicyDialogState extends State<StartupPolicyDialog> {
  static const _titleColor = Color(0xDE000000);
  static const _contentColor = Color(0xFF666666);
  static const _primaryColor = Color(0xFF2196F3);
  static const _primaryTransparentColor = Color(0x8D2196F3);
  static const _secondaryTextColor = Color(0x8A000000);

  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()..onTap = widget.onOpenTerms;
    _privacyRecognizer = TapGestureRecognizer()..onTap = widget.onOpenPrivacy;
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '欢迎使用鸡你太美',
                style: TextStyle(
                  color: _titleColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: _contentColor,
                    fontSize: 13,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(
                      text:
                          '1.我们会遵循隐私政策收集、使用信息，但不会仅因同意本隐私政策而采用强制捆绑的方式收集信息;\n'
                          '2.在仅浏览时，为保障服务所必需，我们会收集设备信息与日志信息用于咨询推送\n'
                          '3.GPS、摄像头、相册权限均不会默认开，只有经过明示授权才会在为实现功能或服务时使用，不会在功能或服务不需要时而通过您授权的权限收集信息。\n\n'
                          '您可以查看完整版 ',
                    ),
                    TextSpan(
                      text: '《隐私政策》',
                      style: const TextStyle(color: _primaryColor),
                      recognizer: _privacyRecognizer,
                    ),
                    const TextSpan(text: ' 和 '),
                    TextSpan(
                      text: '《用户授权协议》',
                      style: const TextStyle(color: _primaryColor),
                      recognizer: _termsRecognizer,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [_primaryColor, _primaryTransparentColor],
                    ),
                  ),
                  child: TextButton(
                    onPressed: widget.onAgree,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '我已阅读并同意',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: widget.onDecline,
                style: TextButton.styleFrom(
                  foregroundColor: _secondaryTextColor,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('不同意', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
