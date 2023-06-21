const pool = require('../utils/pool');

module.exports = class Review {
  id;
  created_at;
  cleanliness;
  safety;
  accessibility;
  gendered;
  locks;
  sanitizer;
  amenities;
  comments;
  loo_id;

  constructor(row) {
    this.id = row.id;
    this.created_at = row.created_at;
    this.cleanliness = row.cleanliness;
    this.safety = row.safety;
    this.accessibility = row.accessibility;
    this.gendered = row.gendered;
    this.locks = row.locks;
    this.sanitizer = row.sanitizer;
    this.amenities = row.amenities;
    this.comments = row.comments;
    this.loo_id = row.loo_id;
  }

  static async getAll() {
    const { rows } = await pool.query('SELECT *  from reviews');
    return rows.map((row) => new Review(row));
  }

  static async insert({
    cleanliness,
    accessibility,
    safety,
    gendered,
    locks,
    sanitizer,
    amenities,
    comments,
    loo_id,
  }) {
    const { rows } = await pool.query(
      `
      INSERT INTO reviews (cleanliness, accessibility, safety, gendered, locks, sanitizer, amenities, comments, loo_id)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
      RETURNING *`,
      [
        cleanliness,
        accessibility,
        safety,
        gendered,
        locks,
        sanitizer,
        amenities,
        comments,
        loo_id,
      ]
    );
    return new Review(rows[0]);
  }

  static async getById(id) {
    const { rows } = await pool.query(
      `
      SELECT * from reviews
      WHERE id = $1`,
      [id]
    );
    if (!rows[0]) {
      return null;
    }
    return new Review(rows[0]);
  }

  static async getByLooId(loo_id) {
    const { rows } = await pool.query(
      `
      SELECT * from reviews
      WHERE loo_id = $1`,
      [loo_id]
    );
    if (!rows[0]) {
      return null;
    }
    console.log('ROWS in MODEL', rows);
    return rows.map((row) => new Review(row));
  }

  static async updateById(id, attrs) {
    const review = await Review.getById(id);
    if (!review) return null;
    const {
      cleanliness,
      accessibility,
      safety,
      gendered,
      locks,
      sanitizer,
      amenities,
      comments,
      loo_id,
    } = { ...review, ...attrs };
    const { rows } = await pool.query(
      `
      UPDATE reviews
      SET cleanliness=$2, accessibility=$3, safety=$4, gendered=$5, locks=$6, sanitizer=$7, amenities=$8, comments=$9, loo_id=$10
      WHERE id=$1
      RETURNING *`,
      [
        id,
        cleanliness,
        accessibility,
        safety,
        gendered,
        locks,
        sanitizer,
        amenities,
        comments,
        loo_id,
      ]
    );
    return new Review(rows[0]);
  }

  static async delete(id) {
    const { rows } = await pool.query(
      `
      DELETE from reviews
      WHERE id=$1
      RETURNING *`,
      [id]
    );
    return new Review(rows[0]);
  }
};
