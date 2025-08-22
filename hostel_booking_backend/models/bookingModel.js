const db = require('../config/db');

const Booking = {
    getAll: (callback) => {
        db.query('SELECT * FROM bookings', callback);
    },
    getById: (id, callback) => {
        db.query('SELECT * FROM bookings WHERE booked_by = ?', [id], callback);
    },
    create: (userData, callback) => {
        db.query('INSERT INTO bookings SET ?', userData, callback);
    }
};

module.exports = Booking;