import express from 'express'
import { authMiddleware } from '../middleware/authMiddleware.js'

const router = express.Router()

// Mock users database (in production, use MongoDB)
let mockUsers = [
  { id: '1', name: 'John Doe', email: 'john@example.com', role: 'Admin', status: 'Active', joined: '2024-01-15' },
  { id: '2', name: 'Jane Smith', email: 'jane@example.com', role: 'User', status: 'Active', joined: '2024-02-20' },
  { id: '3', name: 'Bob Johnson', email: 'bob@example.com', role: 'User', status: 'Inactive', joined: '2024-03-10' },
  { id: '4', name: 'Alice Williams', email: 'alice@example.com', role: 'Moderator', status: 'Active', joined: '2024-04-05' },
  { id: '5', name: 'Charlie Brown', email: 'charlie@example.com', role: 'User', status: 'Active', joined: '2024-04-25' },
]

// Get all users
router.get('/', authMiddleware, (req, res) => {
  const { page = 1, limit = 10 } = req.query
  const start = (page - 1) * limit
  const end = start + limit

  res.json({
    success: true,
    data: {
      users: mockUsers.slice(start, end),
      total: mockUsers.length,
      page: parseInt(page),
      limit: parseInt(limit),
    },
  })
})

// Get user by ID
router.get('/:id', authMiddleware, (req, res) => {
  const user = mockUsers.find((u) => u.id === req.params.id)

  if (!user) {
    return res.status(404).json({
      success: false,
      error: 'User not found',
    })
  }

  res.json({
    success: true,
    data: user,
  })
})

// Create user
router.post('/', authMiddleware, (req, res) => {
  const { name, email, role } = req.body

  if (!name || !email) {
    return res.status(400).json({
      success: false,
      error: 'Name and email are required',
    })
  }

  const newUser = {
    id: String(Date.now()),
    name,
    email,
    role: role || 'User',
    status: 'Active',
    joined: new Date().toISOString().split('T')[0],
  }

  mockUsers.push(newUser)

  res.status(201).json({
    success: true,
    data: newUser,
  })
})

// Update user
router.put('/:id', authMiddleware, (req, res) => {
  const user = mockUsers.find((u) => u.id === req.params.id)

  if (!user) {
    return res.status(404).json({
      success: false,
      error: 'User not found',
    })
  }

  Object.assign(user, req.body)

  res.json({
    success: true,
    data: user,
  })
})

// Delete user
router.delete('/:id', authMiddleware, (req, res) => {
  const index = mockUsers.findIndex((u) => u.id === req.params.id)

  if (index === -1) {
    return res.status(404).json({
      success: false,
      error: 'User not found',
    })
  }

  const deletedUser = mockUsers.splice(index, 1)[0]

  res.json({
    success: true,
    data: deletedUser,
    message: 'User deleted successfully',
  })
})

export default router
