const User = require('../models/User');

const profileController = {
    update_profile: async (req, res) => {
        try {
            const userId = req.user.id;
            const { name,age } = req.body;

            if (!name || !age) {
                return res.status(400).json({ error: "Name and bio are required" });
            }

            const updatedProfile = await User.findByIdAndUpdate(userId, { name, age }, { new: true });

            res.json(updatedProfile);
        } catch (err) {
            console.error(err);
            res.status(500).json({ message: 'Internal server error' });
        }
    }
};

module.exports = profileController;
