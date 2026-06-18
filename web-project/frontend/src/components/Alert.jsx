import { AlertCircle, CheckCircle, Info, AlertTriangle } from 'lucide-react'

function Alert({ type = 'info', title, message, className = '' }) {
  const types = {
    info: {
      bg: 'bg-blue-50',
      border: 'border-blue-200',
      icon: 'text-blue-600',
      Icon: Info,
    },
    success: {
      bg: 'bg-green-50',
      border: 'border-green-200',
      icon: 'text-green-600',
      Icon: CheckCircle,
    },
    warning: {
      bg: 'bg-yellow-50',
      border: 'border-yellow-200',
      icon: 'text-yellow-600',
      Icon: AlertTriangle,
    },
    error: {
      bg: 'bg-red-50',
      border: 'border-red-200',
      icon: 'text-red-600',
      Icon: AlertCircle,
    },
  }

  const config = types[type] || types.info
  const Icon = config.Icon

  return (
    <div className={`${config.bg} border ${config.border} rounded-lg p-4 flex gap-3 ${className}`}>
      <Icon className={`${config.icon} flex-shrink-0`} size={20} />
      <div className="flex-1">
        {title && <h4 className="font-semibold text-gray-800">{title}</h4>}
        <p className="text-gray-700 text-sm">{message}</p>
      </div>
    </div>
  )
}

export default Alert
