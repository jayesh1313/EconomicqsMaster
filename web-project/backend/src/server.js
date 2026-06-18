import express from 'express'
import cors from 'cors'
import helmet from 'helmet'
import morgan from 'morgan'
import 'express-async-errors'
import path from 'path'
import { fileURLToPath } from 'url'
import config from './config/index.js'
import { errorHandler, notFound } from './middleware/errorHandler.js'
import dashboardRoutes from './routes/dashboardRoutes.js'
import analyticsRoutes from './routes/analyticsRoutes.js'
import usersRoutes from './routes/usersRoutes.js'
import authRoutes from './routes/authRoutes.js'
import settingsRoutes from './routes/settingsRoutes.js'

const app = express()

// Middleware
app.use(helmet())
app.use(cors({
  origin: config.corsOrigin,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}))
app.use(morgan('dev'))
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

// API Routes
app.use('/api/dashboard', dashboardRoutes)
app.use('/api/analytics', analyticsRoutes)
app.use('/api/users', usersRoutes)
app.use('/api/auth', authRoutes)
app.use('/api/settings', settingsRoutes)

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date() })
})

// 404 handler
app.use(notFound)

// Error handler
app.use(errorHandler)

// Start server
const PORT = config.port
const currentFilePath = fileURLToPath(import.meta.url)
const executedFilePath = process.argv[1] ? path.resolve(process.argv[1]) : ''
const shouldStartServer = currentFilePath === executedFilePath

if (shouldStartServer) {
  app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`)
    console.log(`📡 Environment: ${config.nodeEnv}`)
  })
}

export default app
