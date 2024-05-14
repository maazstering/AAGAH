const mongoose = require('mongoose');

// Define the schema for posts
const postSchema = new mongoose.Schema({
  content: {
    type: String,
    required: true
  },
  author: {
    type: String,
    required: true
  },
  createdAt: {
    type: Date,
    default: Date.now
  },
  comments: [String], // Array of comment IDs (if you decide to implement comments later)
  likes: [String], // Array of user IDs who liked the post
  shares: [String], // Array of user IDs who shared the post
  images: [String] // Array of image URLs
});

// Create the Post model based on the schema
const Post = mongoose.model('Post', postSchema);

module.exports = Post;
