import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';

class SignupSuccessWidget extends StatefulWidget {
  final String userEmail;
  final String userName;
  final VoidCallback onGetStarted;

  const SignupSuccessWidget({
    super.key,
    required this.userEmail,
    required this.userName,
    required this.onGetStarted,
  });

  @override
  State<SignupSuccessWidget> createState() => _SignupSuccessWidgetState();
}

class _SignupSuccessWidgetState extends State<SignupSuccessWidget>
    with TickerProviderStateMixin {
  late AnimationController _successController;
  late AnimationController _badgeController;
  late Animation<double> _successAnimation;
  late Animation<double> _badgeAnimation;

  @override
  void initState() {
    super.initState();

    _successController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _badgeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _successAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
    );

    _badgeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _badgeController, curve: Curves.bounceOut),
    );

    // Start animations
    _successController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _badgeController.forward();
    });
  }

  @override
  void dispose() {
    _successController.dispose();
    _badgeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Success animation
          AnimatedBuilder(
            animation: _successAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _successAnimation.value,
                child: Container(
                  width: 25.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'check_circle',
                      color: Colors.green.shade600,
                      size: 12.w,
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 4.h),

          Text(
            'Welcome to NomadNest!',
            style: GoogleFonts.inter(
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          Text(
            'Hi ${widget.userName}, your account has been created successfully!',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4.h),

          // Email verified badge
          AnimatedBuilder(
            animation: _badgeAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _badgeAnimation.value,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.green.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'verified',
                        color: Colors.green.shade600,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Email Verified',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 1.h),

          Text(
            widget.userEmail,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 6.h),

          // Feature highlights
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'You\'re all set to:',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                ...[
                  {
                    'icon': 'explore',
                    'text': 'Discover amazing hosts worldwide'
                  },
                  {'icon': 'people', 'text': 'Connect with fellow nomads'},
                  {'icon': 'event', 'text': 'Join local hangouts and events'},
                  {
                    'icon': 'security',
                    'text': 'Travel safely with our safety features'
                  },
                ].map((feature) => Padding(
                      padding: EdgeInsets.only(bottom: 1.5.h),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: feature['icon']!,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              feature['text']!,
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),

          SizedBox(height: 6.h),

          // Get started button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                widget.onGetStarted();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Start Exploring',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
