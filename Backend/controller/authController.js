const User = require('../models/User');
const jwt = require('jsonwebtoken'); 

const handleErrors = (err) => { 
    console.log(err.message, err.code);
    let errors = {email: '', password: ''};

    if(err.message === 'incorrect email'){
        errors.email = 'that email is not registered';
    }

    if(err.message === 'incorrect password'){   
        errors.password = 'that password is incorrect';
    }

    if(err.code === 11000){
        errors.email = 'that email is already registered';
        return errors;
    }
    
    // Validation errors
    if(err.message.includes('user validation failed')){
        Object.values(err.errors).forEach(({properties}) => {
            errors[properties.path] = properties.message;
        });
    }
    return errors;
}

const maxAge = 3 * 24 * 60 * 60;
const createToken = (id) => {
    return jwt.sign({ id }, 'hasan secret', {
        expiresIn: maxAge
    });
};

module.exports.signup_post = async (req, res) => {
    const { email, password, name, age } = req.body; 

    try {
        const user = await User.create({ email, password, name, age }); 
        const token = createToken(user._id);
        res.cookie(token, { httpOnly: true, maxAge: maxAge * 1000 });
        res.status(201).json({ user: user._id, token });
    } catch (err) {
        const errors = handleErrors(err);
        res.status(400).json({ errors });
    }
};

module.exports.login_post = async (req, res) => {
    const { email, password } = req.body;

    try {
        const user = await User.login(email, password);
        const token = createToken(user._id);
        res.cookie( token, { httpOnly: true, maxAge: maxAge * 1000 });
        res.status(200).json({ user: user._id, token });
    } catch (err) {
        const errors = handleErrors(err);
        res.status(400).json({ errors });
    }
};

module.exports.logout_get = (req, res) => {
    res.cookie( { maxAge: 1 });
    res.status(200).json({ message: 'Logout successful' });
};

module.exports.delete_user = async (req, res) => {
    const userId = req.params.id;

    try {
        const deletedUser = await User.findByIdAndDelete(userId);
        if (!deletedUser) {
            res.status(404).json({ message: 'User not found' });
            return;
        }
        res.status(200).json({ message: 'User deleted successfully' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Internal server error' });
    }
};

// Add the missing handler functions
module.exports.signup_get = (req, res) => {
    res.send('Signup page');
};

module.exports.login_get = (req, res) => {
    res.send('Login page');
};
