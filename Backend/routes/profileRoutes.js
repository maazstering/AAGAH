const { Router } = require('express');
const { requireAuth, requireAdmin } = require('../middleware/authmiddleware');
const profileController = require('../controller/profileController');

const multer = require('multer');


const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'uploads/'); // Save to uploads folder
    },
    filename: function (req, file, cb) {
        cb(null, Date.now() + '-' + file.originalname); // Append the date and the original file extension
    }
});

// Increase the file size limit (default is 1MB)
const upload = multer({
    storage: storage,
    limits: { fileSize: 10 * 1024 * 1024 }, // Increase to 10MB or adjust as needed
});



const router = Router();

router.get('/currentUser', requireAuth, profileController.getCurrentUser);

router.get('/friendinfo/:friendId', requireAuth, profileController.getFriendInfo);


router.get('/showUserPosts', requireAuth, profileController.showUserPosts)

router.get('/:userId/posts', requireAuth, profileController.getUserPosts);

router.get('/selfProfile', requireAuth, profileController.getCurrentUserPosts);

router.put('/selfProfile', upload.single('image'), requireAuth, profileController.updateSelfProfile);

router.put('/selfProfile/:id', requireAuth, profileController.update_profile);

router.get('/users/:id', requireAuth, profileController.getUserByid)

module.exports = router;