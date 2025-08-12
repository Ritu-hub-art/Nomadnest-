import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';

class EmailVerificationWidget extends StatefulWidget {
  final String email;
  final TextEditingController verificationCodeController;
  final int resendCooldown;
  final VoidCallback onResendCode;
  final VoidCallback onCodeVerified;

  const EmailVerificationWidget({
    super.key,
    required this.email,
    required this.verificationCodeController,
    required this.resendCooldown,
    required this.onResendCode,
    required this.onCodeVerified,
  });

  @override
  State<EmailVerificationWidget> createState() =>
      _EmailVerificationWidgetState();
}

class _EmailVerificationWidgetState extends State<EmailVerificationWidget> {
  bool _isVerifying = false;
  List<TextEditingController> _codeControllers = [];
  List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    // Initialize 6 controllers for 6-digit code
    for (int i = 0; i < 6; i++) {
      _codeControllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged(String value, int index) {
    if (value.length == 1) {
      // Move to next field
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // All fields filled, attempt verification
        _verifyCode();
      }
    } else if (value.isEmpty) {
      // Move to previous field
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    // Update main controller
    String fullCode = _codeControllers.map((c) => c.text).join();
    widget.verificationCodeController.text = fullCode;
  }

  Future<void> _verifyCode() async {
    String code = _codeControllers.map((c) => c.text).join();

    if (code.length != 6) {
      Fluttertoast.showToast(
        msg: "Please enter the complete 6-digit code",
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
      );
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    // Simulate verification
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isVerifying = false;
      });

      // For demo purposes, accept any 6-digit code
      HapticFeedback.lightImpact();
      Fluttertoast.showToast(
        msg: "Email verified successfully!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      widget.onCodeVerified();
    }
  }

  void _resendCode() {
    if (widget.resendCooldown > 0) return;

    HapticFeedback.lightImpact();
    widget.onResendCode();

    Fluttertoast.showToast(
      msg: "Verification code sent to ${widget.email}",
      backgroundColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.onPrimary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          children: [
            SizedBox(height: 6.h),

            // Email verification icon
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'mark_email_read',
                  color: Theme.of(context).colorScheme.primary,
                  size: 10.w,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            Text(
              'Check your email',
              style: GoogleFonts.inter(
                fontSize: 28.sp,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),

            SizedBox(height: 2.h),

            Text(
              'We sent a verification code to',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            SizedBox(height: 0.5.h),

            Text(
              widget.email,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            SizedBox(height: 4.h),

            // Code input fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 12.w,
                  height: 6.h,
                  child: TextField(
                    controller: _codeControllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: GoogleFonts.inter(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.3),
                    ),
                    onChanged: (value) => _onCodeChanged(value, index),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                );
              }),
            ),

            SizedBox(height: 4.h),

            // Verify button
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: _isVerifying ? null : _verifyCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isVerifying
                    ? SizedBox(
                        width: 5.w,
                        height: 5.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Text(
                        'Verify Email',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            SizedBox(height: 3.h),

            // Resend code button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive the code? ",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                TextButton(
                  onPressed: widget.resendCooldown > 0 ? null : _resendCode,
                  child: Text(
                    widget.resendCooldown > 0
                        ? 'Resend in ${widget.resendCooldown}s'
                        : 'Resend',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: widget.resendCooldown > 0
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
