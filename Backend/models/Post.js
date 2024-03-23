const mongoose = require('mongoose');


// Define the Post schema
const postSchema = new mongoose.Schema({
    content: {
        type: String,
        required: true
    },
    author: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    comments: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Comment'
    }],
    likes: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    }],
    shares: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    }],
    createdAt: {
        type: Date,
        default: Date.now
    }
    ,
    images: [{ 
        type: String // Assuming images are stored as URLs
    }],
});


//Fire a function before the doc is saved to the database
postSchema.pre('save', async function(next){
    console.log('Post about to be saved', this);
    next();
});

//Fire a function after the doc is saved to the database
postSchema.post('save', function(doc, next){
    console.log('Post has been saved', doc);
    next();
});

// Create the Post model
const Post = mongoose.model('Post', postSchema);

module.exports = Post;
