# CredibleEdutech - High-Performance Quantitative Learning Platform

## Overview

**CredibleEdutech** is a production-grade mobile application that transforms YouTube-based content discovery into a secure, monetizable learning environment for quantitative finance. Built for the **Economicqsmaster** brand, it bridges low-income learners with legacy hardware and high-end finance professionals.

### Key Features

✅ **Mobile-First**: Flutter compiled to ARM machine code (<15MB binary)
✅ **Secure**: Supabase + RLS with device-based anti-piracy
✅ **Scalable**: Cloudflare Workers + Google Drive CDN
✅ **Quantitative**: GARCH(1,1) volatility simulator with interactive charts
✅ **Offline**: Aggressive caching with Hive
✅ **Deep-Linking**: Direct onboarding from YouTube descriptions

---

## Project Structure

```
credible_edutech/
├── flutter_app/                 # Flutter frontend
│   ├── lib/
│   │   ├── core/               # Core services (service locator)
│   │   ├── features/           # Feature modules (clean architecture)
│   │   │   ├── auth/           # Authentication & device binding
│   │   │   ├── courses/        # Course management
│   │   │   ├── video_player/   # Video streaming
│   │   │   └── quantitative/   # GARCH simulator
│   │   ├── shared/             # Shared widgets, theme, network
│   │   ├── main.dart           # Application entry point
│   │   └── pubspec.yaml        # Dependencies
│   └── assets/                 # SVG/WebP assets
├── supabase_backend/           # Backend infrastructure
│   └── schema.sql              # Database setup + RLS + anti-piracy
├── cloudflare_worker/          # Media vault proxy
│   ├── media-vault-proxy.js    # JWT validation + Google Drive proxy
│   └── wrangler.toml           # Cloudflare config
└── docs/                       # Documentation
    ├── ARCHITECTURE.md
    ├── DEPLOYMENT.md
    ├── API_REFERENCE.md
    └── GARCH_ALGORITHM.md
```

---

## Technical Stack

### Frontend
- **Flutter**: Modular, domain-driven architecture with clean code
- **State Management**: flutter_bloc for reactive UI
- **Networking**: dio with JWT interceptor
- **Video**: better_player with proxy support
- **Storage**: Hive for offline caching + SQLite
- **Crypto**: Device-based encryption for secure binding

### Backend
- **Database**: Supabase PostgreSQL with RLS
- **Auth**: OAuth 2.0 with hardware device binding
- **Media**: Google Drive API (Private Vault)
- **Proxy**: Cloudflare Workers

### Infrastructure
- **CDN**: Cloudflare Edge (byte-range support, CORS)
- **Edge Computing**: Workers for JWT validation + token exchange
- **Storage**: Google Drive (alt=media streaming)

---

## Key Components

### 1. **Flutter App Structure**

#### Domain-Driven Design
```
features/
├── auth/
│   ├── presentation/
│   │   ├── bloc/          # AuthBloc (check status, login, register, logout)
│   │   └── screens/
│   ├── data/              # Repositories, data sources
│   └── domain/            # Entities, use cases
├── courses/
│   ├── presentation/
│   │   ├── bloc/          # CoursesBloc (load courses, load details)
│   │   └── screens/
│   ├── data/
│   └── domain/
├── video_player/
│   ├── presentation/
│   │   ├── bloc/          # VideoPlayerBloc (JWT token generation)
│   │   ├── screens/       # Lecture view with dual-pane layout
│   │   └── widgets/
│   ├── data/
│   └── domain/
└── quantitative/
    ├── presentation/
    │   ├── bloc/          # QuantitativeBloc (GARCH calculations)
    │   ├── screens/
    │   └── widgets/       # GARCHChartPainter
    ├── data/
    └── domain/
```

#### State Management with flutter_bloc

**AuthBloc**: Manages authentication state with device binding
```dart
// Events
AuthCheckStatusEvent()
AuthLoginEvent(email, password)
AuthRegisterEvent(email, password, fullName)
AuthLogoutEvent()

// States
AuthLoading, AuthAuthenticated(userId, email, deviceId), AuthUnauthenticated, AuthError
```

