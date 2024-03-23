const { Router } = require('express');
const { requireAuth, requireAdmin } = require('../middleware/authmiddleware');

const router = Router();

const postController = require('../controller/postController');
const commentController = require('../controller/commentController');

// Routes for creating, retrieving, updating, and deleting posts
router.get('/social', requireAuth, postController.showPosts);
router.post('/social', requireAuth, postController.createPost);
router.put('/social/:id', requireAuth, postController.updatePost);
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
