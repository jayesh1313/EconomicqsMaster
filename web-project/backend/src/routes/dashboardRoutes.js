import express from 'express'
import { authMiddleware } from '../middleware/authMiddleware.js'

const router = express.Router()

// Dashboard stats
router.get('/stats', authMiddleware, (req, res) => {
  res.json({
    success: true,
    data: {
      revenue: 45230,
      users: 1250,
      orders: 320,
      growth: 12.5,
    },
  })
})

// Dashboard charts data
router.get('/charts', authMiddleware, (req, res) => {
  res.json({
    success: true,
    data: {
      weeklyTrend: [
        { name: 'Mon', value: 400 },
        { name: 'Tue', value: 300 },
        { name: 'Wed', value: 200 },
        { name: 'Thu', value: 278 },
        { name: 'Fri', value: 190 },
        { name: 'Sat', value: 229 },
        { name: 'Sun', value: 200 },
      ],
      monthlyPerformance: [
        { name: 'Jan', value: 4000 },
        { name: 'Feb', value: 3000 },
        { name: 'Mar', value: 2000 },
        { name: 'Apr', value: 2780 },
        { name: 'May', value: 1890 },
        { name: 'Jun', value: 2390 },
      ],
    },
  })
})

export default router
