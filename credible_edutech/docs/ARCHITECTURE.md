# Architecture Overview

## System Design

```
┌─────────────────────────────────────────────────────────────────┐
│                    YouTube (Funnel Entry)                        │
│  "Check out app://economicqsmaster.com/course/garch-101"        │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ↓
┌─────────────────────────────────────────────────────────────────┐
│                   Flutter Mobile App                             │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐  │
│  │   Auth Layer     │  │  Courses Module  │  │ Video Player │  │
│  │  (BLoC)          │  │  (BLoC)          │  │ (BLoC)       │  │
│  │                  │  │                  │  │              │  │
│  │ • Device Binding │  │ • Course Load    │  │ • JWT Inject │  │
│  │ • OAuth 2.0      │  │ • Progress Track │  │ • Proxy URL  │  │
│  │ • RLS Check      │  │                  │  │              │  │
│  └──────────────────┘  └──────────────────┘  └──────────────┘  │
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  Quantitative Module (GARCH Simulator)                     │ │
│  │  ┌──────────────────────────────────────────────────────┐  │ │
│  │  │ GARCH(1,1): σ²ₜ = ω + α*ε²ₜ₋₁ + β*σ²ₜ₋₁             │  │ │
│  │  │                                                      │  │ │
│  │  │ Input: Returns, ω, α, β                            │  │ │
│  │  │ Output: Volatility chart, Current vol              │  │ │
│  │  │                                                      │  │ │
│  │  │ [Interactive Chart Painter]                         │  │ │
│  │  └──────────────────────────────────────────────────────┘  │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  Shared Layer (Network, Storage, Theme)                    │ │
│  │  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐        │ │
│  │  │   Dio HTTP   │ │  Hive Cache  │ │  Dark Theme  │        │ │
│  │  │              │ │              │ │              │        │ │
│  │  │ JWT Inject   │ │ Offline DB   │ │ Professional │        │ │
│  │  │ Interceptor  │ │ SQLite       │ │ Color Scheme │        │ │
│  │  └──────────────┘ └──────────────┘ └──────────────┘        │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
└─────────────────────────┬────────────────────────────────────────┘
                          │
                          ↓
┌─────────────────────────────────────────────────────────────────┐
│         Cloudflare Edge (Workers + CDN)                         │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Media Vault Proxy (Cloudflare Worker)                   │  │
│  │                                                           │  │
│  │  Request Flow:                                           │  │
│  │  1. Receive [JWT + fileId] from app                      │  │
│  │  2. Validate JWT (Supabase check)                        │  │
│  │  3. Generate Google IAM token (Service Account)          │  │
│  │  4. Proxy to Google Drive: /files/{fileId}?alt=media     │  │
│  │  5. Support Range headers (206 Partial Content)          │  │
│  │  6. Enforce CORS (app domain only)                       │  │
│  │                                                           │  │
│  │  Returns:                                                │  │
│  │  200 OK (full video)                                     │  │
│  │  206 Partial Content (byte-range seek)                   │  │
│  │  401 Unauthorized (invalid JWT)                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Caching Layer (Cloudflare Cache)                        │  │
│  │  • Metadata cache (1 hour)                               │  │
│  │  • Video chunks (long-lived)                             │  │
│  │  • CORS preflight cache                                  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
└─────────────┬────────────────────────────────────┬──────────────┘
              │                                    │
              ↓                                    ↓
┌──────────────────────────────┐  ┌────────────────────────────────┐
│  Supabase PostgreSQL         │  │  Google Drive API              │
├──────────────────────────────┤  ├────────────────────────────────┤
│                              │  │                                │
│  ┌────────────────────────┐  │  │  ┌────────────────────────────┐│
│  │ Auth & Device Binding  │  │  │  │  Private Vault             ││
│  │ • profiles (device_id) │  │  │  │ • Video files (.mp4, .mkv) ││
│  │ • device_sessions      │  │  │  │ • Metadata                 ││
│  └────────────────────────┘  │  │  └────────────────────────────┘│
│                              │  │                                │
│  ┌────────────────────────┐  │  │  ┌────────────────────────────┐│
│  │ Course Management      │  │  │  │  Access Control            ││
│  │ • courses              │  │  │  │ • Service account has read ││
│  │ • videos (GDrive refs) │  │  │  │ • Folder is private        ││
│  │ • user_progress        │  │  │  │ • Time-limited tokens      ││
│  └────────────────────────┘  │  │  └────────────────────────────┘│
│                              │  │                                │
│  ┌────────────────────────┐  │  │  ┌────────────────────────────┐│
│  │ RLS Policies           │  │  │  │  IAM Setup                 ││
│  │ • User isolation       │  │  │  │ • Service account auth     ││
│  │ • Tier-based access    │  │  │  │ • JWT token exchange       ││
│  │ • Anti-piracy checks   │  │  │  │ • 1-hour token lifetime    ││
│  └────────────────────────┘  │  │  └────────────────────────────┘│
│                              │  │                                │
└──────────────────────────────┘  └────────────────────────────────┘
```

---

## Data Flow - Video Playback

