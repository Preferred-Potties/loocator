const express = require('express');
const cookieParser = require('cookie-parser');
const app = express();
// const cors = require('cors');

// Built in middleware
app.use(express.json());
app.use(cookieParser());
// app.use(
//   cors({
//     origin: [
//       'http://localhost:5500',
//       'https://app.netlify.com/sites/potties-dev/',
//       'http://127.0.0.1:7890',
//       'exp://10.0.0.223:19000',
//       'http://localhost:19006',
//       'http://10.0.2.2:3000',
//     ],
//     credentials: true,
//   })
// );

// App routes
app.use('/api/v1/users', require('./controllers/users'));
app.use('/api/v1/loos', require('./controllers/loos'));
app.use('/api/v1/reviews', require('./controllers/reviews'));

// Error handling & 404 middleware for when
// a request doesn't match any app routes
app.use(require('./middleware/not-found'));
app.use(require('./middleware/error'));

module.exports = app;

//added secrets in github
//also in heroku and netlify
