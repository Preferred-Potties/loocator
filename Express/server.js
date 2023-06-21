const app = require('./lib/app');
const pool = require('./lib/utils/pool');

const API_URL = process.env.API_URL || 'http://localhost';
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.info(`🚀  Server started on ${API_URL}:${PORT}`);
});

process.on('exit', () => {
  console.info('👋  Goodbye!');
  pool.end();
});

// const server = express()
//   .use((req, res) => res.send('Hi there'))
//   .listen(PORT, () => console.log(`Listening on ${PORT}`));

// const wss = new Server({ server });

// wss.on('connection', function (ws, req) {
//   ws.on('message', (message) => {
//     var dataString = message.toString();
//     console.log(dataString);
//   });
// });
