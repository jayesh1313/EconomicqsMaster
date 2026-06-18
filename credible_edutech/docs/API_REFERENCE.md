# API Reference

## Overview

CredibleEdutech uses a combination of:
- **Supabase**: Main API (PostgreSQL with RLS)
- **Cloudflare Worker**: Media proxy (Google Drive streaming)
- **Google Drive API**: Media storage

---

## Authentication

### JWT Token

All authenticated requests require a Bearer token in the Authorization header:

```
Authorization: Bearer {jwt_token}
```

The JWT is obtained from Supabase Auth and includes:
- `sub`: User ID (UUID)
- `aud`: "authenticated"
- `email`: User email
- `iat`: Issued at (timestamp)
- `exp`: Expiration (timestamp, default 1 hour)

### Device Binding

Every API call implicitly validates device binding via RLS policies:
- Supabase checks: `auth.uid()` = authenticated user
- Cloudflare Worker checks: JWT is valid
- Anti-piracy logic: stored `device_id` matches request origin

---

## Supabase API

Base URL: `https://xxx.supabase.co/rest/v1`

### Authentication Endpoints

#### Sign Up

```
POST /auth/v1/signup
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePassword123!"
}

Response:
{
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "app_metadata": {},
    "user_metadata": {}
  },
  "session": {
    "access_token": "jwt_token",
    "refresh_token": "refresh_token",
    "expires_in": 3600
  }
}
```

#### Sign In

```
POST /auth/v1/signin
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePassword123!"
}

Response: [Same as Sign Up]
```

#### Get Current User

```
GET /auth/v1/user
Authorization: Bearer {jwt_token}

Response:
{
  "id": "uuid",
  "email": "user@example.com",
  "email_confirmed_at": "2024-01-15T10:30:00Z",
  "phone": null,
  "confirmed_at": "2024-01-15T10:30:00Z",
  "last_sign_in_at": "2024-01-20T15:45:00Z",
  "app_metadata": {
    "provider": "email",
    "providers": ["email"]
  },
  "user_metadata": {},
  "identities": []
}
```

#### Sign Out

```
POST /auth/v1/logout
Authorization: Bearer {jwt_token}
Content-Type: application/json

{}

Response: 204 No Content
```

#### Refresh Token

```
POST /auth/v1/token?grant_type=refresh_token
Content-Type: application/json

{
  "refresh_token": "refresh_token"
}

Response: [New session object]
```

---

### Data Endpoints

#### List Courses

```
GET /courses
  ?limit=20
  &offset=0
  &order=created_at.desc

Authorization: Optional (public)

Response:
[
  {
    "id": "uuid",
    "title": "Volatility Forecasting with GARCH",
    "description": "Master GARCH(1,1) models...",
    "instructor": "Economicqsmaster",
    "category": "quantitative",
    "tier": "premium",
    "thumbnail_url": "https://drive.google.com/uc?id=...",
    "created_at": "2024-01-10T08:00:00Z",
    "updated_at": "2024-01-10T08:00:00Z"
  },
  ...
]
```

#### Get Course Details

```
GET /courses/{courseId}

Response:
{
  "id": "uuid",
  "title": "Volatility Forecasting with GARCH",
  "description": "Master GARCH(1,1) models...",
  "instructor": "Economicqsmaster",
  "category": "quantitative",
  "tier": "premium",
  "thumbnail_url": "https://drive.google.com/uc?id=...",
  "created_at": "2024-01-10T08:00:00Z",
  "updated_at": "2024-01-10T08:00:00Z"
}
```

#### List Videos in Course

```
GET /videos
  ?course_id=eq.{courseId}
  &order=sequence.asc
  &limit=100

Response:
[
  {
    "id": "uuid",
    "course_id": "uuid",
    "title": "Introduction to GARCH",
    "description": "Learn the fundamentals...",
    "google_drive_file_id": "drive_file_id_123",
    "sequence": 1,
    "duration": 15,
    "thumbnail_url": "...",
    "lecture_notes": "<latex>σ²ₜ = ω + α*ε²_{t-1} + β*σ²_{t-1}</latex>",
    "tier": "free",
    "created_at": "2024-01-10T08:00:00Z"
  },
  ...
]
```

