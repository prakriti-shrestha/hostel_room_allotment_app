const Booking = require('../models/bookingModel');
const db = require('../config/db');

exports.register = (req, res) => {
    const {room_id} = req.body; 
    const booked_by = req.user?.userId || req.user?.id || req.body.booked_by;

    if(!room_id) return res.status(400).json({error: 'room_id is required'});
    if(!booked_by) return res.status(400).json({error: 'booked_by missing'});

    db.getConnection((err, conn) => {
        if(err) return res.status(500).json({error: err});
        conn.beginTransaction(err => {
            if(err) return res.status(500).json({error:err});
            conn.query('SELECT * FROM rooms WHERE room_id = ? FOR UPDATE', [room_id], (err, rows) => {
                if(err) return conn.rollback(() => res.status(500).json({error: err}));
                if(!rows.length) {
                    return conn.rollback(() => res.status(404).json({error: 'Room not found'}));
                }
                
                const room = rows[0];
                if(room.beds_available <= 0) {
                    return res.status(400).json({error: 'No beds available in this room'});
                }

                const now = new Date();
                const newBooking = {room_id, booked_at: now, booked_by};

                conn.query('INSERT INTO bookings SET ?', newBooking, (err, results) => {
                    if (err) return conn.rollback(() => res.status(500).json({error:err}));
                    conn.query('UPDATE rooms SET beds_available = beds_available - 1 WHERE room_id = ?', [room_id], (err2) => {
                        if (err2) return conn.rollback(() => res.status(500).json({ error: err2 }));

                        conn.commit(err3 => {
                            if (err3) return conn.rollback(() => res.status(500).json({ error: err3 }));
                            res.status(201).json({ message: 'Booking registered', bookingId: results.insertId });
                        });
                    });
                });
            });
        });
    });
};

exports.getBookings = (req, res) => {
    Booking.getAll((err, results) => {
        if(err) return res.status(500).json({error:err});
        res.json(results);
    });
};

exports.getBookingsById = (req, res) => {
    const {id} = req.params;
    Booking.getById(id, (err, results) => {
        if(err) return res.status(500).json({error:err});
        if(results.length === 0) return res.status(404).json({message: 'User not found'});
        res.json(results[0]);
    });
};