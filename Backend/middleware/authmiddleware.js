const jwt = require('jsonwebtoken');
const User = require('../models/User');

const requireAdmin = (req, res, next) => {
    if (!res.locals.user || res.locals.user.role !== 'admin') {
        return res.status(403).json({ error: 'Access denied: Admin permissions required.' });
    }
    next();
};

const requireAuth = (req, res, next) => {
    const token = req.cookies.jwt || req.headers.authorization?.split(' ')[1];
    console.log(token);
    if (token) {
        jwt.verify(token, 'hasan secret', (err, decodedToken) => {
            
            if (err) {
                console.log(err.message);
                
                return res.status(401).json({ message: 'Unauthorized' });
            } else {
                req.user = decodedToken;
                next();
            }
        });
    } else {
        res.status(401).json({ message: 'Unauthorized' });
    }
};


const checkUser = (req, res, next) => {
    const token = req.cookies.jwt;
    if (token) {
        jwt.verify(token, 'hasan secret', async (err, decodedToken) => {
            if (err) {
                console.log(err.message);
                res.locals.user = null;
                next();
            } else {
                let user = await User.findById(decodedToken.id);
                res.locals.user = {
                    id: user.id,
                    email: user.email,
                    role: user.role 
                };
                next();
            }
        });
    } else {
        res.locals.user = null;
        next();
    }
}

module.exports = { requireAuth, checkUser, requireAdmin };
