export const errorHandler = (err, req, res, next) => {
  console.error(err.stack)

  const status = err.status || 500
  const message = err.message || 'Internal Server Error'

  res.status(status).json({
    success: false,
    error: {
      status,
      message,
      ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
    },
  })
}

export const notFound = (req, res) => {
  res.status(404).json({
    success: false,
    error: {
      status: 404,
      message: 'Route not found',
    },
  })
}

export const asyncHandler = (fn) => (req, res, next) => {
  Promise.resolve(fn(req, res, next)).catch(next)
}
