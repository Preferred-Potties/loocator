const pool = require('../utils/pool');

module.exports = class User {
  id;
  username;
  email;
  #passwordHash; // private class field: hides it from anything outside of this class definition

  constructor(row) {
    this.id = row.id;
    this.username = row.username;
    this.email = row.email;
    this.#passwordHash = row.password_hash;
  }

  static async insert({ email, passwordHash, username }) {
    const { rows } = await pool.query(
      `
      INSERT INTO users (email, password_hash, username)
      VALUES ($1, $2, $3)
      RETURNING *
    `,
      [email, passwordHash, username]
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
