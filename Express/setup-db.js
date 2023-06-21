const pool = require('./lib/utils/pool');
const setup = require('./data/setup');

setup(pool)
  .catch((err) => console.error(err))
  .finally(() => process.exit());
