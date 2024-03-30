/*const jwt = require('jsonwebtoken');
const User = require('../models/User');

const requireAdmin = (req, res, next) => {
    if (!res.locals.user || res.locals.user.role !== 'admin') {
        return res.status(403).json({ error: 'Access denied: Admin permissions required.' });
    }
    next();
};

const requireAuth = (req, res, next) => {
    const token = req.header('Authorization')?.replace('Bearer ', '');
    if (token) {
        jwt.verify(token, 'hasan secret', (err, decodedToken) => {
            if (err) {
                console.log(err.message);
                res.status(401).json({ error: 'Not authorized' });
            } else {
                console.log(decodedToken);
                req.user = decodedToken;
                next();
            }
        });
    } else {
        res.status(401).json({ error: 'Not authorized' });
    }
};

const checkUser = (req, res, next) => {
    const token = req.header('Authorization')?.replace('Bearer ', '');
    if (token) {
        jwt.verify(token, 'hasan secret', async (err, decodedToken) => {
            if (err) {
                console.log(err.message);
                res.locals.user = null;
                next(); // Continue without setting the user as this middleware doesn't block requests
            } else {
                try {
                    let user = await User.findById(decodedToken.id);
                    res.locals.user = user ? {
                        id: user.id,
                        email: user.email,
                        role: user.role
                    } : null;
                    next();
                } catch (userErr) {
                    // If there's an error fetching the user, log it and set user to null
                    console.log(userErr.message);
                    res.locals.user = null;
                    next();
                }
            }
        });
    } else {
        res.locals.user = null;
        next();
    }
};


module.exports = { requireAuth, checkUser,requireAdmin };
// module.exports = { requireAuth };

*/


const jwt = require('jsonwebtoken');
const User = require('../models/User');


const requireAdmin = (req, res, next) => {
    if (!res.locals.user || res.locals.user.role !== 'admin') {
        return res.status(403).json({ error: 'Access denied: Admin permissions required.' });
    }
    next();
};

const requireAuth = (req, res, next) => {
    const token = req.cookies.jwt;
    if(token){
        jwt.verify(token, 'hasan secret', (err, decodedToken) => {
            if(err){
                console.log(err.message);
                res.redirect('/login');
            }else{
                console.log(decodedToken);
                req.user = decodedToken;
                next();
            }
        });
    }else{
        res.redirect('/login');
    }
}

const checkUser = (req, res, next) => {
    const token = req.cookies.jwt;
    if(token){
        jwt.verify(token, 'hasan secret', async (err, decodedToken) => {
            if(err){
                console.log(err.message);
                res.locals.user = null;
                next();
            }else{
                let user = await User.findById(decodedToken.id);
                res.locals.user = {
                    id: user.id,
                    email: user.email,
                    role: user.role 
                };
                next();
            }
        });
    }
    else{
        res.locals.user = null;
        next();
    }
}


module.exports = { requireAuth, checkUser,requireAdmin };
// module.exports = { requireAuth };