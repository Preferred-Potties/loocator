const pool = require('../lib/utils/pool');
const setup = require('../data/setup');
const request = require('supertest');
const app = require('../lib/app');
const UserService = require('../lib/services/UserService');
const Loo = require('../lib/models/Loo.js');

const mockUser = {
  username: 'User',
  email: 'test@example.com',
  password: '12345',
};

const mockLoo = {
  description: 'This loo is nice!',
  rating: '5',
};

const registerAndLogin = async (userProps = {}) => {
  const password = userProps.password ?? mockUser.password;
  const agent = request.agent(app);
  const user = await UserService.create({ ...mockUser, ...userProps });
  const { email } = user;
  await agent.post('/api/v1/users/sessions').send({ email, password });
  return [agent, user];
};

describe('loo routes', () => {
  beforeEach(() => {
    return setup(pool);
  });
  afterAll(() => {
    pool.end();
  });

  it.skip('POST /api/v1/loos should create a new loo', async () => {
    const [agent] = await registerAndLogin();
    const res = await agent.post('/api/v1/loos').send(mockLoo);
    expect(res.status).toBe(200);
    expect(res.body).toEqual({
      id: expect.any(String),
      created_at: expect.any(String),
      ...mockLoo,
    });
  });

  it.skip('GET /api/v1/loos should return a list of loos', async () => {
    const res = await request(app).get('/api/v1/loos');
    expect(res.status).toBe(200);
    expect(res.body[0]).toEqual({
      id: expect.any(String),
      created_at: expect.any(String),
      description: expect.any(String),
      rating: expect.any(String),
    });
  });

  it.skip('GET /api/v1/loos/:id should get a single loo', async () => {
    const [agent] = await registerAndLogin();
    const insertLooRes = await agent.post('/api/v1/loos').send(mockLoo);
    expect(insertLooRes.status).toBe(200);
    const res = await request(app).get(`/api/v1/loos/${insertLooRes.body.id}`);
    expect(res.status).toBe(200);
    expect(res.body).toEqual({
      id: expect.any(String),
      created_at: expect.any(String),
      ...mockLoo,
    });
  });

  it.skip('UPDATE /api/v1/loos/:id should update a loo', async () => {
    const [agent] = await registerAndLogin();
    const loo = await Loo.insert({
      description: 'This loo is nice!',
      rating: '5',
    });
    const res = await agent.put(`/api/v1/loos/${loo.id}`).send({ rating: '3' });
    expect(res.status).toBe(200);
    expect(res.body).toEqual({
      ...mockLoo,
      rating: '3',
      id: expect.any(String),
      created_at: expect.any(String),
    });
  });

  it.skip('DELETE /api/v1/loos/:id should delete a loo', async () => {
    const [agent] = await registerAndLogin();
    const insertLooRes = await Loo.insert(mockLoo);
    const deleteLooRes = await agent.delete('/api/v1/loos/' + insertLooRes.id);
    expect(deleteLooRes.status).toBe(200);
    const check = await Loo.getById(insertLooRes.id);
    expect(check).toBeNull();
  });
});
