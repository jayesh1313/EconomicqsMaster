// Sample data for development testing

export const sampleDashboardData = {
  stats: {
    revenue: 45230,
    users: 1250,
    orders: 320,
    growth: 12.5,
  },
  charts: {
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
}

export const sampleUsers = [
  { id: '1', name: 'John Doe', email: 'john@example.com', role: 'Admin', status: 'Active' },
  { id: '2', name: 'Jane Smith', email: 'jane@example.com', role: 'User', status: 'Active' },
  { id: '3', name: 'Bob Johnson', email: 'bob@example.com', role: 'User', status: 'Inactive' },
]

export const sampleAnalytics = {
  visitors: [
    { name: 'Jan', value: 4000 },
    { name: 'Feb', value: 3000 },
    { name: 'Mar', value: 2000 },
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
