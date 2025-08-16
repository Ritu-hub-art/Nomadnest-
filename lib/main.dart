import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import './services/connectivity_service.dart';
import './services/environment_service.dart';
import './services/supabase_service.dart';
import './supabase_client.dart';
import 'core/app_export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize environment configuration first
    await EnvironmentService.initialize();

    // Initialize Supabase with PKCE authentication flow
    await initSupabase();

    // Initialize connectivity service
    await ConnectivityService().initialize();

    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } catch (error) {
    if (kDebugMode) {
      print('❌ Initialization error: $error');
    }
    // Continue with app launch even if some services fail to initialize
  }

  runApp(const NomadNestApp());
}

class NomadNestApp extends StatelessWidget {
  const NomadNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: MaterialApp(
            title: 'NomadNest',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
          ),
        );
      },
    );
  }
}