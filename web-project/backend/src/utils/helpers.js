// Create a simple logger utility for the backend
export const logRequest = (method, url, statusCode) => {
  const timestamp = new Date().toISOString()
  console.log(`[${timestamp}] ${method} ${url} - ${statusCode}`)
}

export const logError = (error, context) => {
  const timestamp = new Date().toISOString()
  console.error(`[${timestamp}] ERROR in ${context}:`, error.message)
}

export const logSuccess = (message, details = {}) => {
  const timestamp = new Date().toISOString()
  console.log(`[${timestamp}] ✓ ${message}`, details)
}
