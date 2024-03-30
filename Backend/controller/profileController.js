const User = require('../models/User')


const update_profile = async (req, res) => {
    
    const userId = req.user.id
    const { name, age } = req.body

    if (!name || !age) return res.status(400).json({ error: "Name and bio are required" })

    const updatedProfile = await User.findByIdAndUpdate(userId, { name, age }, { new: true })

    res.json(updatedProfile)

}


module.exports = {
    update_profile
}
