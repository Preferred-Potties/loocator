const pool = require('../utils/pool');

module.exports = class Loo {
  id;
  longitude;
  latitude;
  description;
  rating;
  created_at;

  constructor(row) {
    this.id = row.id;
    this.latitude = row.latitude;
    this.longitude = row.longitude;
    this.description = row.description;
    this.rating = row.rating;
    this.created_at = row.created_at;
  }

  static async getAll() {
    const { rows } = await pool.query('SELECT * from loos');
    return rows.map((row) => new Loo(row));
  }

  static async insert({ description, rating, latitude, longitude }) {
    const { rows } = await pool.query(
      `
        INSERT INTO loos (description, rating, longitude, latitude)
        VALUES ($1, $2, $3, $4)
        RETURNING *
        `,
      [description, rating, longitude, latitude]
    );
    return new Loo(rows[0]);
  }

  static async getById(id) {
    const { rows } = await pool.query(
      `
      SELECT * from loos
      WHERE id = $1
      `,
      [id]
    );
    if (!rows[0]) {
      return null;
    }
    return new Loo(rows[0]);
  }

  static async updateById(id, attrs) {
    const loo = await Loo.getById(id);
    if (!loo) return null;
    const { description, rating } = { ...loo, ...attrs };
    const { rows } = await pool.query(
      `
      UPDATE loos
      SET description=$2, rating=$3
      WHERE id=$1
      RETURNING *
      
      `,
      [id, description, rating]
    );
    return new Loo(rows[0]);
  }

  static async delete(id) {
    const { rows } = await pool.query(
      `
      DELETE from loos
      WHERE id=$1
      RETURNING *`,
      [id]
    );
    return new Loo(rows[0]);
  }
};
