const { Router } = require('express');
const { requireAuth } = require('../middleware/authmiddleware');
const groupController = require('../controller/groupController'); 


const router = Router();

// Route to create a new group
router.post('/create', requireAuth, groupController.createGroup);

// Route to add a user to a group
router.post('/:groupId/addUser/:userId', requireAuth, groupController.addUserToGroup);

// Route to list all groups for the logged-in user
router.get('/myGroups', requireAuth, groupController.listGroups);

// Route for updating group details
router.put('/:groupId', requireAuth, groupController.updateGroup);

module.exports = router;
