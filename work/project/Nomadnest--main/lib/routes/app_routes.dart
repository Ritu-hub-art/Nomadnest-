import 'package:flutter/material.dart';

import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/signup_screen/signup_screen.dart';
import '../presentation/email_signup_flow/email_signup_flow.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/profile_settings/profile_settings.dart';
import '../presentation/hangouts_list/hangouts_list.dart';
import '../presentation/hangout_detail/hangout_detail.dart';
import '../presentation/host_profile_detail/host_profile_detail.dart';
import '../presentation/messaging_interface/messaging_interface.dart';
import '../presentation/safety_companion/safety_companion.dart';
import '../presentation/city_guide_detail/city_guide_detail.dart';
import '../presentation/interactive_map/interactive_map.dart';
import '../presentation/safety_settings/safety_settings.dart';
import '../presentation/account_management/account_management.dart';
import '../presentation/privacy_controls_settings/privacy_controls_settings.dart';
import '../presentation/notification_settings/notification_settings.dart';
import '../presentation/live_location_sharing_hub/live_location_sharing_hub.dart';
import '../presentation/interactive_hangout_map/interactive_hangout_map.dart';
import '../presentation/venue_picker_navigation/venue_picker_navigation.dart';
import '../widgets/diagnostics_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String emailSignupFlow = '/email-signup-flow';
  static const String homeDashboard = '/home-dashboard';
  static const String userProfile = '/user-profile';
  static const String profileSettings = '/profile-settings';
  static const String hangoutsList = '/hangouts-list';
  static const String hangoutDetail = '/hangout-detail';
  static const String hostProfileDetail = '/host-profile-detail';
  static const String messagingInterface = '/messaging-interface';
  static const String safetyCompanion = '/safety-companion';
  static const String cityGuideDetail = '/city-guide-detail';
  static const String interactiveMap = '/interactive-map';
  static const String safetySettings = '/safety-settings';
  static const String accountManagement = '/account-management';
  static const String privacyControlsSettings = '/privacy-controls-settings';
  static const String notificationSettings = '/notification-settings';
  static const String liveLocationSharingHub = '/live-location-sharing-hub';
  static const String interactiveHangoutMap = '/interactive-hangout-map';
  static const String venuePickerNavigation = '/venue-picker-navigation';
  static const String diagnostics = '/diagnostics';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingFlow(),
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
    emailSignupFlow: (context) => const EmailSignupFlow(),
    homeDashboard: (context) => const HomeDashboard(),
    userProfile: (context) => const UserProfile(),
    profileSettings: (context) => const ProfileSettings(),
    hangoutsList: (context) => const HangoutsList(),
    hangoutDetail: (context) => const HangoutDetail(),
    hostProfileDetail: (context) => const HostProfileDetail(),
    messagingInterface: (context) => const MessagingInterface(),
    safetyCompanion: (context) => const SafetyCompanion(),
    cityGuideDetail: (context) => const CityGuideDetail(),
    interactiveMap: (context) => const InteractiveMap(),
    safetySettings: (context) => const SafetySettings(),
    accountManagement: (context) => const AccountManagement(),
    privacyControlsSettings: (context) => const PrivacyControlsSettings(),
    notificationSettings: (context) => const NotificationSettings(),
    liveLocationSharingHub: (context) => const LiveLocationSharingHub(),
    interactiveHangoutMap: (context) => const InteractiveHangoutMap(),
    venuePickerNavigation: (context) => const VenuePickerNavigation(),
    diagnostics: (context) => const DiagnosticsScreen(),
  };
}
