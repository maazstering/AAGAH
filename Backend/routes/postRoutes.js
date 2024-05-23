const { Router } = require('express');
const { requireAuth, requireAdmin } = require('../middleware/authmiddleware');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

const router = Router();

const postController = require('../controller/postController');
const commentController = require('../controller/commentController');

// Set up storage engine using multer
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
      const uploadPath = 'uploads/';
      // Ensure the directory exists
      if (!fs.existsSync(uploadPath)) {
        fs.mkdirSync(uploadPath, { recursive: true });
      }
      cb(null, uploadPath);
    },
    filename: function (req, file, cb) {
      cb(null, Date.now() + path.extname(file.originalname));
    },
});
  
// Initialize multer with the defined storage engine
const upload = multer({ storage: storage });


// Routes for creating, retrieving, updating, and deleting posts
//removing auth in show post for now: 
//router.get('/social', requireAuth, postController.showPosts);
//removed require auth for now 
router.get('/social',requireAuth, postController.showPosts);
router.post('/social', requireAuth,  upload.single('image'), postController.createPost);
router.put('/social/:id', requireAuth, upload.single('image'), postController.updatePost);

// Middleware to ensure all responses are JSON
router.use((req, res, next) => {
    res.setHeader('Content-Type', 'application/json');
    next();
});

router.delete('/social/:id', requireAuth, postController.deletePost);

// Routes for comments
router.post('/social/:postId/comments', requireAuth, commentController.createComment);
router.get('/social/:postId/comments', requireAuth, commentController.getCommentsByPostId);
router.put('/social/comments/:commentId', requireAuth, commentController.updateComment);
router.delete('/social/comments/:commentId', requireAuth, commentController.deleteComment);

// Routes for likes
router.post('/social/:postId/like', requireAuth, postController.likePost);
router.delete('/social/:postId/like', requireAuth, postController.unlikePost);

module.exports = router;
