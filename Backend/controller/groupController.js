const Group = require('../models/Group');
const User = require('../models/User');

const groupController = {
    createGroup: async (req, res) => {
        const { name } = req.body;
        const userId = req.user.id;
        const admin = userId;

        try {

            const newGroup = new Group({ name, admin });
            await newGroup.save();
            res.status(201).json({ message: "Group created successfully", group: newGroup });
        } catch (err) {
            console.error(err);
            res.status(500).json({ message: 'Internal server error' });
        }
    },

    addUserToGroup: async (req, res) => {
        const { groupId, userId } = req.params;
        try {
            const group = await Group.findById(groupId);
            if (!group) {
                return res.status(404).json({ message: 'Group not found' });
            }
            if (!group.members.includes(userId)) {
                group.members.push(userId);
                await group.save();
                res.status(200).json({ message: "User added to the group successfully", group });
            } else {
                res.status(400).json({ message: "User already in the group" });
            }
        } catch (err) {
            console.error(err);
            res.status(500).json({ message: 'Internal server error' });
        }
    },

    listGroups: async (req, res) => {
        try {
            const groups = await Group.find({ members: { $in: [req.user.id] } });
            res.status(200).json(groups);
        } catch (err) {
            console.error(err);
            res.status(500).json({ message: 'Internal server error' });
        }
    },
    updateGroup: async (req, res) => {
        const { groupId } = req.params;
        const { newName, newDescription } = req.body;
        try {
            const updatedGroup = await Group.findByIdAndUpdate(groupId, { name: newName, description: newDescription }, { new: true });
            res.status(200).json({ message: 'Group updated successfully', group: updatedGroup });
        } catch (err) {
            console.error(err);
            res.status(500).json({ message: 'Internal server error' });
        }
    }
};

module.exports = groupController;
