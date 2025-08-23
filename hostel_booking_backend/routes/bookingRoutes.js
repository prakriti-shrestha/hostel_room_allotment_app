const express = require('express');
const router = express.Router();
const bookingController = require('../controllers/bookingController');
const {authenticateToken, authorizeRoles} = require('../middleware/auth');

router.get('/bookings', authenticateToken, authorizeRoles('admin'), bookingController.getBookings);
router.get('/bookings/:id',authenticateToken, authorizeRoles('admin'), bookingController.getBookingsById);
router.post('/bookings/register', authenticateToken, authorizeRoles('student'), bookingController.register);

module.exports = router;