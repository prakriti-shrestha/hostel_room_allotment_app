const express = require('express');
const router = express.Router();
const hostelController = require('../controllers/hostelController');
const { authenticateToken, authorizeRoles } = require('../middleware/auth');

router.get('/rooms', authenticateToken, hostelController.getRooms);
router.post('/rooms/register', authenticateToken, authorizeRoles('admin'), hostelController.register);

module.exports = router;