const { Router } = require('express');
const Review = require('../models/Review.js');
const authenticate = require('../middleware/authenticate.js');

module.exports = Router()
  .get('/:id', async (req, res, next) => {
    try {
      const id = req.params.id;
      const review = await Review.getById(id);
      res.json(review);
      console.log(review);
    } catch (e) {
      next(e);
    }
  })
  .get('/byLooId/:loo_id', async (req, res, next) => {
    try {
      const looId = req.params.loo_id;
      const reviews = await Review.getByLooId(looId);
      console.log(reviews, 'REVIEWS IN controller');
      res.json(reviews);
    } catch (e) {
      next(e);
    }
  })
  .get('/', async (req, res, next) => {
    try {
      const reviews = await Review.getAll();
      res.json(reviews);
    } catch (e) {
      next(e);
    }
  })
  .post('/', async (req, res, next) => {
    try {
      const review = await Review.insert({
        safety: req.body.safety,
        accessibility: req.body.accessibility,
        cleanliness: req.body.cleanliness,
        gendered: req.body.gendered,
        locks: req.body.locks,
        sanitizer: req.body.sanitizer,
        amenities: req.body.amenities,
        comments: req.body.comments,
        loo_id: req.body.loo_id,
      });
      res.json(review);
    } catch (e) {
      next(e);
    }
  })
  .put('/:id', authenticate, async (req, res, next) => {
    try {
      const review = await Review.updateById(req.params.id, req.body);
      res.json(review);
    } catch (e) {
      next(e);
    }
  })
  .delete('/:id', authenticate, async (req, res, next) => {
    try {
      const id = req.params.id;
      const review = await Review.delete(id);
      res.json(review);
    } catch (e) {
      next(e);
    }
  });