**CoursesBloc**: Manages course loading and caching
```dart
// Events
LoadCoursesEvent()
LoadCourseDetailsEvent(courseId)

// States
CoursesLoading, CoursesLoaded, CourseDetailsLoaded, CoursesError
```

**VideoPlayerBloc**: Manages video streaming with proxy
```dart
// Events
LoadVideoEvent(videoId)
GenerateAccessTokenEvent(fileId)

// States
VideoPlayerLoading, VideoPlayerLoaded, VideoPlayerError
```

**QuantitativeBloc**: GARCH calculations
```dart
// Events
CalculateGARCHEvent(returns, omega, alpha, beta)

// States
QuantitativeLoading, GARCHCalculated, QuantitativeError
```

### 2. **Supabase Database**

#### Tables
- **profiles**: User profiles with device binding
- **courses**: Course metadata
- **videos**: Video references to Google Drive
- **user_progress**: Progress tracking
- **device_sessions**: Active sessions (anti-piracy)

#### Anti-Piracy Security
```sql
-- Device binding verification
CREATE FUNCTION verify_device_binding(p_user_id, p_device_id)
RETURNS BOOLEAN
-- Ensures: auth.uid() = profile.device_id
-- Blocks: Multi-device account sharing
```

#### RLS Policies
```sql
-- Users see only their own data
-- Videos are public (with tier restrictions)
-- Progress is user-specific
```

### 3. **Cloudflare Worker (Media Vault Proxy)**

**Request Flow**:
```
Mobile App
    ↓
[JWT + fileId] → Cloudflare Worker
    ↓
[Validate JWT] → Supabase
    ↓
[Get Access Token] → Google Service Account
    ↓
[Proxy Request] → Google Drive API?alt=media
    ↓
[Byte-Range Support] → Stream to App
```

**Features**:
- ✅ JWT validation (Supabase)
- ✅ Google IAM token generation (service account)
- ✅ HTTP 206 Partial Content (video seeking)
- ✅ CORS enforcement (app domain only)
- ✅ Request/response logging

### 4. **Quantitative Module (GARCH Simulator)**

**Algorithm**: GARCH(1,1) Volatility Model

$$\sigma^2_t = \omega + \alpha \epsilon^2_{t-1} + \beta \sigma^2_{t-1}$$

Where:
- **ω** (omega): Long-term volatility
- **α** (alpha): Reaction to market shocks
- **β** (beta): Volatility persistence
- **ε** (epsilon): Returns (t-1)

**Implementation**:
```dart
Map<String, dynamic> _garchSimulation({
  required List<double> returns,
  required double omega,
  required double alpha,
  required double beta,
}) {
  // Initialize with sample variance
  double sigma2 = returns.fold(...) / returns.length;
  
  // GARCH recursion
  for (int i = 1; i < returns.length; i++) {
    final epsilon2 = returns[i-1] * returns[i-1];
    sigma2 = omega + (alpha * epsilon2) + (beta * sigma2);
  }
  
  return {
    'volatility': [...],
    'conditional_variance': [...],
    'current_volatility': sigma2.sqrt(),
  };
}
```

**Visualization**:
- Custom painter for dynamic SVG-style charts
- Real-time line rendering
- Grid overlay
- Axis labels

### 5. **UI/UX Screens**

#### 1. **Auth Screen**
- Clean login/register form
- Professional dark theme
- Device binding on registration

#### 2. **Course Dashboard**
- Grid layout (2 columns on mobile, 3+ on tablet)
- Course cards with gradient overlay
- "Start" CTA buttons

#### 3. **Deep-Link Landing**
- YouTube description: `app://economicqsmaster.com/course/{id}`
- Instant course onboarding
- Hero section with description
- Course contents list

#### 4. **Lecture View (Dual-Pane)**
```
┌─────────────────────┐
│  Better Player      │
│  (Video Stream)     │
├─────────────────────┤
│ GARCH Formula (LaTeX)
│ Study Notes         │
├─────────────────────┤
│ GARCH Simulator     │
│ [ω] [α] [β]        │
│ [Calculate]         │
│ [Chart Visualization]
└─────────────────────┘
```

