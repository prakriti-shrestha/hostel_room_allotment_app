const mysql = require('mysql2');
require('dotenv').config();

// Uses process.env to securely get database details from environment variables.
// Instead of writing them directly in the code.
const db = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: process.env.DB_NAME
});

db.connect(err => {
    if(err) {
        console.error('Database connection failed: ', err.stack);
        return;
    }
    console.log('Connected to MySQL database');
});

module.exports = db;