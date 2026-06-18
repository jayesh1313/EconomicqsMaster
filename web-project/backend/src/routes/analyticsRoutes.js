import express from 'express'
import { authMiddleware } from '../middleware/authMiddleware.js'

const router = express.Router()

// Get analytics data
router.get('/', authMiddleware, (req, res) => {
  res.json({
    success: true,
    data: {
      totalVisitors: 18340,
      totalRevenue: 26908,
      conversionRate: 3.42,
      growthVisitors: 12.5,
      growthRevenue: 8.3,
      growthConversion: 2.1,
    },
  })
})

// Get analytics by type
router.get('/:type', authMiddleware, (req, res) => {
  const { type } = req.params

  const analyticsData = {
    visitors: [
      { name: 'Jan', value: 4000 },
      { name: 'Feb', value: 3000 },
      { name: 'Mar', value: 2000 },
      { name: 'Apr', value: 2780 },
      { name: 'May', value: 1890 },
      { name: 'Jun', value: 2390 },
    ],
    traffic: [
      { name: 'Organic', value: 45 },
      { name: 'Direct', value: 25 },
      { name: 'Referral', value: 20 },
      { name: 'Paid', value: 10 },
    ],
    devices: [
      { name: 'Desktop', value: 55 },
      { name: 'Mobile', value: 35 },
      { name: 'Tablet', value: 10 },
    ],
  }

  const data = analyticsData[type] || analyticsData.visitors

  res.json({
    success: true,
    data,
  })
})

export default router