---

## Setup & Deployment

### Prerequisites
- Flutter SDK 3.0+
- Supabase account
- Cloudflare account
- Google Cloud Project with Drive API enabled

### 1. **Flutter App Setup**

```bash
cd flutter_app
flutter pub get
flutter pub run build_runner build
flutter run -d web  # Or Android/iOS
```

### 2. **Supabase Setup**

```bash
# 1. Create new Supabase project
# 2. Copy project URL and anon key
# 3. Update main.dart with credentials
# 4. Run schema.sql in Supabase SQL editor
```

### 3. **Cloudflare Worker Deployment**

```bash
cd cloudflare_worker
npm install -g wrangler
wrangler login
wrangler deploy  # Deploys to your zone
```

### 4. **Configure Google Drive API**

```bash
# 1. Create service account in Google Cloud
# 2. Generate and download private key
# 3. Share a Google Drive folder with service account email
# 4. Update CONFIG in media-vault-proxy.js
```

---

## API Reference

### Authentication
```
POST /auth/v1/signup
POST /auth/v1/signin
POST /auth/v1/logout
GET /auth/v1/user (authenticated)
```

### Courses
```
GET /courses          # Public
GET /courses/{id}     # Public
GET /courses/{id}/videos  # Public
```

### Progress
```
GET /user_progress/{videoId}    # Authenticated
PATCH /user_progress/{videoId}  # Authenticated
```

### Media Proxy
```
GET /proxy?fileId={id}&jwt={token}
  Headers: Authorization: Bearer {jwt}
           Range: bytes={start}-{end}
  Returns: 200 OK (full) or 206 Partial Content
```

---

## Performance Metrics

### Binary Size
- **Target**: <15MB
- **Strategy**: Tree-shaking, SVG assets, aggressive code splitting

### Offline Performance
- **Caching**: Hive local storage
- **Video**: Progressive download + resume
- **Metadata**: Auto-sync on reconnect

### API Response Time
- **Courses List**: <200ms (cached)
- **Video Stream**: <100ms (CDN)
- **GARCH Calculation**: <50ms

---

## Security Features

### Device Binding
```
Account ← → One Device (Hardware ID)
Multi-device = Account Lockout
```

### JWT Flow
```
1. User logs in
2. Device ID stored in profiles.device_id
3. Every API call includes JWT
4. Cloudflare validates JWT
5. Device check: auth.uid() device matches stored device_id
```

### RLS Policies
- Users see only own profiles
- Videos are public (tier-based)
- Progress is user-specific
- Device sessions are user-specific

---

## Compliance & Monetization

### Tier System
- **Free**: Limited courses (introductory modules)
- **Premium**: Full access (advanced quantitative modules)

### Anti-Piracy
- Device binding (one account = one phone/tablet)
- Session revocation on unauthorized access
- Encrypted credentials storage

---

## Troubleshooting

### JWT Token Expired
→ App auto-refreshes via Supabase session refresh

### Video Not Loading
→ Check Cloudflare Worker logs in dashboard
→ Verify Google Drive file sharing

### GARCH Calculation Slow
→ Reduce returns list size
→ Use isolate for heavy computation

### Device Binding Fails
→ Clear app cache + re-authenticate
→ Verify device_id matches hardware

---

## Next Steps

1. ✅ **Backend Integration**: Connect to live Supabase
2. ✅ **Google Drive Setup**: Upload sample videos
3. ✅ **Cloudflare Deployment**: Deploy media vault worker
4. ✅ **Testing**: E2E tests with BDD framework
5. ✅ **App Store**: Build APK/IPA for distribution

---

## Support & Documentation

- **Flutter Docs**: https://flutter.dev
- **Supabase Docs**: https://supabase.io/docs
- **Cloudflare Workers**: https://developers.cloudflare.com/workers
- **Better Player**: https://github.com/jhomlala/better_player

---

**Built with ❤️ for Economicqsmaster**
