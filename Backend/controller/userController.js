const User = require('../models/User');

const userController = {
    reportUser: async (req, res) => {
        try {
            const { reportedId, reason } = req.body;
            const reporterId = req.user.id; 
            await User.findByIdAndUpdate(reportedId, {
                $push: { reports: { reportedBy: reporterId, reason: reason } }
            });

            res.status(200).json({ message: 'User reported successfully' });
        } catch (err) {
            console.error(err);
            res.status(500).json({ message: 'Internal server error' });
        }
    },
    blockUser: async (req, res) => {
        try {
            const { userId } = req.params;
            
            await User.findByIdAndUpdate(userId, { isBlocked: true });

            res.status(200).json({ message: 'User blocked successfully' });
        } catch (err) {
            console.error(err);
            res.status(500).json({ message: 'Internal server error' });
        }
    }
};

module.exports = userController;
