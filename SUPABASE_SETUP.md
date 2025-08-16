# Supabase Email Verification Setup Guide

## Overview

This Flutter app now supports Supabase email verification with PKCE authentication flow and native deep links for both Android and iOS platforms.

## Environment Setup

### 1. Create Environment File

Copy `.env.example` to `.env` and fill in your actual Supabase credentials:

```bash
cp .env.example .env
```

Update `.env` with your values:

```env
# Get these from your Supabase Dashboard > Settings > API
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here

# Deep link scheme (matches Android applicationId)
APP_SCHEME=com.nomadnest.app
```

> ⚠️ **Never commit your `.env` file to version control.** It's already excluded in `.gitignore`.

### 2. Supabase Dashboard Configuration

In your Supabase Dashboard, configure the redirect URLs for email verification:

1. Go to **Authentication > Settings**
2. In **Site URL**, add your production domain (if any)
3. In **Redirect URLs**, add these entries:
   - `com.nomadnest.app://auth/verify` (for mobile deep links)
   - `http://localhost:3000/auth/verify` (for local web development)
   - Your production web URL if applicable

## Deep Link Configuration

### Android
- **Application ID**: `com.nomadnest.app`
- **Intent Filter**: Already configured in `android/app/src/main/AndroidManifest.xml`
- **Auto-verification**: Enabled for better user experience

### iOS  
- **Bundle Identifier**: `com.nomadnest.app.testProject`
- **URL Scheme**: `com.nomadnest.app` (configured in `ios/Runner/Info.plist`)
- **Custom URL Handler**: Ready for email verification links

## Implementation Details

### Key Features

1. **PKCE Authentication Flow**: Enhanced security for OAuth flows
2. **Auto Token Refresh**: Seamless session management
3. **Session Persistence**: Users stay logged in across app restarts
4. **Deep Link Support**: Email verification links open the app directly

### Code Structure

- `lib/supabase_client.dart`: Main Supabase configuration with PKCE
- `lib/auth/auth_service.dart`: Authentication methods with deep link support
- `lib/screens/example_sign_up_screen.dart`: Example implementation
- `lib/services/environment_service.dart`: Environment variable management

## Usage Example

```dart
import 'package:your_app/auth/auth_service.dart';
import 'package:your_app/supabase_client.dart';

// Sign up with automatic email verification deep link
await AuthService.signUp(
  email: 'user@example.com',
  password: 'securepassword123',
);

// Check if user is signed in
final user = supabase.auth.currentUser;

// Listen to auth state changes
supabase.auth.onAuthStateChange.listen((data) {
  final session = data.session;
  final user = session?.user;
  
  if (user != null) {
    print('User signed in: ${user.email}');
    print('Email verified: ${user.emailConfirmedAt != null}');
  }
});
```

## Testing Email Verification

### 1. Development Testing

1. Use a real email address you can access
2. Run the app and create an account
3. Check your email for the verification link
4. Click the link - it should open your app
5. The user should be automatically signed in

### 2. Deep Link Testing

Test deep links manually:
```bash
# Android (using ADB)
adb shell am start \
  -W -a android.intent.action.VIEW \
  -d "com.nomadnest.app://auth/verify?token=test" \
  com.nomadnest.app

# iOS (using Simulator)
xcrun simctl openurl booted "com.nomadnest.app://auth/verify?token=test"
```

## Troubleshooting

### Common Issues

1. **"Invalid redirect URL"**: Make sure your redirect URLs are configured in Supabase Dashboard
2. **Deep link not opening app**: Verify URL schemes in AndroidManifest.xml and Info.plist
3. **Environment variables not found**: Ensure `.env` file exists and contains required keys
4. **PKCE errors**: Check that your Supabase project supports PKCE (it should by default)

### Debug Tips

- Enable debug mode to see Supabase logs:
  ```dart
  await Supabase.initialize(
    // ... other config
    debug: kDebugMode,
  );
  ```
- Check auth state changes:
  ```dart
  supabase.auth.onAuthStateChange.listen((data) {
    print('Auth state changed: ${data.event}');
  });
  ```

## Security Considerations

1. **Never commit secrets**: Use `.env` files that are gitignored
2. **Validate redirect URLs**: Only allow trusted domains in Supabase Dashboard
3. **Use HTTPS in production**: Ensure all redirect URLs use HTTPS
4. **Monitor auth events**: Set up logging for authentication events

## Migration from env.json

This setup maintains backward compatibility with the existing `env.json` file while preferring `.env` files:

1. If `.env` exists, it will be used
2. If `.env` doesn't exist, falls back to `env.json`
3. Both support the same Supabase configuration

To migrate:
1. Create `.env` file with same values as `env.json`
2. Test the app works correctly
3. Remove `env.json` (optional, but recommended for security)

## Additional Resources

- [Supabase Auth Documentation](https://supabase.com/docs/guides/auth)
- [Flutter Deep Links Guide](https://docs.flutter.dev/development/ui/navigation/deep-linking)
- [PKCE Authentication Flow](https://supabase.com/docs/guides/auth/auth-helpers/auth-ui#pkce-authentication-flow)

## TODO Comments in Code

- Review iOS bundle identifier in production (currently uses `com.nomadnest.app.testProject`)
- Consider using different schemes for development vs production environments
- Add analytics tracking for auth events if needed