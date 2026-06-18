import { ChevronDown } from 'lucide-react'
import { useState } from 'react'

function Dropdown({ label, items, onSelect, icon: Icon = null }) {
  const [isOpen, setIsOpen] = useState(false)
  const [selected, setSelected] = useState(items[0])

  const handleSelect = (item) => {
    setSelected(item)
    setIsOpen(false)
    onSelect?.(item)
  }

  return (
    <div className="relative inline-block w-full">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="w-full px-4 py-2 bg-white border border-gray-300 rounded-lg flex items-center justify-between hover:border-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500"
      >
        <span className="flex items-center gap-2">
          {Icon && <Icon size={18} />}
          {selected}
        </span>
        <ChevronDown size={18} className={`transition-transform ${isOpen ? 'rotate-180' : ''}`} />
      </button>

      {isOpen && (
        <div className="absolute top-full left-0 right-0 mt-2 bg-white border border-gray-300 rounded-lg shadow-lg z-10">
          {items.map((item) => (
            <button
              key={item}
              onClick={() => handleSelect(item)}
              className={`w-full text-left px-4 py-2 hover:bg-blue-50 transition ${
                selected === item ? 'bg-blue-100 text-blue-600 font-medium' : ''
              }`}
            >
              {item}
            </button>
          ))}
        </div>
      )}
    </div>
  )
}

export default Dropdown
