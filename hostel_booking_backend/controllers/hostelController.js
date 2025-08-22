const Room = require('../models/hostelModel');

exports.getRooms = (req, res) => {
    Room.getAll((err, results) => {
        if(err) return res.status(500).json({error:err});
        res.json(results);
    });
};

exports.register = (req, res) => {
    const {building_id, room_number, type, beds_total, beds_available, apartment, nationality_restriction} = req.body;

    const newRoom = {building_id, room_number, type, beds_total, beds_available, apartment, nationality_restriction};

    Room.create(newRoom, (err, results) => {
        if(err) return res.status(500).json({error:err});
        res.status(201).json({message: 'Room registered', roomId: results.insertId});
    });
};