const express = require('express');
const router = express.Router();
const hostelController = require('../controllers/hostelController');

router.get('/rooms', hostelController.getRooms);
router.post('/rooms/register', hostelController.register);

module.exports = router;