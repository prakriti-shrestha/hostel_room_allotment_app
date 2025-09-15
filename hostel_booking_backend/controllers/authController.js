const User = require('../models/userModel');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

exports.register = (req, res) => {
    const {user_name, email, password, user_role, student_rank} = req.body;

    if(!user_name || !email || !password || !user_role) {
        return res.status(400).json({error: 'name, email, password, role are required'});
    }

    const validRoles = ['admin', 'student'];
    if(!validRoles.includes(user_role)) {
        return res.status(400).json({error: 'Invalid role'});
    }
    if(user_role === 'student' && (student_rank === undefined ||student_rank === null)) {
        return res.status(400).json({error: 'student_rank is required for students'});
    }

    User.getByEmail(email, (err, existing) => {
        if(err) return res.status(500).json({error:err});
        if(existing.length) return res.status(400).json({error:'Email already registered'});
        bcrypt.hash(password, 10, (err, hashedPassword) => {
            if(err) return res.status(500).json({error:err});
        
            const newUser = {user_name, email, password_hash: hashedPassword, user_role, student_rank};

            User.create(newUser, (err, results) => {
                if (err) return res.status(500).json({error:err});
                res.status(201).json({message: 'User registered', userId: results.insertId});
            });
        });
    });
};

exports.getUsers = (req, res) => {
    User.getAll((err, results) => {
        if(err) return res.status(500).json({error:err});
        res.json(results);
    });
};

exports.getUsersAdmins = (req, res) => {
    User.getAllAdmin((err, results) => {
        if(err) return res.status(500).json({error:err});
        res.json(results);
    });
};

exports.getUsersById = (req, res) => {
    const {id} = req.params;
    User.getById(id, (err, results) => {
        if(err) return res.status(500).json({error:err});
        if(results.length === 0) return res.status(404).json({message: 'User not found'});
        res.json(results[0]);
    });
};

exports.userLogin = (req, res) => {
    const {email, password} = req.body;

    if(!email || !password) {
        return res.status(400).json({error: 'Email and password are required'});
    }
    User.getByEmail(email, (err, results) => {
        if (err) return res.status(500).json({error:err});

        if(results.length === 0) {
            return res.status(401).json({error: 'Invalid email or password'});
        }

        const user = results[0];

        bcrypt.compare(password, user.password_hash, (err, isMatch) => {
            if(err) return res.status(500).json({error: err});

            if(!isMatch) {
                return res.status(401).json({error: 'Invalid email or password'});
            }

            if (user.user_role === 'student') {
                const currentTime = new Date();
                const bookingStartTime = new Date(); // You'll set the official start time of booking here
                bookingStartTime.setHours(9, 0, 0, 0); // Example: Booking starts at 9:00 AM

                const groupSize = 10;
                const slotDurationMinutes = 10;

                // Calculate the slot index for the current student
                const slotIndex = Math.floor((user.student_rank - 1) / groupSize);

                // Calculate the student's specific allowed time slot
                const allowedStartTime = new Date(bookingStartTime.getTime() + slotIndex * slotDurationMinutes * 60000);
                const allowedEndTime = new Date(allowedStartTime.getTime() + slotDurationMinutes * 60000);

                // Check if the current time is within the student's allowed slot
                const isAllowed = currentTime >= allowedStartTime && currentTime < allowedEndTime;

                if (!isAllowed) {
                    const formattedStartTime = allowedStartTime.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' });
                    const formattedEndTime = allowedEndTime.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' });

                    return res.status(403).json({
                        error: `It's not your turn to book yet. Your booking window is from ${formattedStartTime} to ${formattedEndTime}.`
                    });
                }
            }

            const token = jwt.sign(
                {userId: user.user_id, role: user.user_role},
                process.env.JWT_SECRET,
                {expiresIn: '1h'}
            );

            res.json({
                message: 'Login successful',
                token,
                user: {
                    id: user.user_id,
                    name: user.user_name,
                    email: user.email,
                    role: user.user_role
                }
            });
        });
    });
};