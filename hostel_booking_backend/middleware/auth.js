const jwt = require('jsonwebtoken');

function authenticateToken(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    if(!token) return res.status(401).json({error: 'No token provided'});

    jwt.verify(token, process.env.JWT_SECRET, (err, payload) => {
        if(err) return res.status(403).json({error: 'Invalid/expired token'});
        req.user = payload;
        next();
    });
}

function authorizeRoles(...roles) {
    return (req, res, next) => {
        if(!req.user?.role || !roles.includes(req.user.role)) {
            return res.status(403).json({error: 'Forbidden: insufficient role'});
        }
        next();
    };
}

module.exports = {authenticateToken, authorizeRoles};