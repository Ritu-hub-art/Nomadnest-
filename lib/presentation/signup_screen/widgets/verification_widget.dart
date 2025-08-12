import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../login_screen/widgets/custom_text_field.dart';

class VerificationWidget extends StatefulWidget {
  final TextEditingController verificationCodeController;
  final String email;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final Function(bool) onEmailVerified;
  final Function(bool) onPhoneVerified;
  final VoidCallback onComplete;

  const VerificationWidget({
    Key? key,
    required this.verificationCodeController,
    required this.email,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.onEmailVerified,
    required this.onPhoneVerified,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<VerificationWidget> createState() => _VerificationWidgetState();
}

class _VerificationWidgetState extends State<VerificationWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLoading = false;
  bool _codeSent = false;
  int _resendTimer = 60;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _sendVerificationCode();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _sendVerificationCode() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate sending code
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _codeSent = true;
    });

    Fluttertoast.showToast(
        msg: "Verification code sent to ${widget.email}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        textColor: Theme.of(context).colorScheme.onTertiary);

    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _resendTimer = 60;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendTimer--;
        });
        return _resendTimer > 0;
      }
      return false;
    });
  }

  Future<void> _verifyCode() async {
    final code = widget.verificationCodeController.text.trim();

    if (code.isEmpty || code.length != 6) {
      Fluttertoast.showToast(
          msg: "Please enter the 6-digit verification code",
          backgroundColor: Theme.of(context).colorScheme.error,
          textColor: Theme.of(context).colorScheme.onError);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate verification
    await Future.delayed(const Duration(seconds: 2));

    // Mock verification success for demo (in real app, validate against server)
    if (code == "123456" || code.length == 6) {
      widget.onEmailVerified(true);
      HapticFeedback.lightImpact();

      Fluttertoast.showToast(
          msg: "Email verified successfully!",
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          textColor: Theme.of(context).colorScheme.onTertiary);

      // Complete signup after verification
      await Future.delayed(const Duration(milliseconds: 1000));
      widget.onComplete();
    } else {
      Fluttertoast.showToast(
          msg: "Invalid verification code. Please try again.",
          backgroundColor: Theme.of(context).colorScheme.error,
          textColor: Theme.of(context).colorScheme.onError);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _skipVerification() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                title: Text('Skip Verification?',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600)),
                content: Text(
                    'You can verify your email later from your profile settings. However, verified accounts get better trust scores and more hosting opportunities.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(height: 1.4)),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant))),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onComplete();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary),
                      child: Text('Skip for Now',
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.onSecondary))),
                ]));
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 4.h),

                          // Verification icon
                          Container(
                              width: 20.w,
                              height: 20.w,
                              decoration: BoxDecoration(
                                  color: widget.isEmailVerified
                                      ? Theme.of(context)
                                          .colorScheme
                                          .tertiary
                                          .withValues(alpha: 0.1)
                                      : Theme.of(context)
                                          .colorScheme
                                          .secondary
                                          .withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: widget.isEmailVerified
                                          ? Theme.of(context)
                                              .colorScheme
                                              .tertiary
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                      width: 2)),
                              child: Icon(
                                  widget.isEmailVerified
                                      ? Icons.check_circle
                                      : Icons.email,
                                  size: 8.w,
                                  color: widget.isEmailVerified
                                      ? Theme.of(context).colorScheme.tertiary
                                      : Theme.of(context)
                                          .colorScheme
                                          .secondary)),

                          SizedBox(height: 4.h),

                          // Header
                          Text(
                              widget.isEmailVerified
                                  ? 'Email Verified!'
                                  : 'Verify Your Email',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface)),

                          SizedBox(height: 2.h),

                          if (!widget.isEmailVerified) ...[
                            RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                            height: 1.5),
                                    children: [
                                      const TextSpan(
                                          text:
                                              'We\'ve sent a 6-digit code to\n'),
                                      TextSpan(
                                          text: widget.email,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary)),
                                    ])),

                            SizedBox(height: 6.h),

                            // Code input field
                            CustomTextField(
                                label: 'Verification Code',
                                hint: 'Enter 6-digit code',
                                iconName: 'lock',
                                controller: widget.verificationCodeController,
                                keyboardType: TextInputType.number),

                            SizedBox(height: 4.h),

                            // Verify button
                            SizedBox(
                                width: double.infinity,
                                height: 6.h,
                                child: ElevatedButton(
                                    onPressed: _isLoading ? null : _verifyCode,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12))),
                                    child: _isLoading
                                        ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<Color>(
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary)))
                                        : Text('Verify Email',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                                    fontWeight: FontWeight.w600)))),

                            SizedBox(height: 3.h),

                            // Resend code button
                            TextButton(
                                onPressed: _resendTimer > 0
                                    ? null
                                    : _sendVerificationCode,
                                child: Text(
                                    _resendTimer > 0
                                        ? 'Resend code in ${_resendTimer}s'
                                        : 'Resend verification code',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            color: _resendTimer > 0
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                            fontWeight: FontWeight.w500))),

                            SizedBox(height: 4.h),

                            // Skip verification link
                            TextButton(
                                onPressed: _skipVerification,
                                child: Text('Skip for now',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                            decoration:
                                                TextDecoration.underline))),
                          ] else ...[
                            // Verified state
                            Text(
                                'Great! Your email has been verified.\nYou\'re ready to start exploring NomadNest.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                        height: 1.6)),

                            SizedBox(height: 6.h),

                            // Benefits section
                            Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary
                                            .withValues(alpha: 0.3),
                                        width: 1)),
                                child: Column(children: [
                                  Icon(Icons.verified_user,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      size: 6.w),
                                  SizedBox(height: 2.h),
                                  Text('Verified Account Benefits',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface)),
                                  SizedBox(height: 1.h),
                                  Text(
                                      '• Higher trust score\n• More hosting opportunities\n• Priority in search results\n• Access to premium features',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                              height: 1.4)),
                                ])),

                            SizedBox(height: 6.h),

                            // Start exploring button
                            SizedBox(
                                width: double.infinity,
                                height: 6.h,
                                child: ElevatedButton(
                                    onPressed: widget.onComplete,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12))),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.explore,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onTertiary),
                                          SizedBox(width: 2.w),
                                          Text('Start Exploring',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onTertiary,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                        ]))),
                          ],

                          SizedBox(height: 4.h),

                          // Help text
                          Text('Need help? Contact our support team',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant)),

                          SizedBox(height: 2.h),
                        ])))));
  }
}
