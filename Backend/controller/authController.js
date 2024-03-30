const helper = require('../utils/helper')
const User = require('../models/User')

const signup_get = (req, res) => res.render('signup')

const login_get = (req, res) => res.render('login')

const signup_post = async (req, res) => {
    const { email, password, name, age } = req.body
  
    const user = await User.create({ email, password, name, age })
    const token = helper.createToken(user._id)
    res.cookie('jwt', token, { httpOnly: true, maxAge: helper.maxAge * 1000 })
    res.status(201).json({ user: user._id })
}

const login_post = async (req, res) => {
    const { email, password } = req.body

    const user = await User.login(email, password)
    const token = helper.createToken(user._id)
    res.cookie('jwt', token, { httpOnly: true, maxAge: helper.maxAge * 1000 })
    res.status(200).json({ user: user._id })
}

const logout_get = (req, res) => {
    res.cookie('jwt', '', { maxAge: 1 })
    res.redirect('/login')
}

const delete_user = async (req, res) => {
    const userId = req.params.id

    const deletedUser = await User.findByIdAndDelete(userId)

    if (!deletedUser) return res.status(404).json({ message: 'User not found' })

    res.status(200).json({ message: 'User deleted successfully' })
}

module.exports = {
    signup_get,
    login_get,
    signup_post,
    login_post,
    logout_get,
    delete_user
}
