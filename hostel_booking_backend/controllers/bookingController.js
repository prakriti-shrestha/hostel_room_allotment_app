const Booking = require('../models/bookingModel');

exports.register = (req, res) => {
    const {room_id, booked_at, booked_by} = req.body; 

    const newBooking = {room_id, booked_at, booked_by};

    Booking.create(newBooking, (err, results) => {
        if (err) return res.status(500).json({error:err});
        res.status(201).json({message: 'Booking registered', bookingId: results.insertId});
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