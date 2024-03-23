const jwt = require('jsonwebtoken');
const Post = require('../models/Post');
const User = require('../models/User');
const multer = require('multer');

module.exports.createPost = async (req, res) => {
    const token = req.cookies.jwt;
    console.log('Token', token);

    const storage = multer.diskStorage({
        destination: function(req, file, cb) {
            cb(null, 'public/uploads/'); 
        },
        filename: function(req, file, cb) {
            cb(null, Date.now() + '-' + file.originalname);
        }
    });

    const upload = multer({ storage: storage });
    if (token) {
        jwt.verify(token, 'hasan secret', async (err, decodedToken) => {
            if (err) {
                console.log(err.message);
                res.locals.user = null;
                next();
            } else {
                console.log(decodedToken);
                let user = await User.findById(decodedToken.id);
                res.locals.user = {
                    id: user.id,
                    email: user.email,
                    role: user.role 
                };
                try 
                {
                    const author = decodedToken.id; 
                    console.log('User Current', decodedToken.id);
                    const { content } = req.body;
                    console.log( 'Content', content, ' Author', author);
                    const newPost = await Post.create({ content, author });
                    
                    console.log('New Post', newPost);
                    res.redirect('/social'); 
                } catch (error) {
                    res.status(400).json({ message: error.message });
                }
            }
        });
    }
    else {
        res.locals.user = null;
        // next();
    }

};


module.exports.showPosts = async (req, res) => {
    try {
        const posts = await Post.find().populate('author');
        res.render('social', { posts }); 
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
    
};


module.exports.updatePost = async (req, res) => {
    try {
        const postId = req.params.id;
        const { content } = req.body;
        
        const post = await Post.findById(postId);
        
        if (!post) {
            return res.status(404).json({ message: "Post not found" });
        }
        
        if (post.author.toString() !== req.user.id) {
            return res.status(403).json({ message: "You are not authorized to update this post" });
        }
        
        const updatedPost = await Post.findByIdAndUpdate(postId, { content }, { new: true });
        
        res.status(200).json({ message: "Post updated successfully", post: updatedPost });
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

module.exports.deletePost = async (req, res) => {
    try {
        const postId = req.params.id;
        
        const post = await Post.findById(postId);
        
        if (!post) {
            return res.status(404).json({ message: "Post not found" });
        }
        
        if (post.author.toString() !== req.user.id) {
            return res.status(403).json({ message: "You are not authorized to delete this post" });
        }
        
        await Post.findByIdAndDelete(postId);
        
        res.status(200).json({ message: "Post deleted successfully" });
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

module.exports.likePost = async (req, res) => {
    try {
        const postId = req.params.postId;
        const userId = req.user.id; 

        const post = await Post.findById(postId);

        if (!post) {
            return res.status(404).json({ message: "Post not found" });
        }

        if (post.likes.includes(userId)) {
            return res.status(400).json({ message: "You have already liked this post" });
        }

        post.likes.push(userId);

        await post.save();

        res.status(200).json({ message: "Post liked successfully", post });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
};

module.exports.unlikePost = async (req, res) => {
    try {
        const postId = req.params.postId;
        const userId = req.user.id; 

        const post = await Post.findById(postId);

        if (!post) {
            return res.status(404).json({ message: "Post not found" });
        }

        if (!post.likes.includes(userId)) {
            return res.status(400).json({ message: "You have not liked this post" });
        }

        post.likes = post.likes.filter(id => id !== userId);

        await post.save();

        res.status(200).json({ message: "Post unliked successfully", post });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
};
