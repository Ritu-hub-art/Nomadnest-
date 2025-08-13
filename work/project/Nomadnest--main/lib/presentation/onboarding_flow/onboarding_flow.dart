import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/logo_widget.dart';
import './widgets/onboarding_bottom_widget.dart';
import './widgets/onboarding_page_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State&lt;OnboardingFlow&gt; createState() =&gt; _OnboardingFlowState();
}

class _OnboardingFlowState extends State&lt;OnboardingFlow&gt;
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _heroAnimationController;
  Timer? _autoAdvanceTimer;
  int _currentPage = 0;
  static const int _totalPages = 4;
  static const Duration _autoAdvanceDuration = Duration(seconds: 6);

  // Enhanced onboarding data with modern value proposition
  final List&lt;Map&lt;String, dynamic&gt;&gt; _onboardingData = [
    {
      "title": "Find Safe Stays",
      "subtitle": "Free accommodation",
      "description":
          "Connect with verified hosts offering free stays. Every host is background-checked with safety ratings and reviews from fellow travelers.",
      "imageUrl":
          "https://images.unsplash.com/photo-1564013799919-ab600027ffc6?fm=jpg&amp;q=80&amp;w=1000&amp;ixlib=rb-4.0.3",
      "iconName": "verified_user",
      "features": ["Verified hosts", "Safety ratings", "Real reviews"],
    },
    {
      "title": "Meet Locals",
      "subtitle": "Real connections",
      "description":
          "Join spontaneous meetups and activities. Connect with like-minded travelers and locals for authentic cultural experiences.",
      "imageUrl":
          "https://images.pexels.com/photos/1267320/pexels-photo-1267320.jpeg?auto=compress&amp;cs=tinysrgb&amp;w=1000",
      "iconName": "group",
      "features": ["Live meetups", "Local guides", "Authentic experiences"],
    },
    {
      "title": "Host Travelers",
      "subtitle": "Share your space",
      "description":
          "Open your home to fellow travelers and build meaningful connections. Set your own rules and availability.",
      "imageUrl":
          "https://images.pixabay.com/photo/2017/12/10/17/40/prague-3010407_1280.jpg",
      "iconName": "home",
      "features": ["Your rules", "Flexible hosting", "Global community"],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heroAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _heroAnimationController.forward();
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _pageController.dispose();
    _animationController.dispose();
    _heroAnimationController.dispose();
    super.dispose();
  }

  void _startAutoAdvanceTimer() {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = Timer(_autoAdvanceDuration, () {
      if (_currentPage &lt; _totalPages - 1) {
        _nextPage();
      }
    });
  }

  void _stopAutoAdvanceTimer() {
    _autoAdvanceTimer?.cancel();
  }

  void _nextPage() {
    if (_currentPage &lt; _totalPages - 1) {
      _stopAutoAdvanceTimer();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _provideFeedback();
    }
  }

  void _previousPage() {
    if (_currentPage &gt; 0) {
      _stopAutoAdvanceTimer();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _provideFeedback();
    }
  }

  void _skipToEnd() {
    _stopAutoAdvanceTimer();
    _pageController.animateToPage(
      _totalPages - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    _provideFeedback();
  }

  void _navigateToSignup() {
    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, '/signup');
  }

  void _navigateToLogin() {
    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _provideFeedback() {
    HapticFeedback.lightImpact();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });

    if (page &lt; _totalPages - 1) {
      _startAutoAdvanceTimer();
    } else {
      _stopAutoAdvanceTimer();
    }
  }

  // UPDATED: Pure white background and a truly centered logo on the first page
  Widget _buildWelcomeScreen() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Centered logo
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 1000),
                tween: Tween&lt;double&gt;(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.9 + (0.1 * value),
                    child: Opacity(
                      opacity: value,
                      child: LogoWidget(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: null,
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 3.h),

              // Tagline in brand blue color
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 1200),
                tween: Tween&lt;double&gt;(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: Text(
                        'Hosting the World, One Nest at a Time',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1B365D), // Navy blue
                          letterSpacing: -0.5,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 6.h),

              // Primary CTA - Get Started (blue background, white text)
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 1500),
                tween: Tween&lt;double&gt;(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: SizedBox(
                        width: double.infinity,
                        height: 6.5.h,
                        child: ElevatedButton(
                          onPressed: _navigateToSignup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B365D),
                            foregroundColor: Colors.white,
                            elevation: 6,
                            shadowColor: const Color(0xFF1B365D).withAlpha(77),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Get Started',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Secondary CTA - Log In (outlined button)
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 1700),
                tween: Tween&lt;double&gt;(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: SizedBox(
                        width: double.infinity,
                        height: 6.h,
                        child: OutlinedButton(
                          onPressed: _navigateToLogin,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1B365D),
                            side: const BorderSide(
                              color: Color(0xFF1B365D),
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Log In',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: GestureDetector(
        onTap: _stopAutoAdvanceTimer,
        child: Column(
          children: [
            // Main content area
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _totalPages,
                itemBuilder: (context, index) {
                  // First page is the welcome screen with logo
                  if (index == 0) {
                    return _buildWelcomeScreen();
                  } else if (index &lt;= _onboardingData.length) {
                    final data = _onboardingData[index - 1];
                    return OnboardingPageWidget(
                      title: data["title"] as String,
                      subtitle: data["subtitle"] as String,
                      description: data["description"] as String,
                      imageUrl: data["imageUrl"] as String,
                      iconName: data["iconName"] as String,
                      features: List&lt;String&gt;.from(data["features"]),
                      isLastPage: false,
                    );
                  } else {
                    // Final call-to-action page
                    return OnboardingPageWidget(
                      title: "Ready to Explore?",
                      subtitle: "Join thousands of travelers",
                      description:
                          "Start your journey with a global community of hosts and travelers. Sign up in seconds with Apple, Google, or Email.",
                      imageUrl:
                          "https://images.unsplash.com/photo-1488646953014-85cb44e25828?fm=jpg&amp;q=80&amp;w=1000&amp;ixlib=rb-4.0.3",
                      iconName: "explore",
                      features: [
                        "5-second signup",
                        "Instant verification",
                        "Global community"
                      ],
                      isLastPage: true,
                    );
                  }
                },
              ),
            ),

            // Bottom navigation area - only show for non-welcome pages
            if (_currentPage &gt; 0)
              OnboardingBottomWidget(
                currentPage: _currentPage,
                totalPages: _totalPages,
                onNext: _nextPage,
                onSkip: _skipToEnd,
                onGetStarted: _navigateToSignup,
                onSignIn: _navigateToLogin,
              ),
          ],
        ),
      ),
    );
  }
}