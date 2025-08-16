# NomadNest - Digital Nomad Community Platform

## 🗺️ Google Maps Setup

This app includes live location features and interactive maps. To enable Google Maps on Android:

👉 **[Follow the Google Maps Setup Guide](../../../GOOGLE_MAPS_SETUP.md)** for detailed instructions on configuring API keys securely.

## 📧 Email Verification Setup

### Required Configuration

To enable email verification functionality, you need to configure the Resend API key:

#### Step 1: Get Resend API Key
1. Sign up at [resend.com](https://resend.com) (free tier: 3,000 emails/month)
2. Create an API key with sending permissions
3. Copy the API key (format: `re_xxxxxxxxxx`)

#### Step 2: Configure Environment Variables

**Option A: Update env.json (Recommended)**
```json
{
  "SUPABASE_URL": "your_supabase_url",
  "SUPABASE_ANON_KEY": "your_supabase_anon_key", 
  "RESEND_API_KEY": "re_your_actual_resend_api_key_here"
}
```

**Option B: Supabase Dashboard**
1. Go to your Supabase project dashboard
2. Settings → Edge Functions → Environment Variables
3. Add: `RESEND_API_KEY` = `re_your_actual_resend_api_key_here`

**Option C: Supabase CLI**
```bash
supabase secrets set RESEND_API_KEY=re_your_actual_resend_api_key_here
```

#### Step 3: Test Email Verification
1. Run the app and attempt to sign up
2. Check your email (including spam folder)
3. Enter the 6-digit verification code
4. Complete your profile setup

### Troubleshooting Email Issues

**Common Problems:**
- **"Email service not configured"** → Add RESEND_API_KEY to Supabase environment
- **"Authentication failed"** → Verify your Resend API key is correct
- **"Too many requests"** → Wait a moment and try again (rate limiting)

**Email Not Received:**
1. Check spam/junk folder
2. Verify email address is correct
3. Wait 2-5 minutes for delivery
4. Try resending the code
5. Check internet connection

### Email Features
- ✅ Professional welcome emails with NomadNest branding
- ✅ 6-digit verification codes with 10-minute expiry
- ✅ Mobile-responsive email templates
- ✅ Automatic code cleanup and security
- ✅ Rate limiting and error handling

## 🚀 Getting Started

### Prerequisites
- Flutter 3.6.0 or higher
- Dart 3.0 or higher
- Supabase account with project
- Resend account with API key

### Installation
```bash
# Clone the repository
git clone [repository-url]
cd nomadnest

# Install dependencies
flutter pub get

# Configure environment variables (see above)

# Run the app
flutter run
```

## 🔧 Development

### Environment Configuration
The app uses `env.json` for environment variables. Make sure to:
1. Never commit real API keys to version control
2. Use the provided template structure
3. Validate all required keys are present

### Database Schema
The app includes a complete Supabase schema with:
- User profiles and authentication
- Email verification system
- Role-based access control
- Real-time subscriptions

## 📱 Features

### Core Features
- 🔐 Secure authentication with email verification
- 👤 Complete user profile management
- 🌍 Interactive maps and location services
- 💬 Real-time messaging system
- 🛡️ Safety companion features
- 📱 Responsive design for all screen sizes

### Technical Features
- 📧 Production-ready email system
- 🔒 Row Level Security (RLS) policies
- 📊 Real-time data synchronization
- 🎨 Custom UI components
- 🌐 Cross-platform compatibility

## 📞 Support

If you encounter issues with email verification:
1. Check the troubleshooting section above
2. Verify your environment configuration
3. Check Supabase Edge Function logs
4. Review Resend dashboard for delivery status

---

Built with Flutter 💙 and Supabase ⚡