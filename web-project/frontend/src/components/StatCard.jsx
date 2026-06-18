import { TrendingUp, TrendingDown } from 'lucide-react'

function StatCard({ title, value, change, icon: Icon, trend = 'up' }) {
  const isPositive = trend === 'up'
  const TrendIcon = isPositive ? TrendingUp : TrendingDown
  const trendColor = isPositive ? 'text-green-500' : 'text-red-500'

  return (
    <div className="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition-shadow">
      <div className="flex justify-between items-start mb-4">
        <div>
          <p className="text-gray-600 text-sm font-medium">{title}</p>
          <p className="text-3xl font-bold text-gray-800 mt-2">{value}</p>
        </div>
        <div className="w-12 h-12 bg-gradient-primary rounded-lg flex items-center justify-center">
          <Icon size={24} className="text-white" />
        </div>
      </div>
      <div className="flex items-center gap-1">
        <TrendIcon size={16} className={trendColor} />
        <span className={`text-sm font-medium ${trendColor}`}>{change}%</span>
        <span className="text-gray-500 text-sm ml-1">vs last month</span>
      </div>
    </div>
  )
}

export default StatCard
