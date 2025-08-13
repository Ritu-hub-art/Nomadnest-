NomadNest Auth Pack (Flutter + Firebase Email/Password with verification)
-----------------------------------------------------------------------
Files go under your project's lib/ folder. Also run:
  flutter pub add firebase_core firebase_auth cloud_firestore url_launcher
  flutterfire configure   # generates lib/firebase_options.dart

Routes:
  Splash -> AuthGateway -> (Signup -> VerifyEmail -> ProfileSetup) or Login -> Home

NOTE: firebase_options.dart is not included. Generate it with `flutterfire configure`.
