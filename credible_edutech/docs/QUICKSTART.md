# Quick Start Guide

Get CredibleEdutech running in **30 minutes**.

---

## 🚀 5-Step Setup

### Step 1: Clone & Install (5 min)

```bash
# Navigate to the project
cd credible_edutech/flutter_app

# Install dependencies
flutter pub get

# Generate code
flutter pub run build_runner build

# Verify
flutter doctor
```

### Step 2: Configure Supabase (10 min)

1. Go to [supabase.com](https://supabase.com) → Create Project
2. Copy Project URL & Anon Key
3. Update `lib/main.dart`:
   ```dart
   const String supabaseUrl = 'YOUR_PROJECT_URL';
   const String supabaseAnonKey = 'YOUR_ANON_KEY';
   ```
4. Open Supabase SQL Editor
5. Copy-paste entire `supabase_backend/schema.sql`
6. Execute → Creates all tables + RLS

### Step 3: Deploy Cloudflare Worker (10 min)

```bash
# Install wrangler
npm install -g wrangler

# Login
wrangler login

# Navigate to worker folder
cd ../cloudflare_worker

# Update wrangler.toml with your credentials
# (account_id, zone_id, Supabase URL/key, Google credentials)

# Deploy
wrangler deploy
```

### Step 4: Update Worker URL in App (2 min)

In `lib/features/video_player/presentation/bloc/video_player_bloc.dart`:
```dart
static const String _mediaVaultUrl = 'https://media-vault.economicqsmaster.com/proxy';
```

### Step 5: Run App (3 min)

```bash
flutter run

# Or on specific device
flutter run -d emulator  # Android
flutter run -d iphone   # iOS
```

---

## ✅ Verification Checklist

- [ ] App launches without errors
- [ ] Auth screen loads
- [ ] Can create account with email/password
- [ ] Courses dashboard loads
- [ ] Course cards visible
- [ ] Tap "Start" → Lecture view loads
- [ ] Video player appears
- [ ] GARCH calculator works

---

## 🧪 Test Credentials

```
Email:    test@economicqsmaster.com
Password: TestPassword123!
```

---

## 📊 First Run - What Happens

1. **App Start** → `AuthBloc` checks session
2. **No Session** → Redirect to Auth screen
3. **Sign Up** → Create profile + device binding
4. **Device ID Recorded** → hardware-id stored in Supabase
5. **Redirect** → Course dashboard
6. **Fetch Courses** → BLoC loads from Supabase
7. **Display Grid** → 3 sample courses shown
8. **Tap "Start"** → Load lecture view
9. **Video Loads** → JWT injected, Cloudflare proxy called
10. **GARCH Ready** → Can simulate volatility

---

## 🔧 Troubleshooting Quick Fixes

### "JWT validation failed"
```bash
# Clear app & re-authenticate
flutter clean
flutter run
```

### "Courses not loading"
```bash
# Check Supabase credentials in main.dart
# Verify internet connection
# Check Supabase dashboard → SQL for sample data
```

### "Video won't play"
```bash
# Verify Cloudflare worker is deployed
# Check Worker URL in video_player_bloc.dart
# Verify Google Drive file is shared with service account
```

### "GARCH chart blank"
```bash
# Ensure returns list has data (defaults provided)
# Check CustomPaint size (should be > 0)
# Verify GARCHChartPainter is receiving volatility data
```

---

## 📱 Device Testing

### Android
```bash
# List emulators
flutter emulators

# Start emulator
flutter emulators --launch Pixel_4_API_30

# Run app
flutter run
```

### iOS
```bash
# List simulators
xcrun simctl list devices

# Run on simulator
flutter run -d iphone

# Or in Xcode
open ios/Runner.xcworkspace
Product → Run
```

### Physical Device
```bash
# Enable developer mode on device
# Connect via USB
flutter devices  # Verify device appears

flutter run  # Runs on connected device
```

---

## 📚 Next: Explore Code

### 1. **Authentication Flow**
File: `lib/features/auth/presentation/bloc/auth_bloc.dart`
```
Understand: How device binding works
Learn: AuthEvent → AuthState transitions
```

### 2. **Course Loading**
File: `lib/features/courses/presentation/bloc/courses_bloc.dart`
```
Understand: How courses are fetched from Supabase
Learn: RLS policies protect user data
```

### 3. **Video Streaming**
File: `lib/features/video_player/presentation/bloc/video_player_bloc.dart`
```
Understand: JWT injection + proxy URL construction
Learn: How Cloudflare Worker validates requests
```

### 4. **GARCH Algorithm**
File: `lib/features/quantitative/presentation/bloc/quantitative_bloc.dart`
```
Understand: Volatility formula: σ²ₜ = ω + α*ε²ₜ₋₁ + β*σ²ₜ₋₁
Learn: Custom chart rendering
```

---

## 🎨 Customize Theming

File: `lib/shared/theme/app_theme.dart`

```dart
// Change primary color
static const Color _accentBlue = Color(0xFF0066FF);  // Blue
// ↓
static const Color _accentBlue = Color(0xFF00D084);  // Green
```

---

## 🚢 Deploy to App Store

### Android Play Store
```bash
# 1. Create signing key
keytool -genkey -v -keystore ~/economicqsmaster-key.keystore \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias economicqsmaster

# 2. Build release APK
flutter build apk --split-per-abi --release

# 3. Upload to Google Play Console
```

### iOS App Store
```bash
# 1. Build IPA
flutter build ipa --release

# 2. Open Xcode
open ios/Runner.xcworkspace

# 3. Product → Archive → Distribute App
```

---

## 📖 Documentation

| Document | For | Time |
|----------|-----|------|
| README.md | Overview | 5 min |
| ARCHITECTURE.md | System design | 15 min |
| DEPLOYMENT.md | Full setup | 30 min |
| API_REFERENCE.md | API endpoints | 10 min |
| GARCH_ALGORITHM.md | Math details | 20 min |

---

## 🆘 Get Help

### Common Issues

**"Permission denied" on Mac**
```bash
chmod +x ~/flutter/bin/flutter
```

**"Doctor error" in Flutter**
```bash
flutter doctor -v
# Follow suggestions
```

**"Pod install failed" on iOS**
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter run
```

---

## ✨ Pro Tips

### 1. Hot Reload
```bash
# While app is running:
r  # Quick reload
R  # Full restart
```

### 2. Debug Output
```dart
// In any file:
print('Debug message: $variable');

// Or use debugPrint (ignored in release)
debugPrint('Only in debug builds');
```

### 3. Check Device Binding
In Supabase SQL Editor:
```sql
SELECT id, device_id FROM public.profiles;
```

### 4. Monitor API Calls
```dart
// In http_client.dart, add:
print('Request: ${options.path}');
print('Response: ${response.statusCode}');
```

### 5. Profile App Performance
```bash
flutter run --profile

# Or in Xcode/Android Studio
Debug → Open DevTools → Performance
```

---

## 🎯 Learning Path

**Day 1**: Get app running + explore UI
- [ ] Complete Step 1-5 above
- [ ] Create test account
- [ ] Browse courses
- [ ] Play a video

**Day 2**: Understand architecture
- [ ] Read ARCHITECTURE.md
- [ ] Trace auth flow in code
- [ ] Read BLoC pattern
- [ ] Understand RLS policies

**Day 3**: Customize & extend
- [ ] Add new course
- [ ] Modify GARCH parameters
- [ ] Change theme colors
- [ ] Add new API endpoint

---

## 🤝 Contributing

Found a bug? Have a feature idea?

1. Fork repository
2. Create feature branch: `git checkout -b feature/my-feature`
3. Commit changes: `git commit -m 'Add feature'`
4. Push: `git push origin feature/my-feature`
5. Create Pull Request

---

## 📞 Support

- **Docs**: See `docs/` folder
- **Issues**: GitHub Issues
- **Email**: support@economicqsmaster.com

---

**You're ready to build!** 🚀

Questions? Check the full docs in `/docs` folder.
