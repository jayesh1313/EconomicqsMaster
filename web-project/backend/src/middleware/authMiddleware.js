import jwt from 'jsonwebtoken'
import config from '../config/index.js'

export const authMiddleware = (req, res, next) => {
  try {
    const token = req.headers.authorization?.split(' ')[1]

    if (!token) {
      return res.status(401).json({
        success: false,
        error: 'No token provided',
      })
    }

    const decoded = jwt.verify(token, config.jwtSecret)
    req.user = decoded
    next()
  } catch (error) {
    res.status(401).json({
      success: false,
      error: 'Invalid or expired token',
    })
  }
}

export const optionalAuth = (req, res, next) => {
  try {
    const token = req.headers.authorization?.split(' ')[1]
    if (token) {
      const decoded = jwt.verify(token, config.jwtSecret)
      req.user = decoded
    }
  } catch (error) {
    console.log('Optional auth skipped:', error.message)
  }
  next()
}
