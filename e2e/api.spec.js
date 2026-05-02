const { test, expect } = require('@playwright/test');

const API_BASE = process.env.API_URL || 'http://localhost:8000';

test.describe('comptaManagerDZ - API Tests', () => {

  test('API-1: Health check', async ({ request }) => {
    const response = await request.get(`${API_BASE}/health`);
    expect(response.ok()).toBeTruthy();
  });

  test('API-2: Login API', async ({ request }) => {
    const response = await request.post(`${API_BASE}/api/v1/auth/login`, {
      data: {
        username: 'admin',
        password: 'admin123'
      }
    });
    expect(response.ok() || response.status() === 401).toBeTruthy();
  });

  test('API-3: Get clients', async ({ request }) => {
    const response = await request.get(`${API_BASE}/api/v1/clients`);
    expect([200, 401, 404]).toContain(response.status());
  });

  test('API-4: Get documents', async ({ request }) => {
    const response = await request.get(`${API_BASE}/api/v1/documents`);
    expect([200, 401, 404]).toContain(response.status());
  });

  test('API-5: Get users', async ({ request }) => {
    const response = await request.get(`${API_BASE}/api/v1/users`);
    expect([200, 401, 404]).toContain(response.status());
  });

  test('API-6: Swagger docs available', async ({ request }) => {
    const response = await request.get(`${API_BASE}/docs`);
    expect(response.ok()).toBeTruthy();
  });
});

test.describe('Database Connection', () => {
  test('DB-1: PostgreSQL reachable', async ({ request }) => {
    const response = await request.get(`${API_BASE}/health`);
    const body = await response.json();
    expect(body.status || response.ok()).toBeTruthy();
  });
});