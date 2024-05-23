const Route = require('../models/Route')

module.exports.createSavedRoute = async (req, res) => {
    try {
        const { waypoints, name } = req.body

        if (!name || !waypoints || !Array.isArray(waypoints)) {
            return res.status(400).json({error: 'Invalid data'})
        }

        const route = new Route({
            userId: req.user.id,
            name,
            waypoints
        });

        const savedRoute = await route.save()
        res.status(201).json(savedRoute)
    } catch (error) {
        res.status(500).json({error: 'Server error'});
    }
}

module.exports.getSavedRoute = async (req, res) => {
    try {
        const route = await Route.find({ userId: req.user.id })
        if (route.length === 0) {
            return res.status(404).json({error: 'Route not found'})
        }
        res.status(200).json(route)
    } catch (error) {
        res.status(500).json({error: 'Server error'})
    }
}

module.exports.updateSavedRoute = async (req, res) => {
    try {
        const { name, waypoints } = req.body;

        if (!name || !waypoints || !Array.isArray(waypoints)) {
            return res.status(400).json({error: 'Invalid data'});
        }

        const route = await Route.findOneAndUpdate(
            { userId: req.user.id, _id: req.params.id },
            { name, waypoints },
            { new: true }
        );

        if (!route) {
            return res.status(404).json({error: 'Route not found'});
        }

        res.status(200).json(route);
    } catch (error) {
        res.status(500).send('Server error');
    }
}

module.exports.deleteSavedRoute = async (req, res) => {
    try {
        const route = await Route.findOneAndDelete({ userId: req.user.id, _id: req.params.id });
        if (!route) {
            return res.status(404).json({error: 'Route not found'});
        }
        res.status(200).json({message: 'Route deleted'});
    } catch (error) {
        res.status(500).send({error: 'Server error'});
    }
}