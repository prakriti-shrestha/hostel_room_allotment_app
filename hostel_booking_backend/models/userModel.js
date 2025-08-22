const db = require('../config/db');

const User = {
    getAll: (callback) => {
        db.query('SELECT * FROM users', callback);
    },
    getAllAdmin: (callback) => {
        db.query('SELECT * FROM users WHERE user_role = "admin";', callback);
    },
    getById: (id, callback) => {
        db.query('SELECT * FROM users WHERE user_id = ?', [id], callback);
    },
    create: (userData, callback) => {
        db.query('INSERT INTO users SET ?', userData, callback);
    },
    getByEmail: (email, callback) => {
        db.query('SELECT * FROM users WHERE email = ?', [email], callback);
    }
};

module.exports = User;