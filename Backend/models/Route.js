const mongoose = require('mongoose');

const RouteSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    name: { type: String, required: true },
    waypoints: [
        {
            lat: { type: Number, required: true },
            lng: { type: Number, required: true }
        }
    ],
    createdAt: { type: Date, default: Date.now }
});

const Route = mongoose.model('Route', RouteSchema);

module.exports = Route;
