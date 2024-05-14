const { Router } = require('express');
const { requireAuth, requireAdmin } = require('../middleware/authmiddleware');
const profileController = require('../controller/profileController');

const router = Router();

router.put('/profile/:id', requireAuth, profileController.update_profile);

module.exports = router;
