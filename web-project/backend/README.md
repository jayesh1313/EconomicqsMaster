# Web Project Backend

Node.js/Express backend API for the web project application.

## Features

- ✅ RESTful API
- ✅ JWT Authentication
- ✅ CORS Support
- ✅ Error Handling
- ✅ Environment Configuration
- ✅ Dashboard APIs
- ✅ Analytics APIs
- ✅ User Management
- ✅ Settings Management

## Installation

```bash
npm install
```

## Configuration

Create a `.env` file in the backend directory:

```env
PORT=5000
NODE_ENV=development
MONGODB_URI=mongodb://localhost:27017/web-project
JWT_SECRET=your_jwt_secret_key_here
CORS_ORIGIN=http://localhost:5173
```

## Running

Development:
```bash
npm run dev
```

Production:
```bash
npm start
```

## API Endpoints

### Dashboard
- `GET /api/dashboard/stats` - Get dashboard statistics
- `GET /api/dashboard/charts` - Get chart data

### Analytics
- `GET /api/analytics` - Get analytics overview
- `GET /api/analytics/:type` - Get analytics by type

### Users
- `GET /api/users` - Get all users
- `GET /api/users/:id` - Get user by ID
- `POST /api/users` - Create user
- `PUT /api/users/:id` - Update user
- `DELETE /api/users/:id` - Delete user

### Authentication
- `POST /api/auth/login` - Login
- `POST /api/auth/register` - Register
- `POST /api/auth/logout` - Logout

### Settings
- `GET /api/settings` - Get all settings
- `GET /api/settings/:key` - Get specific setting
- `PUT /api/settings` - Update settings

## Project Structure

```
backend/
├── src/
│   ├── config/          # Configuration files
│   ├── routes/          # API routes
│   ├── controllers/     # Route controllers
│   ├── models/          # Data models
│   ├── middleware/      # Express middleware
│   ├── utils/           # Utility functions
│   └── server.js        # Entry point
├── package.json
├── .env.example
└── README.md
```
