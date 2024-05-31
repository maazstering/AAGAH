const User = require('../models/User');
const Post = require('../models/Post');
const fs = require('fs');
const path = require('path');

const jwt = require('jsonwebtoken');
const multer = require('multer');

// Set up multer storage for file uploads
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'uploads/'); // Save to uploads folder
    },
    filename: function (req, file, cb) {
        cb(null, Date.now() + '-' + file.originalname); // Append the date and the original file extension
    }
});

// Initialize multer upload middleware
const upload = multer({
    storage: storage,
    limits: { fileSize: 10 * 1024 * 1024 }, // Set file size limit to 10MB or adjust as needed
});

const profileController = {
    getCurrentUser: async (req, res) => {
        try {
            const userId = req.user.id;
            const currentUser = await User.findById(userId);
    
            const getImageBase64 = async (imagePath) => {
                const imageAsBase64 = fs.readFileSync(path.resolve(imagePath), 'base64');
                return `data:image/jpeg;base64,${imageAsBase64}`;
            };
    
            const userImageBase64 = await getImageBase64(currentUser.imageUrl);
    
            const userWithImageBase64 = {
                ...currentUser.toObject(),
                imageUrl: userImageBase64
            };
    
            res.status(200).json(userWithImageBase64);
        } catch (error) {
            console.error(error);
            res.status(500).json({ message: 'Internal server error' });
        }
    },

    getFriendInfo: async (req, res) => {
        try {
            // Extract friend id from request parameters
            const { friendId } = req.params;
    
            // Find the friend by id, excluding the password field
            const friend = await User.findById(friendId).select('-password');
    
            // Check if the friend exists
            if (!friend) {
                return res.status(404).json({ message: "Friend not found" });
            }
    
            // Function to read image as base64
            const getImageBase64 = async (imagePath) => {
                const imageAsBase64 = fs.readFileSync(path.resolve(imagePath), 'base64');
                return `data:image/jpeg;base64,${imageAsBase64}`;
            };
    
            // Get base64 representation of the friend's image
            const friendImageBase64 = await getImageBase64(friend.imageUrl);
    
            // Construct the friend object with base64 image
            const friendWithImageBase64 = {
                ...friend.toObject(),
                imageUrl: friendImageBase64
            };
    
            // Send the friend information with base64 image in the response
            res.status(200).json(friendWithImageBase64);
        } catch (error) {
            console.error(error);
            res.status(500).json({ message: 'Internal server error' });
        }
    },
    
    getUserByid: async (req, res) => {
        try {
            const userId = req.params.id;
            const user = await User.find({_id: userId})
            if (!user) res.status(404).end()
            res.status(200).json(user)
        }
        catch (error) {
            res.status(500).json({ message: error.message });
        }
    },

    update_profile: async (req, res) => {
        try {
            const userId = req.user.id;
            const { name, birthDate } = req.body;

            if (!name || !birthDate) {
                return res.status(400).json({ error: "Name and age are required" });
            }

            const updatedProfile = await User.findByIdAndUpdate(userId, { name, birthDate: new Date(birthDate) }, { new: true });

            res.status(200).json(updatedProfile);
        } catch (err) {
            console.error(err);
            res.status(500).json({ message: 'Internal server error' });
        }
    },

    getUserPosts: async (req, res) => {
        try {
            const userId = req.params.userId;
    
            // Query the database for posts authored by the specified user
            const posts = await Post.find({ author: userId });
    
            // Return the posts as JSON response
            res.status(200).json(posts);
        } catch (error) {
            // Handle errors
            console.error(error);
            res.status(500).json({ message: 'Internal server error' });
        }
    },

    getCurrentUserPosts: async (req, res) => {
        try {
            const userId = req.user.id;
    
            // Query the database for posts authored by the current user
            const posts = await Post.find({ author: userId });
    
            // Return the posts as JSON response
            res.status(200).json(posts);
        } catch (error) {
            // Handle errors
            console.error(error);
            res.status(500).json({ message: 'Internal server error' });
        }
    },

    updateSelfProfile: async (req, res) => {
        try {
            const userId = req.user.id;
            const { name, email, birthDate } = req.body;
    
            if (!name || !birthDate) {
                return res.status(400).json({ error: "Name and age are required" });
            }
    
            // Check if there's an uploaded image
            let imageUrl = '';
            if (req.file) {
                imageUrl = req.file.path; // Path where the image is stored
            }
    
            // Update user information, including the image URL if available
            const updatedProfile = await User.findByIdAndUpdate(
                userId,
                { name, age, email, imageUrl, birthDate: new Date(birthDate) }, // Include imageUrl in the update
                { new: true }
            );
    
            res.status(200).json(updatedProfile);
            console.log('Profile updated successfully');
        } catch (err) {
            console.error(err);
            res.status(500).json({ message: 'Internal server error' });
        }
    },

    showUserPosts: async (req, res) => {
        try {
            const token = req.headers.authorization.split(' ')[1];
            jwt.verify(token, 'hasan secret', async (err, decodedToken) => {
                if (err) {
                    res.status(401).json({ message: 'Unauthorized' });
                } else {
                    const user = await User.findById(decodedToken.id).populate('friends');
    
                    const posts = await Post.find({ author: user._id })
                        .populate('author')
                        .populate({
                            path: 'comments',
                            populate: {
                                path: 'author',
                                select: '_id name imageUrl'
                            }
                        });
    
                    const getImageBase64 = async (imagePath) => {
                        const imageAsBase64 = fs.readFileSync(path.resolve(imagePath), 'base64');
                        return `data:image/jpeg;base64,${imageAsBase64}`;
                    };
    
                    const postsWithImages = await Promise.all(posts.map(async post => {
                        const postImageBase64 = await getImageBase64(post.imageUrl);
                        const authorImageBase64 = await getImageBase64(post.author.imageUrl);
    
                        const commentsWithImages = await Promise.all(post.comments.map(async comment => {
                            const commentAuthorImageBase64 = await getImageBase64(comment.author.imageUrl);
                            return {
                                ...comment._doc,
                                author: {
                                    ...comment.author._doc,
                                    imageUrl: commentAuthorImageBase64
                                }
                            };
                        }));
    
                        return {
                            ...post._doc,
                            imageBase64: postImageBase64,
                            author: {
                                ...post.author._doc,
                                imageUrl: authorImageBase64
                            },
                            comments: commentsWithImages
                        };
                    }));
    
                    res.status(200).json(postsWithImages);
                }
            });
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    },

    getUserByid: async (req, res) => {
        try {
            const userId = req.params.id;
            const user = await User.find({_id: userId})
            if (!user) res.status(404).end()
            res.status(200).json(user)
        }
        catch (error) {
            res.status(500).json({ message: error.message });
        }
    }   
};

module.exports = profileController;
