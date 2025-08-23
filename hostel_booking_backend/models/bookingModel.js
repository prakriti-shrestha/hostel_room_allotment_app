const db = require('../config/db');

const Booking = {
    getAll: (callback) => {
        const sql = `SELECT b.*, u.user_name AS booked_by_name, r.room_number 
            FROM bookings b 
            JOIN users u ON b.booked_by = u.user_id 
            JOIN rooms r ON b.room_id = r.room_id
            ORDER BY b.booked_at DESC`;
        db.query(sql, callback);
    },
    getById: (id, callback) => {
        const sql = `SELECT b.*, u.user_name AS booked_by_name, r.room_number
            FROM bookings b
            JOIN users u ON b.booked_by = u.user_id 
            JOIN rooms r ON b.room_id = r.room_id
            WHERE b.booking_id = ?`;
        db.query(sql, [id], callback);
    },
    create: (userData, callback) => {
        db.query('INSERT INTO bookings SET ?', userData, callback);
    }
};

module.exports = Booking;