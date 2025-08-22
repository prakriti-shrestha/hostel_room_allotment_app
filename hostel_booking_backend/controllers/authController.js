const User = require('../models/userModel');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

exports.register = (req, res) => {
    const {user_name, email, password, user_role, student_rank} = req.body;

    bcrypt.hash(password, 10, (err, hashedPassword) => {
        if(err) return res.status(500).json({error:err});
    
        const newUser = {user_name, email, password_hash: hashedPassword, user_role, student_rank};

        User.create(newUser, (err, results) => {
            if (err) return res.status(500).json({error:err});
            res.status(201).json({message: 'User registered', userId: results.insertId});
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