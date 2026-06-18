import { Link, useLocation } from 'react-router-dom'
import { LayoutDashboard, BarChart3, Users, Settings, ChevronRight } from 'lucide-react'

function Sidebar({ isOpen }) {
  const location = useLocation()

  const menuItems = [
    { path: '/', label: 'Dashboard', icon: LayoutDashboard },
    { path: '/analytics', label: 'Analytics', icon: BarChart3 },
    { path: '/users', label: 'Users', icon: Users },
    { path: '/settings', label: 'Settings', icon: Settings },
  ]

  return (
    <div className={`${isOpen ? 'w-64' : 'w-20'} bg-gradient-to-b from-blue-600 to-blue-800 text-white transition-all duration-300 flex flex-col shadow-lg`}>
      <div className="p-6 flex items-center gap-3 border-b border-blue-500">
        <div className="w-10 h-10 bg-white rounded-lg flex items-center justify-center">
          <span className="text-blue-600 font-bold text-lg">W</span>
        </div>
        {isOpen && <span className="font-bold text-lg">WebApp</span>}
      </div>

      <nav className="flex-1 py-6">
        {menuItems.map((item) => {
          const Icon = item.icon
          const isActive = location.pathname === item.path
          
          return (
            <Link
              key={item.path}
              to={item.path}
              className={`px-6 py-4 flex items-center gap-3 transition-all duration-300 ${
                isActive 
                  ? 'bg-white text-blue-600 border-r-4 border-white' 
                  : 'text-blue-100 hover:bg-blue-500 hover:text-white'
              }`}
            >
              <Icon size={22} />
              {isOpen && (
                <>
                  <span className="flex-1">{item.label}</span>
                  {isActive && <ChevronRight size={20} />}
                </>
              )}
            </Link>
          )
        })}
      </nav>

      <div className="p-6 border-t border-blue-500">
        <div className={`text-sm text-blue-100 ${isOpen ? '' : 'text-center'}`}>
          {isOpen && (
            <>
              <p className="font-semibold mb-2">Version 1.0</p>
              <p className="text-xs">Last updated: Today</p>
            </>
          )}
        </div>
      </div>
    </div>
  )
}

export default Sidebar
