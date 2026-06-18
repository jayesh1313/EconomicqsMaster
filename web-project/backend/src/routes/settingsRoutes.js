import express from 'express'
import { authMiddleware } from '../middleware/authMiddleware.js'

const router = express.Router()

// Mock settings (in production, use MongoDB)
let appSettings = {
  appName: 'Web Project',
  theme: 'light',
  notifications: true,
  emailNotifications: true,
  twoFactor: false,
  language: 'en',
  timezone: 'UTC',
}

// Get settings
router.get('/', authMiddleware, (req, res) => {
  res.json({
    success: true,
    data: appSettings,
  })
})

// Update settings
router.put('/', authMiddleware, (req, res) => {
  appSettings = { ...appSettings, ...req.body }

  res.json({
    success: true,
    data: appSettings,
    message: 'Settings updated successfully',
  })
})

// Get specific setting
router.get('/:key', authMiddleware, (req, res) => {
  const { key } = req.params
  const value = appSettings[key]

  if (value === undefined) {
    return res.status(404).json({
      success: false,
      error: 'Setting not found',
    })
  }

  res.json({
    success: true,
    data: { [key]: value },
  })
})

export default router
