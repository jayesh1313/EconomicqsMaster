# Installation & Setup Guide

## System Requirements

- **Node.js**: v18 or higher
- **npm**: v9 or higher (or yarn)
- **Browser**: Modern browser (Chrome, Firefox, Safari, Edge)

## Project Initialization

### Step 1: Install Backend Dependencies

```bash
cd web-project/backend
npm install
```

**Expected output:**
```
added XX packages in Xs
```

### Step 2: Install Frontend Dependencies

```bash
cd ../frontend
npm install
```

**Expected output:**
```
added XX packages in Xs
```

## Configuration

### Backend Configuration

1. Navigate to backend folder:
```bash
cd backend
```

2. Create `.env` file from template:
```bash
cp .env.example .env
```

3. Update `.env` with your settings:
```env
PORT=5000
NODE_ENV=development
MONGODB_URI=mongodb://localhost:27017/web-project
JWT_SECRET=your_super_secret_key_change_this
CORS_ORIGIN=http://localhost:5173
```

### Frontend Configuration

1. Navigate to frontend folder:
```bash
cd ../frontend
```

2. Create `.env` file from template:
```bash
cp .env.example .env
```

3. Update `.env` with backend URL:
```env
VITE_API_URL=http://localhost:5000/api
VITE_APP_NAME=Web Project
```

## Running the Application

### Option 1: Two Terminal Windows (Recommended)

**Terminal 1 - Backend:**
```bash
cd web-project/backend
npm run dev
```

Expected output:
```
🚀 Server running on port 5000
📡 Environment: development
```

**Terminal 2 - Frontend:**
```bash
cd web-project/frontend
npm run dev
```

Expected output:
```
  VITE v5.0.8  ready in 234 ms

  ➜  Local:   http://localhost:5173/
```

### Option 2: Single Terminal (Concurrently)

Install concurrently globally (optional):
```bash
npm install -g concurrently
```

From root directory:
```bash
concurrently "cd backend && npm run dev" "cd frontend && npm run dev"
```

## Accessing the Application

1. Open browser: `http://localhost:5173`
2. You should see the Dashboard page
3. Navigate using the sidebar

## Verification Checklist

- [ ] Backend running on http://localhost:5000
- [ ] Frontend running on http://localhost:5173
- [ ] Dashboard page loads without errors
- [ ] All stat cards display correctly
- [ ] Charts render without console errors
- [ ] Sidebar navigation works
- [ ] API calls show in network tab

## Troubleshooting

### Port Already in Use
```bash
# Kill process on port 5000
lsof -ti:5000 | xargs kill -9

# Or change port in .env
PORT=5001
```

### Module Not Found
```bash
# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm install
```

### CORS Error
- Check that `CORS_ORIGIN` in backend `.env` matches frontend URL
- Verify both apps are running on specified ports

### Dependencies Issues
```bash
# Update dependencies
npm update

# Or check compatibility
npm audit fix
```

## Build for Production

### Frontend Build
```bash
cd frontend
npm run build
```

Output in: `frontend/dist/`

### Backend Deployment
Ready to deploy to:
- Heroku
- AWS
- Google Cloud
- DigitalOcean
- Railway
- Vercel (with serverless adapters)

## Development Tools

### Frontend
- **Vite**: Fast build tool
- **React Router**: Client-side routing
- **Tailwind CSS**: Styling
- **Axios**: HTTP client
- **Recharts**: Charts library
- **Lucide React**: Icons

### Backend
- **Express**: Web framework
- **JWT**: Authentication
- **Bcrypt**: Password hashing
- **Helmet**: Security
- **Morgan**: Logging
- **CORS**: Cross-origin support

## Next Steps

1. **Database Setup**: Install MongoDB and connect
2. **Environment Variables**: Update secrets for production
3. **Authentication**: Implement login/register fully
4. **Database Models**: Create Mongoose schemas
5. **API Integration**: Connect all endpoints to database
6. **Deployment**: Deploy to production servers

## Support & Documentation

- Frontend docs: See [frontend/README.md](./frontend/README.md)
- Backend docs: See [backend/README.md](./backend/README.md)
- API docs: See [backend/API_DOCS.md](./backend/API_DOCS.md)
- Components: See [COMPONENTS.md](./COMPONENTS.md)
- Graphics: See [GRAPHICS.md](./GRAPHICS.md)
- Quick Start: See [QUICKSTART.md](./QUICKSTART.md)

## Project Structure

```
web-project/
├── frontend/
│   ├── src/
│   │   ├── components/     (UI components)
│   │   ├── pages/          (Page components)
│   │   ├── services/       (API services)
│   │   ├── hooks/          (Custom hooks)
│   │   ├── utils/          (Utilities)
│   │   ├── styles/         (CSS)
│   │   ├── assets/         (Images/graphics)
│   │   └── App.jsx
│   ├── package.json
│   └── vite.config.js
│
├── backend/
│   ├── src/
│   │   ├── routes/         (API routes)
│   │   ├── middleware/     (Middleware)
│   │   ├── config/         (Configuration)
│   │   ├── utils/          (Utilities)
│   │   └── server.js
│   ├── package.json
│   └── .env.example
│
├── README.md
├── QUICKSTART.md
├── COMPONENTS.md
├── GRAPHICS.md
└── INSTALLATION.md
```

## Common Commands

```bash
# Start development
npm run dev

# Build for production
npm run build

# Preview build
npm run preview

# Run linter
npm run lint

# Run tests
npm run test
```

Enjoy building! 🚀
