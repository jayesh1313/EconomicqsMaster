# Web Project - Full Stack Application

A modern web application with React frontend and Node.js backend.

## Project Structure

```
web-project/
├── frontend/          # React.js frontend application
│   ├── src/
│   │   ├── components/     # Reusable UI components
│   │   ├── pages/         # Page components
│   │   ├── services/      # API services
│   │   ├── styles/        # CSS and styling
│   │   ├── assets/        # Images and graphics
│   │   └── hooks/         # Custom React hooks
│   ├── public/           # Static files
│   ├── package.json
│   └── vite.config.js    # Vite configuration
│
└── backend/           # Node.js/Express backend
    ├── src/
    │   ├── routes/        # API routes
    │   ├── controllers/   # Route handlers
    │   ├── models/        # Data models
    │   ├── middleware/    # Express middleware
    │   ├── config/        # Configuration
    │   └── server.js      # Entry point
    ├── package.json
    └── .env.example
```

## Getting Started

### Frontend Setup

1. Navigate to frontend directory:
```bash
cd frontend
```

2. Install dependencies:
```bash
npm install
```

3. Create `.env` file:
```bash
cp .env.example .env
```

4. Start development server:
```bash
npm run dev
```

Frontend will be available at `http://localhost:5173`

### Backend Setup

1. Navigate to backend directory:
```bash
cd backend
```

2. Install dependencies:
```bash
npm install
```

3. Create `.env` file:
```bash
cp .env.example .env
```

4. Start development server:
```bash
npm run dev
```

Backend will be available at `http://localhost:5000`

## Features

### Frontend
- 🎨 Modern UI with Tailwind CSS
- 📊 Interactive charts with Recharts
- 🔐 Authentication & JWT
- 📱 Responsive design
- ⚡ Fast with Vite
- 🎯 React Router navigation
- 💻 Reusable components
- 🎭 Dark mode ready

### Backend
- 🚀 Express.js REST API
- 🔐 JWT Authentication
- 📊 Dashboard endpoints
- 📈 Analytics APIs
- 👥 User management
- ⚙️ Settings management
- 🛡️ Security with Helmet
- 📝 Logging with Morgan

## Pages

### Frontend Pages
- **Dashboard** - Overview with stats and charts
- **Analytics** - Detailed analytics and metrics
- **Users** - User management interface
- **Settings** - Application settings

### Components
- Navbar with user menu
- Sidebar navigation
- Stat cards with trends
- Chart components (Line, Bar, Pie)
- Data tables
- Form components

## Technologies Used

### Frontend
- React 18.3
- Vite 5.0
- Tailwind CSS 3.4
- React Router 6.20
- Recharts 2.10 (charts)
- Lucide React (icons)
- Axios (HTTP client)

### Backend
- Node.js
- Express 4.18
- MongoDB (optional)
- JWT for authentication
- Bcrypt for password hashing
- Helmet for security
- CORS support

## API Documentation

See [backend README](./backend/README.md) for detailed API documentation.

## Development

### Frontend Development
```bash
cd frontend
npm run dev
```

### Backend Development
```bash
cd backend
npm run dev
```

### Build for Production

Frontend:
```bash
cd frontend
npm run build
```

Backend: Deploy using `npm start`

## Graphics & Design

The application includes:
- Gradient backgrounds
- Chart visualizations
- Status indicators
- Color-coded badges
- Icon library (Lucide)
- Smooth animations
- Responsive grid layouts

## License

MIT
