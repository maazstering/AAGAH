const jwt = require('jsonwebtoken');
const Post = require('../models/Post');
const User = require('../models/User');
const path = require('path');
const fs = require('fs');

module.exports.createPost = async (req, res) => {
    const token = req.cookies.jwt;
    console.log('Token', token);

    try {
        const { content } = req.body;
        const image = req.file;
    
        // Create a new post instance
        const post = new Post({
          author: req.user.id,
          content,
          imageUrl: image && `/uploads/${image.filename}`,

        });
    
        // Save the post to the database
        await post.save();
    
        res.status(201).json({
          message: 'Post created successfully',
          post,
        });
    }
    catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
};

module.exports.showPosts = async (req, res) => {
    try {
        const page = parseInt(req.query.page) || 1; // Default to page 1 if not provided
        const limit = parseInt(req.query.limit) || 10; // Default to 10 posts per page if not provided
        const skip = (page - 1) * limit;

        const totalPosts = await Post.countDocuments();

        const posts = await Post.find().populate('author').sort({ createdAt: -1 }).skip(skip).limit(limit);
        
        res.status(200).json({
            totalPosts,
            totalPages: Math.ceil(totalPosts / limit),
            currentPage: page,
            posts,
        });
    } catch (error) {
        return res.status(500).json({ message: error.message });
    }
};

module.exports.updatePost = async (req, res) => {
    try {
        const postId = req.params.id;
        const { content } = req.body;
        const image = req.file;

        const post = await Post.findById(postId);

        if (!post) {
            return res.status(404).json({ message: "Post not found" });
        }

        if (post.author.toString() !== req.user.id) {
            return res.status(403).json({ message: "You are not authorized to update this post" });
        }

        post.content = content || post.content;

        if (image) {
            // Optionally, delete the old image file
            if (post.imageUrl) {
              const oldImagePath = path.join(__dirname, post.imageUrl);
              fs.unlink(oldImagePath, (err) => {
                if (err) console.error('Failed to delete old image', err);
              });
            }
            post.imageUrl = `/uploads/${image.filename}`;
        }
      
        await post.save();
        res.status(200).json({message: "Post updated successfully", post});

    } catch (error) {
        return res.status(400).json({ message: error.message });
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

        if (post.imageUrl) {
            const imagePath = path.join(__dirname, post.imageUrl);
            fs.unlink(imagePath, (err) => {
              if (err) console.error('Failed to delete image', err);
            });
        }

        await Post.findByIdAndDelete(postId);

        return res.status(200).json({ message: "Post deleted successfully" });
    } catch (error) {
        return res.status(400).json({ message: error.message });
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

        return res.status(200).json({ message: "Post liked successfully", post });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: 'Internal server error' });
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

        return res.status(200).json({ message: "Post unliked successfully", post });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: 'Internal server error' });
    }
};
