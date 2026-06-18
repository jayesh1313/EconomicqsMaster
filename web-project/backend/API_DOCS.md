# API Documentation

## Base URL
```
http://localhost:5000/api
```

## Authentication
All endpoints (except login/register) require JWT token in header:
```
Authorization: Bearer <token>
```

## Endpoints

### Dashboard

#### Get Dashboard Stats
```
GET /dashboard/stats
```
Returns overview statistics including revenue, users, orders, growth.

### Analytics

#### Get Analytics Overview
```
GET /analytics
```
Returns total visitors, revenue, conversion rate and growth metrics.

#### Get Analytics by Type
```
GET /analytics/:type
```
Types: `visitors`, `traffic`, `devices`

### Users

#### Get All Users
```
GET /users?page=1&limit=10
```

#### Get User by ID
```
GET /users/:id
```

#### Create User
```
POST /users
Body: { name, email, role }
```

#### Update User
```
PUT /users/:id
Body: { name, email, role, status }
```

#### Delete User
```
DELETE /users/:id
```

### Authentication

#### Login
```
POST /auth/login
Body: { email, password }
Response: { token, user }
```

#### Register
```
POST /auth/register
Body: { email, password, name }
Response: { token, user }
```

#### Logout
```
POST /auth/logout
```

### Settings

#### Get Settings
```
GET /settings
```

#### Update Settings
```
PUT /settings
Body: { ... setting updates }
```

#### Get Specific Setting
```
GET /settings/:key
```

## Response Format

### Success Response
```json
{
  "success": true,
  "data": { ... }
}
```

### Error Response
```json
{
  "success": false,
  "error": "Error message"
}
```

## Status Codes
- 200: OK
- 201: Created
- 400: Bad Request
- 401: Unauthorized
- 404: Not Found
- 500: Internal Server Error
