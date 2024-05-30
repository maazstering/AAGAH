const mongoose = require('mongoose');
const { isEmail } = require('validator');
const bcrypt = require('bcrypt');
const { formatDate } = require('../utils/helper')

const userSchema = new mongoose.Schema({
    email: {
        type: String,
        required: [true, 'Please enter an email'],
        unique: true,
        lowercase: true,
        validate: [isEmail, 'Please enter a valid email']
    },
    password: {
        type: String,
        required: [true, 'Please enter a password'],
        minlength: [6, 'Minimum password length is 6 characters']
    },
    name: {
        type: String,
        required: [true, 'Please enter a name']
    },
    birthDate: {
        type: Date,
        required: false
    },
    role: {
        type: String,
        enum: ['user', 'admin', 'moderator'],
        default: 'user'
    },
    bio: {
        type: String,
        required: [false]
    }
        ,
    posts: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'Post' // Reference to the Post model
        }
    ],
    shares: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'Post' // Reference to the Post model
        }
    ],
    friends: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User'
        }
    ],
    pendingFriendRequests: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User'
        }
    ],
    isBlocked: { type: Boolean, default: false },
    reports: [{ 
        reportedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
        reason: String,
        createdAt: { type: Date, default: Date.now }
    },
    ],
    resetPasswordToken: { type: String },
    resetPasswordExpires: { type: Date },
});

// Fire a function before doc saved to db
userSchema.pre('save', async function (next) {
    const salt = await bcrypt.genSalt();
    this.password = await bcrypt.hash(this.password, salt);
    next();
});

// Fire a function after doc saved to db
userSchema.post('save', function (doc, next) {
    console.log('New user was created and saved', doc);
    next();
});

// Static method to login user
userSchema.statics.login = async function (email, password) {
    const user = await this.findOne({ email });
    if (user) {
        const auth = await bcrypt.compare(password, user.password);
        if (auth) {
            return user;
        }
        throw Error('Incorrect password');
    }
    throw Error('Incorrect email');
};

userSchema.virtual('formattedBirthDate').get(function() {
    return formatDate(this.birthDate);
});

userSchema.set('toJSON', { virtuals: true });
userSchema.set('toObject', { virtuals: true });

const User = mongoose.model('User', userSchema);

module.exports = User;
