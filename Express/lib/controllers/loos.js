const { Router } = require('express');
const authenticate = require('../middleware/authenticate.js');
const Loo = require('../models/Loo');

module.exports = Router()
  .get('/:id', async (req, res, next) => {
    try {
      const id = req.params.id;
      const loo = await Loo.getById(id);
      res.json(loo);
    } catch (e) {
      next(e);
    }
  })
  .get('/', async (req, res, next) => {
    try {
      const loos = await Loo.getAll();
      res.json(loos);
    } catch (e) {
      next(e);
    }
  })
  .post('/', async (req, res, next) => {
    try {
      const loo = await Loo.insert({
        longitude: req.body.longitude,
        latitude: req.body.latitude,
        description: req.body.description,
        rating: req.body.rating,
      });
      res.json(loo);
    } catch (e) {
      next(e);
    }
  })
  .put('/:id', authenticate, async (req, res, next) => {
    try {
      const loo = await Loo.updateById(req.params.id, req.body);
      res.json(loo);
    } catch (e) {
      next(e);
    }
  })
  .delete('/:id', authenticate, async (req, res, next) => {
    try {
      const id = req.params.id;
      const loo = await Loo.delete(id);
      res.json(loo);
    } catch (e) {
      next(e);
    }
  });
