import { BarChart3, Calendar } from 'lucide-react'
import { LineChartComponent, BarChartComponent, PieChartComponent } from '../components/ChartComponent'
import Card from '../components/Card'

const Analytics = () => {
  const analyticsData = [
    { name: 'Jan', visitors: 4000, revenue: 2400, conversions: 240 },
    { name: 'Feb', visitors: 3000, revenue: 1398, conversions: 221 },
    { name: 'Mar', visitors: 2000, revenue: 9800, conversions: 229 },
    { name: 'Apr', visitors: 2780, revenue: 3908, conversions: 200 },
    { name: 'May', visitors: 1890, revenue: 4800, conversions: 221 },
    { name: 'Jun', visitors: 2390, revenue: 3800, conversions: 250 },
  ]

  const channelData = [
    { name: 'Organic', value: 45 },
    { name: 'Direct', value: 25 },
    { name: 'Referral', value: 20 },
    { name: 'Paid', value: 10 },
  ]

  const deviceData = [
    { name: 'Desktop', value: 55 },
    { name: 'Mobile', value: 35 },
    { name: 'Tablet', value: 10 },
  ]

  return (
    <div className="p-8 bg-gray-100 min-h-screen">
      {/* Header */}
      <div className="mb-8">
        <div className="flex justify-between items-center">
          <div>
            <h1 className="text-4xl font-bold text-gray-800 mb-2">Analytics</h1>
            <p className="text-gray-600">Detailed analytics and performance metrics</p>
          </div>
          <button className="flex items-center gap-2 bg-white text-gray-700 px-6 py-3 rounded-lg shadow-md hover:shadow-lg transition">
            <Calendar size={20} />
            <span>Last 30 Days</span>
          </button>
        </div>
      </div>

      {/* Charts */}
      <div className="grid grid-cols-1 gap-6 mb-8">
        <div className="bg-white rounded-lg shadow-md p-6">
          <h3 className="text-lg font-semibold text-gray-800 mb-4">Performance Metrics</h3>
          <div className="grid grid-cols-3 gap-4 mb-6">
            <div className="bg-gradient-to-br from-blue-50 to-blue-100 p-4 rounded-lg">
              <p className="text-gray-600 text-sm font-medium">Total Visitors</p>
              <p className="text-3xl font-bold text-blue-600 mt-2">18,340</p>
              <p className="text-sm text-green-600 mt-2">+12.5% from last month</p>
            </div>
            <div className="bg-gradient-to-br from-green-50 to-green-100 p-4 rounded-lg">
              <p className="text-gray-600 text-sm font-medium">Total Revenue</p>
              <p className="text-3xl font-bold text-green-600 mt-2">$26,908</p>
              <p className="text-sm text-green-600 mt-2">+8.3% from last month</p>
            </div>
            <div className="bg-gradient-to-br from-purple-50 to-purple-100 p-4 rounded-lg">
              <p className="text-gray-600 text-sm font-medium">Conversion Rate</p>
              <p className="text-3xl font-bold text-purple-600 mt-2">3.42%</p>
              <p className="text-sm text-green-600 mt-2">+2.1% from last month</p>
            </div>
          </div>
        </div>

        <LineChartComponent data={analyticsData} title="Visitor & Revenue Trend" />
      </div>

      {/* Traffic Source and Device */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
        <Card title="Traffic Source" icon={BarChart3}>
          <PieChartComponent data={channelData} title="" />
        </Card>
        <Card title="Device Distribution" icon={BarChart3}>
          <PieChartComponent data={deviceData} title="" />
        </Card>
      </div>

      {/* Detailed Analysis */}
      <Card title="Monthly Breakdown" icon={BarChart3}>
        <BarChartComponent data={analyticsData} title="" />
      </Card>
    </div>
  )
}

export default Analytics
