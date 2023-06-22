const jwt = require('jsonwebtoken');

module.exports = async (req, res, next) => {
  try {
    const token = req.body.token;

    // Check if token is present
    if (!token) {
      throw new Error('You must be signed in to continue');
    }

    // Verify the JWT token, then attach the user to the request
    const user = jwt.verify(token, process.env.JWT_SECRET);
    req.user = user;

    next();
  } catch (err) {
    err.status = 401;
    next(err);
  }
};
