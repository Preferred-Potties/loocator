const pool = require('../utils/pool');

module.exports = class User {
  id;
  username;
  email;
  #passwordHash; // private class field: hides it from anything outside of this class definition
  favorites;

  constructor(row) {
    this.id = row.id;
    this.username = row.username;
    this.email = row.email;
    this.#passwordHash = row.password_hash;
    this.favorites = row.favorites;
  }

  static async insert({ username, email, passwordHash, favorites }) {
    const { rows } = await pool.query(
      `
      INSERT INTO users (username, email, password_hash, favorites)
      VALUES ($1, $2, $3, $4)
      RETURNING *
    `,
      [username, email, passwordHash, favorites]
    );

    return new User(rows[0]);
  }

  static async getAll() {
    const { rows } = await pool.query('SELECT * FROM users');

    return rows.map((row) => new User(row));
  }

  static async getByUsername(username) {
    const { rows } = await pool.query(
      `
      SELECT *
      FROM users
      WHERE username=$1
      `,
      [username]
    );

    if (!rows[0]) return null;

    return new User(rows[0]);
  }

  get passwordHash() {
    return this.#passwordHash;
  }
};
