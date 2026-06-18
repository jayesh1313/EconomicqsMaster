import test from 'node:test'
import assert from 'node:assert/strict'
import request from 'supertest'
import app from '../src/server.js'

test('GET /health returns ok status', async () => {
  const response = await request(app).get('/health')

  assert.equal(response.status, 200)
  assert.equal(response.body.status, 'OK')
  assert.equal(typeof response.body.timestamp, 'string')
})