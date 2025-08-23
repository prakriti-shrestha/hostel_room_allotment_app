const Room = require('../models/hostelModel');

exports.getRooms = (req, res) => {
    Room.getAll((err, results) => {
        if(err) return res.status(500).json({error:err});
        res.json(results);
    });
};

exports.register = (req, res) => {
    const {building_id, room_number, type, beds_total, beds_available, apartment, nationality_restriction} = req.body;

    if(!building_id || !room_number || !type || !beds_total) {
        return res.status(400).json({error: 'building_id, room_number, type, beds_total are required'});
    }
    if(beds_available && Number(beds_available) > Number(beds_total)) {
        return res.status(400).json({error: 'beds_available cannot exceed beds_total'});
    }

    const allowedTypes = ['AC', 'Non-AC'];
    if(!allowedTypes.includes(type)) {
        return res.status(400).json({error: 'Invalid room type'});
    }

    const newRoom = {building_id, room_number, type, beds_total, beds_available, apartment, nationality_restriction};

    Room.create(newRoom, (err, results) => {
        if(err) return res.status(500).json({error:err});
        res.status(201).json({message: 'Room registered', roomId: results.insertId});
    });
};