#### Get Video Details

```
GET /videos/{videoId}

Response:
{
  "id": "uuid",
  "course_id": "uuid",
  "title": "Introduction to GARCH",
  "description": "Learn the fundamentals...",
  "google_drive_file_id": "drive_file_id_123",
  "sequence": 1,
  "duration": 15,
  "thumbnail_url": "...",
  "lecture_notes": "<latex>σ²ₜ = ...</latex>",
  "tier": "free",
  "created_at": "2024-01-10T08:00:00Z"
}
```

#### Get User Progress

```
GET /user_progress
  ?user_id=eq.{userId}
  &video_id=eq.{videoId}

Authorization: Bearer {jwt_token}

Response:
[
  {
    "id": "uuid",
    "user_id": "uuid",
    "video_id": "uuid",
    "current_position_seconds": 450,
    "total_watched_seconds": 600,
    "completed": false,
    "completed_at": null,
    "created_at": "2024-01-20T10:00:00Z",
    "updated_at": "2024-01-20T15:30:00Z"
  }
]
```

#### Update Progress

```
PATCH /user_progress/{progressId}
Authorization: Bearer {jwt_token}
Content-Type: application/json

{
  "current_position_seconds": 600,
  "total_watched_seconds": 900,
  "completed": true,
  "completed_at": "2024-01-20T16:00:00Z"
}

Response: [Updated progress object]
```

#### Insert Progress Record

```
POST /user_progress
Authorization: Bearer {jwt_token}
Content-Type: application/json

{
  "user_id": "uuid",
  "video_id": "uuid",
  "current_position_seconds": 0,
  "total_watched_seconds": 0,
  "completed": false
}

Response: [New progress object]
```

---

## Cloudflare Worker API

Base URL: `https://media-vault.economicqsmaster.com`

### Media Proxy

Streams video from Google Drive with authentication and CORS support.

#### Request

```
GET /proxy
  ?fileId={google_drive_file_id}
  &jwt={supabase_jwt_token}

Headers:
  Authorization: Bearer {supabase_jwt_token}
  Range: bytes={start}-{end}  (optional)
  Origin: app://economicqsmaster.com
  Referer: app://economicqsmaster.com

Example:
GET /proxy?fileId=1a2b3c4d5e&jwt=eyJhbGc... HTTP/1.1
Authorization: Bearer eyJhbGc...
Range: bytes=0-1048575
Origin: app://economicqsmaster.com
```

#### Successful Response (Full)

```
HTTP/1.1 200 OK
Content-Type: video/mp4
Content-Length: 52428800
Accept-Ranges: bytes
Access-Control-Allow-Origin: app://economicqsmaster.com
Access-Control-Allow-Methods: GET, HEAD, OPTIONS
Access-Control-Allow-Headers: Authorization, Range, Content-Type
Access-Control-Max-Age: 86400
Cache-Control: public, max-age=3600

[Video binary data: 52MB]
```

#### Successful Response (Partial - Byte Range)

```
HTTP/1.1 206 Partial Content
Content-Type: video/mp4
Content-Range: bytes 0-1048575/52428800
Content-Length: 1048576
Accept-Ranges: bytes
Access-Control-Allow-Origin: app://economicqsmaster.com

[Video chunk: 1MB]
```

#### Error Response (Invalid JWT)

```
HTTP/1.1 401 Unauthorized
Content-Type: application/json
Access-Control-Allow-Origin: app://economicqsmaster.com

{
  "error": "Invalid JWT"
}
```

#### Error Response (Missing Parameters)

```
HTTP/1.1 400 Bad Request
Content-Type: application/json
Access-Control-Allow-Origin: app://economicqsmaster.com

{
  "error": "Missing fileId or jwt"
}
```

#### Error Response (Server Error)

```
HTTP/1.1 500 Internal Server Error
Content-Type: application/json
Access-Control-Allow-Origin: app://economicqsmaster.com

{
  "error": "Internal server error"
}
```

