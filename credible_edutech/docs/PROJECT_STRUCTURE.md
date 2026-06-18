# Project File Structure & Summary

## Complete Directory Tree

```
credible_edutech/
│
├── flutter_app/                          # Flutter Mobile Application
│   ├── lib/
│   │   ├── main.dart                     # App entry point, initialization, routing
│   │   │
│   │   ├── core/
│   │   │   └── service_locator.dart      # Dependency injection, GetIt setup
│   │   │
│   │   ├── features/                     # Feature modules (clean architecture)
│   │   │   ├── auth/
│   │   │   │   ├── presentation/
│   │   │   │   │   ├── bloc/
│   │   │   │   │   │   └── auth_bloc.dart    # Auth state management, device binding
│   │   │   │   │   └── screens/
│   │   │   │   │       └── auth_screen.dart  # Login/Register UI
│   │   │   │   └── data/
│   │   │   │       └── repositories/         # Auth repositories
│   │   │   │
│   │   │   ├── courses/
│   │   │   │   ├── presentation/
│   │   │   │   │   ├── bloc/
│   │   │   │   │   │   └── courses_bloc.dart # Course loading, caching
│   │   │   │   │   └── screens/
│   │   │   │   │       └── course_dashboard_screen.dart  # Grid of courses
│   │   │   │   └── data/
│   │   │   │       └── repositories/
│   │   │   │
│   │   │   ├── video_player/
│   │   │   │   ├── presentation/
│   │   │   │   │   ├── bloc/
│   │   │   │   │   │   └── video_player_bloc.dart  # Video streaming, JWT
│   │   │   │   │   └── screens/
│   │   │   │   │       └── lecture_view_screen.dart  # Dual-pane: video + notes
│   │   │   │   └── data/
│   │   │   │
│   │   │   └── quantitative/
│   │   │       ├── presentation/
│   │   │       │   ├── bloc/
│   │   │       │   │   └── quantitative_bloc.dart  # GARCH calculations
│   │   │       │   └── screens/
│   │   │       │       └── garch_simulator.dart
│   │   │       └── data/
│   │   │
│   │   ├── shared/                       # Shared across features
│   │   │   ├── network/
│   │   │   │   └── http_client.dart      # Dio setup, JWT interceptor
│   │   │   ├── storage/
│   │   │   │   └── cache_service.dart    # Hive setup, offline caching
│   │   │   ├── theme/
│   │   │   │   └── app_theme.dart        # Dark theme, professional styling
│   │   │   ├── widgets/
│   │   │   │   └── garch_chart_painter.dart  # Custom chart painter
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           ├── auth_screen.dart
│   │   │           ├── course_dashboard_screen.dart
│   │   │           └── deep_link_landing_screen.dart  # YouTube funnel entry
│   │   │
│   │   └── config/
│   │       └── constants.dart
│   │
│   ├── assets/
│   │   ├── svg/                          # SVG icons & illustrations
│   │   │   └── *.svg
│   │   ├── images/                       # WebP/PNG images
│   │   │   └── *.webp
│   │   └── fonts/
│   │       └── Roboto-*.ttf
│   │
│   ├── test/                             # Unit & widget tests
│   │   ├── features/
│   │   └── shared/
│   │
│   ├── android/                          # Android-specific config
│   │   └── app/src/main/AndroidManifest.xml
│   │
│   ├── ios/                              # iOS-specific config
│   │   └── Runner/Info.plist
│   │
│   ├── web/                              # Web build output
│   │
│   ├── pubspec.yaml                      # Flutter dependencies
│   ├── pubspec.lock                      # Locked versions
│   ├── analysis_options.yaml              # Linter rules
│   ├── .flutter_plugins                  # Plugin metadata
│   └── .gitignore
│
├── supabase_backend/                     # Backend Infrastructure
│   ├── schema.sql                        # Complete DB setup
│   │   ├── Tables:
│   │   │   ├── profiles (with device_id)
│   │   │   ├── courses
│   │   │   ├── videos (Google Drive refs)
│   │   │   ├── user_progress
│   │   │   └── device_sessions
│   │   ├── Functions:
│   │   │   ├── verify_device_binding()  # Anti-piracy
│   │   │   └── check_device_access()   # Trigger
│   │   ├── RLS Policies:
│   │   │   ├── Users can view own profile
│   │   │   ├── Videos are public
│   │   │   └── Progress is private
│   │   ├── Triggers:
│   │   │   └── Auto-update timestamps
│   │   └── Indexes (for performance)
│   │
│   └── migrations/                       # Database versioning (future)
│       └── 001_initial_schema.sql
│
├── cloudflare_worker/                    # Media Vault Proxy
│   ├── media-vault-proxy.js              # Main worker script
│   │   ├── validateJWT()                 # Supabase JWT check
│   │   ├── getGoogleAccessToken()        # Service account auth
│   │   ├── proxyGoogleDriveRequest()     # Video streaming
│   │   ├── addCORSHeaders()              # Security
│   │   └── handleRequest()               # Main handler
│   │
│   ├── wrangler.toml                     # Cloudflare config
│   ├── package.json                      # Node.js dependencies
│   └── .env.example                      # Environment template
│
├── docs/                                 # Documentation
│   ├── README.md                         # Project overview
│   ├── ARCHITECTURE.md                   # System design
│   ├── DEPLOYMENT.md                     # Setup & deployment guide
│   ├── API_REFERENCE.md                  # Complete API docs
│   ├── GARCH_ALGORITHM.md                # GARCH(1,1) math
│   └── TROUBLESHOOTING.md                # Common issues
│
├── .github/
│   └── workflows/
│       ├── test.yml                      # CI/CD for tests
│       ├── build.yml                     # CI/CD for builds
│       └── deploy.yml                    # Auto-deployment
│
├── .gitignore
├── .env.example
└── README.md (root)
```

