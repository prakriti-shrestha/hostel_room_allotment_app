const db = require('../config/db');

const Room = {
    getAll: (callback) => {
        db.query('SELECT * FROM rooms', callback);
    },
    getById: (id, callback) => {
        db.query('SELECT * FROM rooms WHERE room_id = ?', [id], callback);
    },
    create: (userData, callback) => {
        db.query('INSERT INTO rooms SET ?', userData, callback);
    },
    updateBeds: (roomId, newAvailable, callback) => {
        db.query('UPDATE rooms SET beds_available = ? WHERE room_id = ?', [newAvailable, roomId], callback);
    }
};

module.exports = Room;