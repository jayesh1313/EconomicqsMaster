# Deployment Guide

## Prerequisites

- Flutter SDK 3.0+
- Node.js 16+
- Supabase CLI (optional but recommended)
- Cloudflare account
- Google Cloud Project

---

## Part 1: Supabase Setup

### Step 1: Create Supabase Project

1. Go to [supabase.com](https://supabase.com)
2. Sign in and create new organization
3. Create new project:
   - Name: `economicqsmaster`
   - Database password: [strong password]
   - Region: [closest to your users]
4. Save credentials:
   - Project URL: `https://xxx.supabase.co`
   - Anon Key: `eyJhbGc...`

### Step 2: Run SQL Schema

1. Open Supabase dashboard → SQL Editor
2. Create new query
3. Copy entire content of `supabase_backend/schema.sql`
4. Execute

This will create:
- ✅ profiles table
- ✅ courses table
- ✅ videos table
- ✅ user_progress table
- ✅ device_sessions table
- ✅ RLS policies
- ✅ Anti-piracy functions
- ✅ Indexes

### Step 3: Enable Google Drive Integration (Optional)

1. Supabase → Database → Webhooks
2. Create webhook for video access logs
3. Configure to send to monitoring service

### Step 4: Test Connection

```sql
-- In SQL Editor, run:
SELECT * FROM public.courses LIMIT 5;

-- Should return sample courses (from SEED DATA in schema.sql)
```

### Step 5: Create Anon Key & Service Role Key

1. Supabase → Settings → API
2. Copy:
   - `anon` key (public, safe to ship in app)
   - `service_role` key (private, for backend only)

---

## Part 2: Google Drive Setup

### Step 1: Create Service Account

1. Google Cloud Console → Create Project
2. APIs & Services → Credentials
3. Create Service Account
4. Download JSON key file
5. Copy values:
   - `client_email`: `xxx@project.iam.gserviceaccount.com`
   - `private_key`: (PEM format)
   - `project_id`: `your-gcp-project`

### Step 2: Enable Google Drive API

1. APIs & Services → Enable APIs
2. Search "Google Drive API"
3. Click Enable

### Step 3: Create Private Vault Folder

1. Google Drive → New Folder → "CredibleEdutech Vault"
2. Right-click → Share
3. Paste service account email
4. Grant Editor access
5. Copy folder ID from URL: `drive.google.com/drive/folders/{FOLDER_ID}`

### Step 4: Upload Sample Videos

1. Create test videos (or use sample MP4s)
2. Upload to "CredibleEdutech Vault"
3. For each video, note the file ID:
   - Open file → URL: `drive.google.com/file/d/{FILE_ID}/view`

---

## Part 3: Cloudflare Worker Setup

### Step 1: Install Wrangler CLI

```bash
npm install -g wrangler
wrangler login
```

### Step 2: Update Configuration

Edit `cloudflare_worker/wrangler.toml`:

```toml
account_id = "your-account-id"  # Found in Cloudflare dashboard
zone_id = "your-zone-id"         # DNS zone ID

[env.production.vars]
SUPABASE_URL = "https://xxx.supabase.co"
SUPABASE_ANON_KEY = "eyJhbGc..."
GOOGLE_PROJECT_ID = "your-gcp-project"
GOOGLE_SERVICE_ACCOUNT_EMAIL = "xxx@project.iam.gserviceaccount.com"
```

### Step 3: Update Worker Code

Edit `cloudflare_worker/media-vault-proxy.js`:

Update `CONFIG` object:

```javascript
const CONFIG = {
  SUPABASE_URL: 'https://xxx.supabase.co',
  SUPABASE_ANON_KEY: 'eyJhbGc...',
  GOOGLE_SERVICE_ACCOUNT_EMAIL: 'xxx@project.iam.gserviceaccount.com',
  GOOGLE_SERVICE_ACCOUNT_PRIVATE_KEY: 'your-private-key',
  GOOGLE_PROJECT_ID: 'your-gcp-project-id',
  ALLOWED_ORIGINS: [
    'app://economicqsmaster.com',
    'https://economicqsmaster.com',
    'https://localhost:8080'  // For testing
  ],
};
```

### Step 4: Deploy Worker

```bash
cd cloudflare_worker
wrangler deploy --env production
```

Output will show:
```
✓ Deployed to media-vault.economicqsmaster.com
```

### Step 5: Test Worker

```bash
curl "https://media-vault.economicqsmaster.com/proxy?fileId=test&jwt=invalid" \
  -H "Origin: app://economicqsmaster.com"

# Should return 401 (invalid JWT)
```

---

## Part 4: Flutter App Setup

### Step 1: Update Configuration

Edit `flutter_app/lib/main.dart`:

```dart
const String supabaseUrl = 'https://xxx.supabase.co';
const String supabaseAnonKey = 'eyJhbGc...';
```

### Step 2: Update Media Vault URL

Edit `flutter_app/lib/features/video_player/presentation/bloc/video_player_bloc.dart`:

```dart
static const String _mediaVaultUrl = 'https://media-vault.economicqsmaster.com/proxy';
```

### Step 3: Generate Dependencies

```bash
cd flutter_app
flutter pub get
flutter pub run build_runner build
```

### Step 4: Configure Deep Linking (iOS)

**ios/Runner/Info.plist**:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLName</key>
    <string>com.economicqsmaster.credible</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>app</string>
    </array>
  </dict>
</array>
```

### Step 5: Configure Deep Linking (Android)

**android/app/src/main/AndroidManifest.xml**:

```xml
<activity
  android:name=".MainActivity"
  android:launchMode="singleTop">
  
  <intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
      android:scheme="app"
      android:host="economicqsmaster.com"
      android:pathPattern="/course.*" />
  </intent-filter>
  
</activity>
```

### Step 6: Build Release APK

```bash
flutter build apk --split-per-abi --release
```

Output: `flutter_app/build/app/outputs/flutter-apk/app-release.apk`

### Step 7: Build iOS App

```bash
flutter build ios --release
```

Then open in Xcode and upload to App Store.

---

## Part 5: Database Population

### Add Sample Courses

1. Supabase Dashboard → Table Editor
2. Select `courses` table
3. Insert rows:

```
| title | description | instructor | tier |
|-------|-------------|-----------|------|
| Volatility Forecasting with GARCH | Master GARCH(1,1) models | Economicqsmaster | premium |
| Time Series Fundamentals | Intro to econometrics | Economicqsmaster | free |
| Portfolio Optimization | Modern portfolio theory | Economicqsmaster | premium |
```

### Add Sample Videos

1. Select `videos` table
2. Insert rows:

```
| course_id | title | google_drive_file_id | sequence | duration |
|-----------|-------|----------------------|----------|----------|
| [course1_id] | GARCH Intro | [FILE_ID_1] | 1 | 15 |
| [course1_id] | GARCH Application | [FILE_ID_2] | 2 | 20 |
| [course2_id] | Time Series Basics | [FILE_ID_3] | 1 | 12 |
```

---

## Part 6: Testing & Validation

### 1. Test Authentication

```bash
# In app, try:
# Email: test@example.com
# Password: TestPassword123!

# Should:
# ✅ Create profile with device_id
# ✅ Set tier to 'free'
# ✅ Redirect to courses dashboard
```

### 2. Test Course Loading

```bash
# On courses dashboard:
# ✅ Should see grid of 3 courses
# ✅ Cards show title, description, "Start" button
# ✅ Tap "Start" → Navigate to lecture view
```

### 3. Test Video Streaming

```bash
# On lecture view:
# ✅ Video player loads
# ✅ Play button works
# ✅ Seeking works (byte-range requests)
# ✅ Check Cloudflare Worker logs for JWT validation
```

### 4. Test GARCH Calculator

```bash
# Expand GARCH Simulator:
# ✅ Input ω, α, β
# ✅ Click Calculate
# ✅ See volatility chart render
# ✅ Current vol displays
```

### 5. Test Device Binding

```bash
# Scenario 1: Same device, same login
# ✅ Works normally

# Scenario 2: Different device, same account
# 1. Login on Device A
# 2. Copy JWT from Device A
# 3. Try to use JWT on Device B
# Expected: 403 Forbidden (device binding failed)
```

### 6. Check Worker Logs

```bash
# Cloudflare Dashboard → Workers → Tail
wrangler tail --env production

# Should see:
# ✅ Successful JWT validations
# ✅ Google token exchanges
# ✅ Video proxies (206 responses)
```

---

## Part 7: Production Deployment

### Cloudflare Worker (Already Deployed)

```bash
wrangler deploy --env production
```

### Flutter App - Google Play Store

1. Create signing key:
   ```bash
   keytool -genkey -v -keystore ~/economicqsmaster-key.keystore \
     -keyalg RSA -keysize 2048 -validity 10000 -alias economicqsmaster
   ```

2. Build signed APK:
   ```bash
   flutter build apk --split-per-abi --release \
     -Pandroid.keyStore=true \
     -Pandroid.keyStoreFile=~/economicqsmaster-key.keystore \
     -Pandroid.keyStorePassword=yourpassword \
     -Pandroid.keyAlias=economicqsmaster \
     -Pandroid.keyAliasPassword=yourpassword
   ```

3. Upload to Google Play Console

### Flutter App - Apple App Store

1. Build release IPA:
   ```bash
   flutter build ipa --release
   ```

2. Open in Xcode:
   ```bash
   xed build/ios
   ```

3. Product → Archive → Upload to App Store

---

## Part 8: Monitoring & Maintenance

### Cloudflare Analytics

1. Dashboard → Analytics
2. Monitor:
   - Request rate
   - Error rate
   - Cache hit ratio
   - Geographic distribution

### Supabase Monitoring

1. Dashboard → Reports
2. Monitor:
   - API usage
   - Database connections
   - Storage usage
   - Auth events

### Error Tracking

```bash
# Sentry integration (optional but recommended)
flutter pub add sentry_flutter

# Initialize in main.dart:
await SentryFlutter.init(
  (options) => options.dsn = 'your-sentry-dsn',
  appRunner: () => runApp(const CredibleEdutech()),
);
```

---

## Troubleshooting

### App won't authenticate
```
❌ JWT validation failed
✅ Check: Supabase URL + anon key match
✅ Check: Device ID is being set
✅ Check: Supabase RLS policies allow auth
```

### Videos won't play
```
❌ Cloudflare Worker returning 401
✅ Check: JWT is valid
✅ Check: Google Drive file is shared with service account
✅ Check: Worker CONFIG has correct credentials
```

### GARCH chart not rendering
```
❌ CustomPaint not showing
✅ Check: Returns list is not empty
✅ Check: GARCHChartPainter.shouldRepaint() returning true
✅ Check: Canvas size is not zero
```

### Device binding too strict
```
❌ Users getting logged out on other devices
✅ This is intentional (anti-piracy feature)
✅ Users must log out/in to switch devices
✅ Track device_sessions for better UX (future)
```

---

## Next Steps

- [ ] Set up monitoring (Sentry, DataDog)
- [ ] Configure app analytics (Firebase)
- [ ] Set up automated testing (GitHub Actions)
- [ ] Create admin dashboard for course management
- [ ] Implement payment processing (Stripe)
- [ ] Add social features (comments, discussions)

---

**Ready for Launch** 🚀
