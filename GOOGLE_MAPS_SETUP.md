# Google Maps Setup Guide

This guide explains how to configure Google Maps for Android in the NomadNest Flutter app safely, without committing API keys to version control.

## 📋 Prerequisites

- Google Cloud Console account
- Google Maps SDK for Android enabled
- An API key with Maps SDK restrictions

## 🔑 Step 1: Get Google Maps API Key

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the **Maps SDK for Android** API
4. Go to **Credentials** → **Create Credentials** → **API Key**
5. Click on your API key to configure restrictions:
   - **Application restrictions**: Select "Android apps"
   - **API restrictions**: Select "Restrict key" and choose "Maps SDK for Android"
6. Copy your API key (starts with `AIza...`)

## 🏠 Step 2: Local Development Setup

### Option A: Using gradle.properties (Recommended)

1. Copy the example file:
   ```bash
   cp android/gradle.properties.example android/gradle.properties
   cp work/project/Nomadnest--main/android/gradle.properties.example work/project/Nomadnest--main/android/gradle.properties
   ```

2. Edit `android/gradle.properties` and add your API key:
   ```properties
   MAPS_API_KEY=AIza_your_actual_api_key_here
   ```

3. Do the same for `work/project/Nomadnest--main/android/gradle.properties`

### Option B: Using Environment Variables

Set the environment variable in your shell:

```bash
# Linux/macOS
export MAPS_API_KEY="AIza_your_actual_api_key_here"

# Windows Command Prompt
set MAPS_API_KEY=AIza_your_actual_api_key_here

# Windows PowerShell
$env:MAPS_API_KEY="AIza_your_actual_api_key_here"
```

### Option C: Using Flutter env.json

1. Update `env.json` files:
   ```json
   {
     "MAPS_API_KEY": "AIza_your_actual_api_key_here"
   }
   ```

**⚠️ Warning**: This method stores the key in the Flutter app bundle. Use only for testing, not production.

## 🚀 Step 3: CI/CD Setup

### GitHub Actions

Add the API key as a repository secret:

1. Go to your repository → **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Name: `MAPS_API_KEY`
4. Value: Your Google Maps API key

In your workflow file:
```yaml
- name: Build APK
  env:
    MAPS_API_KEY: ${{ secrets.MAPS_API_KEY }}
  run: flutter build apk --release
```

### Other CI Platforms

- **GitLab CI**: Use GitLab Variables
- **Bitbucket**: Use Repository Variables
- **Jenkins**: Use Environment Variables in build configuration

## 🔒 Security Best Practices

1. **Never commit API keys** to version control
2. **Use API restrictions** in Google Cloud Console:
   - Restrict to your app's package name (`com.nomadnest.app`)
   - Restrict to Maps SDK for Android only
3. **Rotate keys regularly** for production apps
4. **Use different keys** for development and production
5. **Monitor API usage** in Google Cloud Console

## 🧪 Testing the Setup

1. Run the app:
   ```bash
   flutter run
   ```

2. Navigate to any screen with Google Maps
3. Check that maps load properly without API key errors
4. Check console logs for successful Maps API configuration

## 📱 Supported Features

The following location and mapping features are now enabled:

- ✅ Google Maps rendering
- ✅ Current location display
- ✅ Location permissions (fine and coarse)
- ✅ Interactive map controls
- ✅ Marker placement and clustering
- ✅ Live location sharing
- ✅ Venue search and navigation

## 🐛 Troubleshooting

### Common Issues

**Maps not loading / Gray screen:**
- Check that your API key is correct
- Verify API key restrictions in Google Cloud Console
- Ensure Maps SDK for Android is enabled

**Build errors:**
- Verify `gradle.properties` exists and contains the API key
- Check that `MAPS_API_KEY` environment variable is set
- Clean and rebuild: `flutter clean && flutter pub get`

**Permission errors:**
- Location permissions are automatically added to AndroidManifest.xml
- Users will be prompted for permissions at runtime

### Debug Steps

1. Check the API key configuration:
   ```bash
   # Verify environment variable
   echo $MAPS_API_KEY
   
   # Check gradle.properties
   cat android/gradle.properties
   ```

2. Enable verbose logging to see API key injection:
   ```bash
   flutter build apk --verbose
   ```

3. Check Android logs:
   ```bash
   flutter logs
   ```

Look for messages like:
- `Maps API Key configured: true` (success)
- `Google Maps API initialization failed` (key issue)

## 📚 Additional Resources

- [Google Maps Flutter Plugin Documentation](https://pub.dev/packages/google_maps_flutter)
- [Google Cloud Console](https://console.cloud.google.com/)
- [Maps SDK for Android Documentation](https://developers.google.com/maps/documentation/android-sdk)

## 🔄 Updating API Keys

To update your API key:

1. Update in Google Cloud Console if needed
2. Update local `gradle.properties` files
3. Update CI/CD environment variables
4. Rebuild the app: `flutter clean && flutter build apk`

---

For additional support, check the project's main README.md or create an issue on GitHub.