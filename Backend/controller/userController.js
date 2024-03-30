const User = require('../models/User');


const reportUser = async (req, res) => {
    
    const { reportedId, reason } = req.body
    const reporterId = req.user.id
    
    await User.findByIdAndUpdate(reportedId, {
        $push: { reports: { reportedBy: reporterId, reason: reason } }
    })

    res.status(200).json({ message: 'User reported successfully' })
    
}


const blockUser = async (req, res) => {
    const { userId } = req.params
    
    await User.findByIdAndUpdate(userId, { isBlocked: true })

    res.status(200).json({ message: 'User blocked successfully' })
}

module.exports = {
    reportUser,
    blockUser
}
