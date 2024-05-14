const express = require('express');
const { reportUser, blockUser } = require('../controller/userController');

const { requireAuth } = require('../middleware/authmiddleware');

const router = express.Router();

router.post('/report', requireAuth, reportUser);
router.post('/block/:userId', requireAuth, blockUser);

module.exports = router;
