const pool = require('../lib/utils/pool.js');
const setup = require('../data/setup');
const app = require('../lib/app');
const request = require('supertest');
const UserService = require('../lib/services/UserService.js');
const Review = require('../lib/models/Review.js');

const mockUser = {
  username: 'User',
  email: 'test@example.com',
  password: '12345',
};

const mockLoo = {
  description: 'This loo is nice!',
  rating: '5',
  latitude: '45.5226327',
  longitude: '-122.7002726',
};

// const mockReview = {
//   cleanliness: '5',
//   safety: '5',
//   accessibility: '5',
//   gendered: true,
//   locks: true,
//   sanitizer: true,
//   amenities: 'big bathroom',
//   comments: 'very nice',
//   loo_id: mockLoo.id,
// };

const registerAndLogin = async (userProps = {}) => {
  const password = userProps.password ?? mockUser.password;
  const agent = request.agent(app);
  const user = await UserService.create({ ...mockUser, ...userProps });
  const { email } = user;
  await agent.post('/api/v1/users/sessions').send({ email, password });
  return [agent, user];
};

describe('reviews routes', () => {
  beforeEach(() => {
    return setup(pool);
  });
  afterAll(() => {
    pool.end();
  });

  it('GET /api/v1/reviews should return a list of reviews', async () => {
    const res = await request(app).get('/api/v1/reviews');
    expect(res.status).toBe(200);
    expect(res.body[0]).toEqual({
      id: expect.any(String),
      created_at: expect.any(String),
      safety: expect.any(String),
      accessibility: expect.any(String),
      cleanliness: expect.any(String),
      gendered: expect.any(Boolean),
      locks: expect.any(Boolean),
      sanitizer: expect.any(Boolean),
      amenities: expect.any(String),
      comments: expect.any(String),
      loo_id: expect.any(String),
    });
  });

  it('GET /api/v1/reviews/:id should get a single review', async () => {
    const [agent] = await registerAndLogin();
    const looRes = await agent.post('/api/v1/loos').send(mockLoo);
    expect(looRes.status).toBe(200);
    expect(looRes.body).toEqual({
      id: expect.any(String),
      created_at: expect.any(String),
      ...mockLoo,
    });
    const mockReview = {
      cleanliness: '5',
      safety: '5',
      accessibility: '5',
      gendered: true,
      locks: true,
      sanitizer: true,
      amenities: 'big bathroom',
      comments: 'very nice',
      loo_id: looRes.body.id,
    };
    console.log('looRes.id', looRes.body.id);
    const insertReviewRes = await agent
      .post('/api/v1/reviews')
      .send(mockReview);
    // expect(insertReviewRes.status).toBe(200);
    const res = await request(app).get(
      `/api/v1/reviews/${insertReviewRes.body.id}`
    );
    // expect(res.status).toBe(200);
    expect(res.body).toEqual({
      id: expect.any(String),
      created_at: expect.any(String),
      ...mockReview,
    });
  });

  it('GET /api/v1/reviews/byLooId/:loo_id should get a single review based on loo id', async () => {
    const [agent] = await registerAndLogin();
    const looRes = await agent.post('/api/v1/loos').send(mockLoo);
    expect(looRes.status).toBe(200);
    expect(looRes.body).toEqual({
      id: expect.any(String),
      created_at: expect.any(String),
      ...mockLoo,
    });
    const mockReview = {
      cleanliness: '5',
      safety: '5',
      accessibility: '5',
      gendered: true,
      locks: true,
      sanitizer: true,
      amenities: 'big bathroom',
      comments: 'very nice',
      loo_id: looRes.body.id,
    };
    console.log('looRes.id', looRes.body.id);
    const insertReviewRes = await agent
      .post('/api/v1/reviews')
      .send(mockReview);
    // expect(insertReviewRes.status).toBe(200);
    const res = await request(app).get(
      `/api/v1/reviews/byLooId/${insertReviewRes.body.loo_id}`
    );
    console.log(res.body);
    // expect(res.status).toBe(200);
    expect(res.body[0]).toEqual({
      id: expect.any(String),
      created_at: expect.any(String),
      ...mockReview,
    });
  });

  it.skip('POST /api/v1/reviews should create a new review', async () => {
    const [agent] = await registerAndLogin();
    const looRes = await agent.post('/api/v1/loos').send(mockLoo);
    expect(looRes.status).toBe(200);
    expect(looRes.body).toEqual({
      id: expect.any(String),
      created_at: expect.any(String),
      ...mockLoo,
    });
    const mockReview = {
      cleanliness: '5',
      safety: '5',
      accessibility: '5',
      gendered: true,
      locks: true,
      sanitizer: true,
      amenities: 'big bathroom',
      comments: 'very nice',
      loo_id: looRes.body.id,
    };
    const res = await agent.post('/api/v1/reviews').send(mockReview);
    // expect(res.status).toBe(200);
    expect(res.body).toEqual({
      id: expect.any(String),
      created_at: expect.any(String),
      safety: expect.any(String),
      accessibility: expect.any(String),
      cleanliness: expect.any(String),
      gendered: expect.any(Boolean),
      locks: expect.any(Boolean),
      sanitizer: expect.any(Boolean),
      amenities: expect.any(String),
      comments: expect.any(String),
      loo_id: looRes.id,
    });
  });

  it.skip('UPDATE /api/v1/reviews/:id should update a review', async () => {
    const [agent] = await registerAndLogin();

    const looRes = await agent.post('/api/v1/loos').send(mockLoo);
    expect(looRes.status).toBe(200);
    expect(looRes.body).toEqual({
      id: expect.any(String),
      created_at: expect.any(String),
      ...mockLoo,
    });
    const mockReview = {
      cleanliness: '5',
      safety: '5',
      accessibility: '5',
      gendered: true,
      locks: true,
      sanitizer: true,
      amenities: 'big bathroom',
      comments: 'very nice',
      loo_id: looRes.body.id,
    };

    const review = await Review.insert(mockReview);
    const res = await agent
      .put(`/api/v1/reviews/${review.id}`)
      .send({ comments: 'A real dump' });
    expect(res.status).toBe(200);
    expect(res.body).toEqual({
      ...mockReview,
      comments: 'A real dump',
      id: expect.any(String),
      created_at: expect.any(String),
    });
  });

  it.skip('DELETE /api/v1/reviews/:id should delete a review', async () => {
    //come back and add authorization?
    const [agent] = await registerAndLogin();
    const looRes = await agent.post('/api/v1/loos').send(mockLoo);
    expect(looRes.status).toBe(200);
    expect(looRes.body).toEqual({
      id: expect.any(String),
      created_at: expect.any(String),
      ...mockLoo,
    });
    const mockReview = {
      cleanliness: '5',
      safety: '5',
      accessibility: '5',
      gendered: true,
      locks: true,
      sanitizer: true,
      amenities: 'big bathroom',
      comments: 'very nice',
      loo_id: looRes.body.id,
    };
    const addReview = await Review.insert(mockReview);
    const deleteReview = await agent.delete('/api/v1/reviews/' + addReview.id);
    expect(deleteReview.status).toBe(200);
    const check = await Review.getById(addReview.id);
    expect(check).toBeNull();
  });
});
