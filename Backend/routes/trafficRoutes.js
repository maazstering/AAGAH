const { Router } = require('express')
const { requireAuth } = require('../middleware/authmiddleware')
const waypointController = require('../controller/routeController')


const router = Router()

router.post('/waypoints', requireAuth, waypointController.createSavedRoute)
router.get('/waypoints', requireAuth, waypointController.getSavedRoute)
router.put('/waypoints/:id', requireAuth, waypointController.updateSavedRoute)
router.delete('/waypoints/:id', requireAuth, waypointController.deleteSavedRoute)

module.exports = router