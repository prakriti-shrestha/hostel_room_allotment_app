const db = require('../config/db');
const getQueryRunner = (connection) => connection || db;

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
    getByIdForUpdate: (id, connection, callback) => {
        const queryRunner = getQueryRunner(connection);
        queryRunner.query('SELECT * FROM rooms WHERE room_id = ? FOR UPDATE', [id], callback);
    },
    decrementBeds: (id, connection, callback) => {
        const queryRunner = getQueryRunner(connection);
        queryRunner.query('UPDATE rooms SET beds_available = beds_available - 1 WHERE room_id = ?', [id], callback);
    }
};

module.exports = Room;