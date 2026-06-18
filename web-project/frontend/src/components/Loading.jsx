import { Loader } from 'lucide-react'

function Loading({ fullscreen = false, message = 'Loading...' }) {
  const content = (
    <div className="flex flex-col items-center justify-center gap-4">
      <Loader className="animate-spin text-blue-600" size={48} />
      <p className="text-gray-600 font-medium">{message}</p>
    </div>
  )

  if (fullscreen) {
    return (
      <div className="fixed inset-0 bg-white flex items-center justify-center z-50">
        {content}
      </div>
    )
  }

  return (
    <div className="w-full h-full flex items-center justify-center min-h-96">
      {content}
    </div>
  )
}

export default Loading
