const express = require('express');
const router = express.Router();
const bookingController = require('../controllers/bookingController');

router.get('/bookings', bookingController.getBookings);
router.get('/bookings/:id', bookingController.getBookingsById);
router.post('/bookings/register', bookingController.register);

module.exports = router;