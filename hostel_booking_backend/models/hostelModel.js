const db = require('../config/db');

const Room = {
    getAll: (callback) => {
        db.query('SELECT * FROM rooms', callback);
    },
    create: (userData, callback) => {
        db.query('INSERT INTO rooms SET ?', userData, callback);
    },
};

module.exports = Room;