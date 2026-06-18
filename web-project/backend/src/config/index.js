import dotenv from 'dotenv'
import path from 'path'
import { fileURLToPath } from 'url'

const __dirname = path.dirname(fileURLToPath(import.meta.url))
dotenv.config({ path: path.join(__dirname, '..', '.env') })

export const config = {
  port: process.env.PORT || 5000,
  nodeEnv: process.env.NODE_ENV || 'development',
  mongoUri: process.env.MONGODB_URI || 'mongodb://localhost:27017/web-project',
  jwtSecret: process.env.JWT_SECRET || 'your_secret_key',
  corsOrigin: process.env.CORS_ORIGIN || 'http://localhost:5173',
}

export default config
