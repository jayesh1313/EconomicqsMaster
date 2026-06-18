# Quick Start Guide for Web Project

## Prerequisites
- Node.js 18+ installed
- npm or yarn package manager
- MongoDB (optional, for database)

## Quick Setup (5 minutes)

### 1. Backend Setup
```bash
cd web-project/backend

# Install dependencies
npm install

# Create .env file
cp .env.example .env

# Start development server
npm run dev
```

Backend runs on: `http://localhost:5000`

### 2. Frontend Setup (in new terminal)
```bash
cd web-project/frontend

# Install dependencies
npm install

# Create .env file
cp .env.example .env

# Start development server
npm run dev
```

Frontend runs on: `http://localhost:5173`

## Testing the Application

1. Open browser: `http://localhost:5173`
2. You should see the Dashboard with:
   - Stat cards showing metrics
   - Line chart with weekly trends
   - Bar chart with monthly performance
   - Pie chart with product distribution

## Available Routes

### Frontend Routes
- `/` - Dashboard
- `/analytics` - Analytics page
- `/users` - Users management
- `/settings` - Settings page

### Backend Routes
- `GET /health` - Health check
- `GET /api/dashboard/stats` - Dashboard statistics
- `GET /api/dashboard/charts` - Chart data
- `GET /api/users` - Get all users
- `POST /api/auth/login` - Login endpoint

## Features Ready to Use

✅ Dashboard with stats and charts
✅ User management interface
✅ Analytics dashboard
✅ Settings page
✅ Responsive design
✅ API integration setup
✅ Authentication framework
✅ Modern UI components

## Next Steps

1. **Connect to MongoDB**: Update `.env` with MongoDB URI
2. **Setup Authentication**: Implement login/register
3. **Add Database Models**: Create Mongoose schemas
4. **Deploy**: Use Vercel (frontend) + Heroku/AWS (backend)

## Troubleshooting

**Port Already in Use?**
```bash
# Change port in .env file
PORT=5001  # or another available port
```

**Module Not Found?**
```bash
# Reinstall dependencies
rm -rf node_modules
npm install
```

**CORS Error?**
Check that both apps use correct URLs in `.env` files.

## Project Structure

```
web-project/
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── services/
│   │   └── App.jsx
│   └── package.json
│
└── backend/
    ├── src/
    │   ├── routes/
    │   ├── middleware/
    │   └── server.js
    └── package.json
```

## Support

For detailed documentation, see:
- Frontend: `README.md` in frontend folder
- Backend: `README.md` in backend folder
- Main: Root `README.md`
