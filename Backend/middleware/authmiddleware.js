const jwt = require('jsonwebtoken')
const User = require('../models/User')
const config = require('../utils/config')

const requireAdmin = (req, res, next) => {
    if (!res.locals.user || res.locals.user.role !== 'admin') {
        return res.status(403).json({ error: 'Access denied: Admin permissions required.' })
    }
    next()
}

const requireAuth = (req, res, next) => {
    const token = req.header('Authorization')?.replace('Bearer ', '')
    if (token) {
        jwt.verify(token, config.SECRET, (err, decodedToken) => {
            if (err) {
                console.log(err.message);
                res.status(401).json({ error: 'Not authorized' })
            } else {
                console.log(decodedToken)
                req.user = decodedToken
                next()
            }
        })
    } else {
        res.status(401).json({ error: 'Not authorized' })
    }
}


module.exports = { requireAuth, requireAdmin }