---

## Google Drive API

Base URL: `https://www.googleapis.com/drive/v3`

### Get File Metadata

```
GET /files/{fileId}
  ?fields=name,mimeType,size,modifiedTime

Authorization: Bearer {google_access_token}

Response:
{
  "kind": "drive#file",
  "id": "1a2b3c4d5e",
  "name": "garch-intro.mp4",
  "mimeType": "video/mp4",
  "size": "52428800",
  "modifiedTime": "2024-01-15T10:30:00Z"
}
```

### Download File

```
GET /files/{fileId}?alt=media

Authorization: Bearer {google_access_token}
Range: bytes={start}-{end}  (optional)

Response:
[Binary video data]
```

---

## Error Codes

| Code | Meaning | Action |
|------|---------|--------|
| 200 | OK | Success |
| 206 | Partial Content | Byte-range request successful (streaming) |
| 201 | Created | Resource created |
| 204 | No Content | Success (no body) |
| 400 | Bad Request | Invalid parameters; check request |
| 401 | Unauthorized | Invalid/expired JWT; re-authenticate |
| 403 | Forbidden | Device binding failed; log out and re-auth |
| 404 | Not Found | Resource doesn't exist |
| 429 | Too Many Requests | Rate limited; wait and retry |
| 500 | Internal Server Error | Server error; contact support |
| 503 | Service Unavailable | Service down; retry later |

---

## Rate Limits

| Endpoint | Limit | Window |
|----------|-------|--------|
| Auth endpoints | 100 requests | 15 minutes |
| Course listing | 500 requests | 1 hour |
| Video download | No limit (CDN) | N/A |
| Media proxy | 1000 requests | 1 hour |

---

## Examples

### Flutter: Fetch Courses

```dart
import 'package:dio/dio.dart';

final dio = Dio();

// Add JWT interceptor
dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      options.headers['Authorization'] = 'Bearer $jwt';
      return handler.next(options);
    },
  ),
);

// Fetch courses
final response = await dio.get(
  'https://xxx.supabase.co/rest/v1/courses',
  queryParameters: {'limit': 20, 'order': 'created_at.desc'},
);

List<Map> courses = response.data;
```

### Flutter: Stream Video

```dart
final videoUrl = 'https://media-vault.economicqsmaster.com/proxy'
    '?fileId=$driveFileId'
    '&jwt=$jwtToken';

BetterPlayerDataSource dataSource = BetterPlayerDataSource(
  BetterPlayerDataSourceType.network,
  videoUrl,
  headers: {
    'Authorization': 'Bearer $jwtToken',
    'Range': 'bytes=0-1048575',  // Seek example
  },
);

betterPlayerController.setupDataSource(dataSource);
```

### Dart: Update Progress

```dart
await dio.patch(
  'https://xxx.supabase.co/rest/v1/user_progress/$progressId',
  data: {
    'current_position_seconds': 450,
    'total_watched_seconds': 600,
    'completed': false,
  },
  options: Options(
    headers: {'Authorization': 'Bearer $jwt'},
  ),
);
```

---

## Best Practices

### 1. Token Management
- ✅ Store tokens securely (encrypted storage)
- ✅ Refresh tokens before expiry
- ✅ Clear tokens on logout
- ❌ Don't log tokens to console

### 2. Error Handling
- ✅ Retry on 5xx errors
- ✅ Refresh token on 401
- ✅ Show user-friendly messages
- ❌ Don't expose raw API errors

### 3. Caching
- ✅ Cache course/video metadata locally
- ✅ Resume interrupted downloads
- ✅ Use etags for cache validation
- ❌ Don't cache authenticated responses

### 4. Security
- ✅ Use HTTPS only
- ✅ Validate SSL certificates
- ✅ Clear cache on logout
- ✅ Check device binding errors
- ❌ Don't hardcode credentials

---

**Refer to individual service documentation for more details:**
- Supabase: https://supabase.io/docs
- Cloudflare Workers: https://developers.cloudflare.com/workers
- Google Drive API: https://developers.google.com/drive/api
