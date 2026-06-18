function Card({ title, children, className = '', icon: Icon = null }) {
  return (
    <div className={`bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition-shadow ${className}`}>
      {title && (
        <div className="flex items-center gap-2 mb-4 pb-4 border-b border-gray-200">
          {Icon && <Icon size={20} className="text-blue-600" />}
          <h3 className="text-lg font-semibold text-gray-800">{title}</h3>
        </div>
      )}
      {children}
    </div>
  )
}

export default Card
