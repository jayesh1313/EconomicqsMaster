import { Menu, Bell, User, Settings, LogOut } from 'lucide-react'
import { useState } from 'react'

function Navbar({ onToggleSidebar }) {
  const [dropdownOpen, setDropdownOpen] = useState(false)

  return (
    <nav className="bg-white shadow-md px-6 py-4 flex justify-between items-center">
      <div className="flex items-center gap-4">
        <button onClick={onToggleSidebar} className="text-gray-600 hover:text-blue-500 transition">
          <Menu size={24} />
        </button>
        <h1 className="text-2xl font-bold text-gray-800">Web Project</h1>
      </div>

      <div className="flex items-center gap-6">
        <button className="relative text-gray-600 hover:text-blue-500 transition">
          <Bell size={20} />
          <span className="absolute -top-2 -right-2 bg-red-500 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs">
            3
          </span>
        </button>

        <div className="relative">
          <button 
            onClick={() => setDropdownOpen(!dropdownOpen)}
            className="flex items-center gap-2 text-gray-600 hover:text-blue-500 transition"
          >
            <div className="w-10 h-10 bg-gradient-primary rounded-full flex items-center justify-center text-white">
              JD
            </div>
          </button>

          {dropdownOpen && (
            <div className="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg z-50">
              <div className="p-4 border-b border-gray-200">
                <p className="font-semibold text-gray-800">John Developer</p>
                <p className="text-sm text-gray-500">john@example.com</p>
              </div>
              <ul className="py-2">
                <li><a href="#" className="px-4 py-2 hover:bg-gray-100 flex items-center gap-2"><User size={16} /> Profile</a></li>
                <li><a href="#" className="px-4 py-2 hover:bg-gray-100 flex items-center gap-2"><Settings size={16} /> Settings</a></li>
                <li className="border-t border-gray-200"><a href="#" className="px-4 py-2 hover:bg-gray-100 flex items-center gap-2 text-red-500"><LogOut size={16} /> Logout</a></li>
              </ul>
            </div>
          )}
        </div>
      </div>
    </nav>
  )
}

export default Navbar
