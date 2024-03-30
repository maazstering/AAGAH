const Group = require('../models/Group')
const User = require('../models/User')


const createGroup = async (req, res) => {
    const { name } = req.body
    const userId = req.user.id
    const admin = userId

    const newGroup = new Group({ name, admin })
    await newGroup.save()
    res.status(201).json({ message: "Group created successfully", group: newGroup })

}

const addUserToGroup = async (req, res) => {
    const { groupId, userId } = req.params
    
    const group = await Group.findById(groupId)
    if (!group) {
        return res.status(404).json({ message: 'Group not found' })
    }
    if (!group.members.includes(userId)) {
        group.members.push(userId)
        await group.save()
        res.status(200).json({ message: "User added to the group successfully", group })
    } else {
        res.status(400).json({ message: "User already in the group" })
    }
}

const listGroups = async (req, res) => {
    
    const groups = await Group.find({ members: { $in: [req.user.id] } })
    res.status(200).json(groups)
    
}

const updateGroup = async (req, res) => {
    const { groupId } = req.params
    const { newName, newDescription } = req.body

    const updatedGroup = await Group.findByIdAndUpdate(groupId, { name: newName, description: newDescription }, { new: true })
    res.status(200).json({ message: 'Group updated successfully', group: updatedGroup })
}


module.exports = {
    createGroup,
    addUserToGroup,
    listGroups,
    updateGroup
}
