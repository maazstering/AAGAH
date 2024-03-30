const User = require('../models/User')


const sendFriendRequest = async (req, res) => {
    const senderId = req.user.id
    const recipientId = req.params.id

    const recipient = await User.findById(recipientId)

    if (!recipient) return res.status(404).json({ error: 'Recipient user not found' })

    const sender = await User.findById(senderId)
    if (sender.friends.includes(recipientId) || sender.pendingFriendRequests.includes(recipientId)) {
        return res.status(400).json({ error: 'Friend request already sent or recipient is already a friend' })
    }

    await User.findByIdAndUpdate(recipientId, { $push: { pendingFriendRequests: senderId } })

    res.status(200).json({ message: 'Friend request sent successfully' })
}

const acceptFriendRequest = async (req, res) => {
    const userId = req.user.id
    const friendId = req.params.id
    
    const user = await User.findById(userId)
    
    const friend = await User.findById(friendId)

    if (!user.pendingFriendRequests.includes(friendId)) return res.status(400).json({ error: 'Friend request does not exist' })

    
    await User.findByIdAndUpdate(userId, { $push: { friends: friendId } })
    
    await User.findByIdAndUpdate(userId, { $pull: { pendingFriendRequests: friendId } })

    await User.findByIdAndUpdate(friendId, { $push: { friends: userId } })

    res.status(200).json({ message: 'Friend request accepted successfully' })

}


const rejectFriendRequest = async (req, res) => {
    const userId = req.user.id
    const friendId = req.params.id

    const user = await User.findById(userId)

    user.pendingFriendRequests = user.pendingFriendRequests.filter(request => request.toString() !== friendId)
    await user.save()

    res.status(200).json({ message: 'Friend request rejected successfully' })

}

const getFriendRequests = async (req, res) => {
    const userId = req.user.id

    const user = await User.findById(userId).populate('pendingFriendRequests', 'name email')
    
    if (!user) return res.status(404).json({ error: 'User not found' })

    res.status(200).json({ friendRequests: user.pendingFriendRequests })

}


module.exports = {
    sendFriendRequest,
    acceptFriendRequest,
    rejectFriendRequest,
    getFriendRequests
}
