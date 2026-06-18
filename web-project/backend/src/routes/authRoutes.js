import express from 'express'
import jwt from 'jsonwebtoken'
import bcrypt from 'bcryptjs'
import config from '../config/index.js'

const router = express.Router()

// Mock user database (in production, use MongoDB)
const users = [
  {
    id: '1',
    email: 'admin@example.com',
    password: await bcrypt.hash('password123', 10),
    name: 'Admin User',
    role: 'admin',
  },
]

// Login
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        error: 'Email and password are required',
      })
    }

    const user = users.find((u) => u.email === email)

    if (!user) {
      return res.status(401).json({
        success: false,
        error: 'Invalid credentials',
      })
    }

    const isPasswordValid = await bcrypt.compare(password, user.password)

    if (!isPasswordValid) {
      return res.status(401).json({
        success: false,
        error: 'Invalid credentials',
      })
    }

    const token = jwt.sign(
      { id: user.id, email: user.email, role: user.role },
      config.jwtSecret,
      { expiresIn: '24h' }
    )

    res.json({
      success: true,
      data: {
        token,
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          role: user.role,
        },
      },
    })
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message,
    })
  }
})

// Register
router.post('/register', async (req, res) => {
  try {
    const { email, password, name } = req.body

    if (!email || !password || !name) {
      return res.status(400).json({
        success: false,
        error: 'Email, password, and name are required',
      })
    }

    if (users.find((u) => u.email === email)) {
      return res.status(400).json({
        success: false,
        error: 'User already exists',
      })
    }

    const hashedPassword = await bcrypt.hash(password, 10)
    const newUser = {
      id: String(Date.now()),
      email,
      password: hashedPassword,
      name,
      role: 'user',
    }

    users.push(newUser)

    const token = jwt.sign(
      { id: newUser.id, email: newUser.email, role: newUser.role },
      config.jwtSecret,
      { expiresIn: '24h' }
    )

    res.status(201).json({
      success: true,
      data: {
        token,
        user: {
          id: newUser.id,
          email: newUser.email,
          name: newUser.name,
          role: newUser.role,
        },
      },
    })
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message,
    })
  }
})

// Logout
router.post('/logout', (req, res) => {
  res.json({
    success: true,
    message: 'Logged out successfully',
  })
})

export default router