---

## File Descriptions

### Core Flutter Files

| File | Purpose | Key Classes |
|------|---------|-------------|
| `main.dart` | App initialization, routing | `CredibleEdutech`, `_CredibleEdutechState` |
| `auth_bloc.dart` | Authentication state | `AuthBloc`, `AuthEvent`, `AuthState` |
| `courses_bloc.dart` | Course management | `CoursesBloc`, `CoursesEvent`, `CoursesState` |
| `video_player_bloc.dart` | Video streaming | `VideoPlayerBloc`, `VideoPlayerEvent` |
| `quantitative_bloc.dart` | GARCH calculations | `QuantitativeBloc`, `CalculateGARCHEvent` |
| `http_client.dart` | Network layer | `HttpClient`, `JwtInterceptor` |
| `cache_service.dart` | Local storage | `CacheService` (Hive) |
| `app_theme.dart` | UI styling | `AppTheme` (dark, professional) |
| `garch_chart_painter.dart` | Custom painting | `GARCHChartPainter` |

### Backend Files

| File | Purpose | Key Functions |
|------|---------|----------------|
| `schema.sql` | Database setup | All SQL tables, functions, policies |
| `media-vault-proxy.js` | Video proxy | Cloudflare Worker handler |
| `wrangler.toml` | Worker config | Environment, routes, binding |

### Documentation Files

| File | Content | Audience |
|------|---------|----------|
| `README.md` | Project overview | Everyone |
| `ARCHITECTURE.md` | System design | Developers |
| `DEPLOYMENT.md` | Setup guide | DevOps / Developers |
| `API_REFERENCE.md` | API endpoints | Frontend developers |
| `GARCH_ALGORITHM.md` | Mathematical details | Finance professionals |

---

## Key Dependencies

### Flutter Packages

```yaml
# State Management
flutter_bloc: ^8.1.0
bloc: ^8.1.0

# Networking
dio: ^5.3.0
connectivity_plus: ^5.0.0

# Authentication
supabase_flutter: ^1.10.0

# Video
better_player: ^0.0.85

# Storage
hive: ^2.2.0
hive_flutter: ^1.1.0

# Device Info
device_info_plus: ^9.0.0

# UI/UX
google_fonts: ^6.0.0
flutter_svg: ^2.0.0

# Utilities
get_it: ^7.5.0
equatable: ^2.0.5
```

### Backend (Supabase)
- PostgreSQL 13+
- PostGIS (optional, for location)
- pgvector (optional, for ML)

### Cloudflare
- Cloudflare Workers
- Cloudflare Cache
- Cloudflare Analytics

---

## Configuration Files

### `pubspec.yaml` (Flutter)
- Defines app metadata
- Lists dependencies
- Specifies assets (SVG, fonts, images)
- Sets minimum SDK version
- Enables Material 3 design

### `wrangler.toml` (Cloudflare)
- Worker name & account
- Routes & zones
- Environment variables
- Build configuration

### `schema.sql` (Supabase)
- Creates tables & indexes
- Sets up RLS policies
- Defines functions & triggers
- Seeds sample data

---

## Asset Organization

```
assets/
├── svg/
│   ├── logo.svg
│   ├── chart-icon.svg
│   └── course-card.svg
│
└── images/
    ├── splash.webp
    ├── onboarding-1.webp
    ├── onboarding-2.webp
    └── onboarding-3.webp
```

### Design Rationale
- **SVG**: Scalable, compact, professional
- **WebP**: Better compression than PNG
- **Total**: <5MB assets (meets strict binary limit)

---

## Build Output Locations

| Platform | Output Path | Size |
|----------|------------|------|
| Android APK | `build/app/outputs/flutter-apk/` | <15MB |
| iOS IPA | `build/ios/iphoneos/Runner.app/` | <20MB |
| Web | `build/web/` | <10MB |

---

## Source Code Metrics

| Metric | Value |
|--------|-------|
| Total Flutter files | ~20 core files |
| Total lines of code | ~5,000 (Flutter) |
| SQL lines | ~400 |
| Worker code lines | ~300 |
| Documentation | ~8,000 lines |

---

## Development Workflow

### 1. Local Development
```bash
# Install dependencies
flutter pub get

# Generate code
flutter pub run build_runner build

# Run on emulator
flutter run -d emulator

# Hot reload while running
r  # Rebuild
R  # Hot restart
q  # Quit
```

### 2. Testing
```bash
# Run unit tests
flutter test

# Run widget tests
flutter test test/features/

# Coverage
flutter test --coverage
```

### 3. Build for Deployment
```bash
# Android
flutter build apk --split-per-abi --release

# iOS
flutter build ipa --release

# Web
flutter build web --release
```

---

## Code Organization Principles

### 1. **Clean Architecture**
- Separation of concerns (presentation, domain, data)
- Easy to test and maintain
- Feature-based folder structure

### 2. **BLoC Pattern**
- Single responsibility (one BLoC = one feature)
- Reactive programming (events → states)
- Testable business logic

### 3. **Type Safety**
- Null safety enabled
- Strict linting rules
- Freezed for immutable models

### 4. **Security by Default**
- Device binding in auth
- RLS on database
- CORS enforcement
- Encrypted storage

---

## Next Steps for Developers

1. ✅ Clone repository
2. ✅ Run `flutter pub get`
3. ✅ Update Supabase credentials in `main.dart`
4. ✅ Deploy Cloudflare Worker
5. ✅ Run `flutter run` on emulator
6. ✅ Test authentication flow
7. ✅ Test video streaming
8. ✅ Test GARCH calculator

---

**This structure is production-ready and scalable.** 🚀
