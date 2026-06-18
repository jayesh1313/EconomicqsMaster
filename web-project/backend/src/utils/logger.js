export const httpLogger = (request, response) => {
  console.log(`${request.method} ${request.path} - ${response.statusCode}`)
}

export const errorLogger = (error, context = '') => {
  console.error(`[${context}] Error:`, {
    message: error.message,
    stack: error.stack,
    timestamp: new Date().toISOString(),
  })
}

export const successLogger = (message, data = {}) => {
  console.log(`✓ ${message}`, {
    data,
    timestamp: new Date().toISOString(),
  })
}