```
User taps "Play Video"
          ↓
VideoPlayerBloc: LoadVideoEvent(videoId)
          ↓
Query Supabase: SELECT google_drive_file_id FROM videos WHERE id = videoId
          ↓
Construct proxy URL: 
    https://media-vault.economicqsmaster.com/proxy
    ?fileId={drive_file_id}
    &jwt={session.accessToken}
          ↓
Dio HTTP Client injects Authorization header (JWT)
          ↓
Better Player loads proxy URL
          ↓
Cloudflare Worker receives request
          ↓
1. Validate JWT via Supabase: /auth/v1/user
   ↓
   If invalid → 401 Unauthorized
          ↓
2. Generate Google IAM token using service account
   ↓
   Fetch JWT for Google OAuth2
          ↓
3. Exchange JWT for access token
   ↓
   POST https://oauth2.googleapis.com/token
          ↓
4. Proxy request to Google Drive
   ↓
   GET https://www.googleapis.com/drive/v3/files/{fileId}?alt=media
   Authorization: Bearer {google_access_token}
   Range: bytes=0-{chunk_size} (if seeking)
          ↓
5. Return response with CORS headers
   ↓
   200 OK (full content)
   206 Partial Content (byte-range)
   Access-Control-Allow-Origin: app://economicqsmaster.com
          ↓
Better Player receives video stream
          ↓
Byte-range support enables smooth seeking
          ↓
Video displays in player
```

---

## Authentication & Device Binding Flow

```
User opens app (first time)
          ↓
AuthBloc: AuthCheckStatusEvent
          ↓
Get device ID (Android: device.id, iOS: identifierForVendor)
          ↓
Check Supabase session: supabaseClient.auth.currentSession
          ↓
┌─────────────────┬──────────────────┐
│   No Session    │   Session Exists  │
└────────┬────────┴────────┬──────────┘
         │                 │
         ↓                 ↓
   Login/Register    Verify Device Binding
         │                 │
    Email+Password    SELECT device_id FROM profiles WHERE id = auth.uid()
         │                 │
         ↓                 ↓
    Create Auth User   Compare: stored_device_id == current_device_id
         │                 │
    ┌────┴────────┐    ┌────┴────────┐
    │             │    │             │
    ↓             ↓    ↓             ↓
Success      Error  Match        Mismatch
    │             │    │             │
    ↓             ↓    ↓             ↓
INSERT INTO   Error Authenticated Logout
profiles:     State  State       Error State
{id, email,        ↓             ↓
full_name,    Retry  Continue    Logout
device_id:          to Course   & Redirect
current_id}         Dashboard   to Auth
    │
    ↓
AuthAuthenticated(userId, email, deviceId)
    │
    ↓
Navigate to CourseD Dashboard
    │
    ↓
All subsequent API calls include JWT with auth.uid()
Cloudflare Worker validates: stored_device_id == current_device_id
    │
    ↓
Access granted or denied
```

---

## GARCH Calculation Pipeline

```
User enters parameters
    ↓
[ω: 0.00001]
[α: 0.1]
[β: 0.88]
    ↓
QuantitativeBloc: CalculateGARCHEvent
    ↓
Load returns data (historical or synthetic)
    ↓
Initialize: σ²₀ = mean(returns²)
    ↓
Recursion (t=1 to T):
    │
    ├─ ε²ₜ₋₁ = returns[t-1]²
    │
    ├─ σ²ₜ = ω + α*ε²ₜ₋₁ + β*σ²ₜ₋₁
    │
    ├─ σₜ = √(σ²ₜ)  [volatility]
    │
    └─ Store (σₜ, σ²ₜ)
    ↓
Emit GARCHCalculated(
    volatility: [σ₁, σ₂, ..., σₜ],
    conditional_variance: [σ²₁, σ²₂, ..., σ²ₜ],
    current_volatility: σₜ
)
    ↓
UI re-renders with:
    ├─ CustomPaint(GARCHChartPainter)
    │  ├─ Grid background
    │  ├─ Volatility line chart
    │  ├─ Data points (circles)
    │  └─ Y-axis labels
    │
    └─ Current vol badge: "12.34%"
```

---

## Caching Strategy

### L1: In-Memory (Flutter)
- **Duration**: Session lifetime
- **Data**: Current video, course list
- **Hit Rate**: ~95% for same session

### L2: Local Storage (Hive)
- **Duration**: 30 days
- **Data**: Video metadata, course data, user profile
- **Size**: <50MB limit
- **Hit Rate**: ~70% for repeat sessions

### L3: Cloudflare CDN
- **Duration**: 1 hour (metadata), long (videos)
- **Data**: Video chunks, course listings
- **Hit Rate**: ~60% (user-dependent)

### L4: Database (Supabase)
- **Duration**: Real-time
- **Data**: User progress, live course updates

---

## Error Handling & Resilience

### Network Errors
```
Dio Exception
    ↓
    ├─ Timeout → Retry with exponential backoff (max 3 attempts)
    ├─ Connection Error → Show offline mode, use cache
    ├─ 401 Unauthorized → Refresh token, retry
    ├─ 403 Forbidden → Logout, show auth error
    └─ 5xx Server Error → Show error, allow retry
```

### GARCH Calculation Errors
```
Invalid parameter
    ↓
    ├─ ω + α + β > 1 → Warn: "Non-stationary model"
    ├─ Negative returns list → Normalize to absolute
    └─ Empty returns → Use synthetic data
```

### Device Binding Errors
```
Device mismatch detected
    ↓
    ├─ Logout user
    ├─ Clear local storage
    ├─ Show: "Please log in from your registered device"
    └─ Require re-authentication
```

---

## Security Considerations

### JWT Security
- ✅ Signed tokens (HMAC-SHA256)
- ✅ Expiry: 1 hour
- ✅ Refresh token rotation
- ✅ Device ID binding in JWT

### Data Encryption
- ✅ TLS in transit (HTTPS)
- ✅ AES-256 for sensitive data at rest (credentials)
- ✅ SQLite encrypted with `sqlcipher` (premium tier)

### API Security
- ✅ RLS policies (row-level access control)
- ✅ Rate limiting (Cloudflare)
- ✅ DDoS protection (Cloudflare)
- ✅ CORS enforcement (app domain only)

---

**Designed for Scale, Security, and Simplicity** 🚀
