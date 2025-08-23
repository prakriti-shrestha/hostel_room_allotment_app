const mysql = require('mysql2');
require('dotenv').config();

// Using a connection pool to handle multiple concurrent queries in the database.
const db = mysql.createPool({
    // Uses process.env to securely get database details from environment variables.
    // Instead of writing them directly in the code.
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: process.env.DB_NAME,
    // If no connection available queue it instead of crashing the entire thing
    waitForConnections: true,
    // 10 queries can be processed simultaneously
    connectionLimit: 10,
    queueLimit: 0
});

db.getConnection((err, conn) => {
    if(err) {
        console.error('Database connection failed: ', err.stack);
        return;
    }
    console.log('Connected to MySQL database');
    conn.release();
});

module.exports = db;