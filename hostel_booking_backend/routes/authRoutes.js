const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

router.get('/users', authController.getUsers);
router.get('/users/admins', authController.getUsersAdmins);
router.get('/users/:id', authController.getUsersById);
router.post('/users/register', authController.register);
router.post('/users/login', authController.userLogin);

module.exports = router;