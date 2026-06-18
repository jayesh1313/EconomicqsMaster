import { BarChart3, Users, TrendingUp, Activity } from 'lucide-react'
import { useState, useEffect } from 'react'
import StatCard from '../components/StatCard'
import Card from '../components/Card'
import { LineChartComponent, BarChartComponent, PieChartComponent } from '../components/ChartComponent'

const Dashboard = () => {
  const [stats, setStats] = useState({
    revenue: 45230,
    users: 1250,
    orders: 320,
    activities: 89
  })

  const lineChartData = [
    { name: 'Mon', value: 400 },
    { name: 'Tue', value: 300 },
    { name: 'Wed', value: 200 },
    { name: 'Thu', value: 278 },
    { name: 'Fri', value: 190 },
    { name: 'Sat', value: 229 },
    { name: 'Sun', value: 200 },
  ]

  const barChartData = [
    { name: 'Jan', value: 4000 },
    { name: 'Feb', value: 3000 },
    { name: 'Mar', value: 2000 },
    { name: 'Apr', value: 2780 },
    { name: 'May', value: 1890 },
    { name: 'Jun', value: 2390 },
  ]

  const pieChartData = [
    { name: 'Product A', value: 35 },
    { name: 'Product B', value: 25 },
    { name: 'Product C', value: 20 },
    { name: 'Product D', value: 20 },
  ]

  return (
    <div className="p-8 bg-gray-100 min-h-screen">
      {/* Header */}
      <div className="mb-8">
        <h1 className="text-4xl font-bold text-gray-800 mb-2">Dashboard</h1>
        <p className="text-gray-600">Welcome back! Here's your dashboard overview.</p>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <StatCard title="Total Revenue" value={`$${stats.revenue.toLocaleString()}`} change="+12.5" icon={TrendingUp} trend="up" />
        <StatCard title="Active Users" value={stats.users.toLocaleString()} change="+8.2" icon={Users} trend="up" />
        <StatCard title="Total Orders" value={stats.orders} change="+5.3" icon={BarChart3} trend="up" />
        <StatCard title="Activities" value={stats.activities} change="-2.1" icon={Activity} trend="down" />
      </div>

      {/* Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
        <LineChartComponent data={lineChartData} title="Weekly Trend" />
        <BarChartComponent data={barChartData} title="Monthly Performance" />
      </div>

      {/* Additional Info */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2">
          <Card title="Recent Activities" icon={Activity}>
            <div className="space-y-4">
              {[1, 2, 3, 4, 5].map((i) => (
                <div key={i} className="flex items-center justify-between py-3 border-b border-gray-200 last:border-0">
                  <div>
                    <p className="font-medium text-gray-800">Activity #{i}</p>
                    <p className="text-sm text-gray-500">2 hours ago</p>
                  </div>
                  <div className="w-3 h-3 bg-green-500 rounded-full"></div>
                </div>
              ))}
            </div>
          </Card>
        </div>

        <div>
          <Card title="Product Distribution">
            <PieChartComponent data={pieChartData} title="" />
          </Card>
        </div>
      </div>
    </div>
  )
}

export default Dashboard
