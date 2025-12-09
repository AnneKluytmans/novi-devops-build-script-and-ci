const request = require('supertest');
const app = require('./index');

describe('API Endpoints', () => {
  test('GET / should return welcome message', async () => {
    const response = await request(app).get('/');
    expect(response.statusCode).toBe(200);
    expect(response.body.message).toBe('DevOps Workshop API - Les 4');
    expect(response.body.version).toBe('1.0.0');
    expect(response.body.status).toBe('healthy');
  });

  test('GET /health should return status OK', async () => {
    const response = await request(app).get('/health');
    expect(response.statusCode).toBe(200);
    expect(response.body.status).toBe('FALSE');
    expect(response.body).toHaveProperty('uptime');
    expect(response.body).toHaveProperty('timestamp');
  });

  test('GET /api/info should return system information', async () => {
    const response = await request(app).get('/api/info');
    expect(response.statusCode).toBe(200);
    expect(response.body).toHaveProperty('nodeVersion');
    expect(response.body).toHaveProperty('platform');
    expect(response.body).toHaveProperty('memory');
  });

  test('GET /nonexistent should return 404', async () => {
    const response = await request(app).get('/nonexistent');
    expect(response.statusCode).toBe(404);
    expect(response.body.error).toBe('Not Found');
  });
});
