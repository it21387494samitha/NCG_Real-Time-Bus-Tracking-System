import express from 'express';
import Locations from '../models/locationsModel.js';  

import { broadcastBusLocation } from '../wsServer.js';

const router = express.Router();

router.post('/add-location', async (req, res) => {
  try {
    const { busNumber, latitude, longitude, speed, timestamp } = req.body;

    // validation
    if (!busNumber || !latitude || !longitude || !speed || !timestamp) {
      return res.status(400).json({ message: 'All fields are required.' });
    }

    const data = await Locations.add({ busNumber, latitude, longitude, speed, timestamp });

    // Broadcast new location to all connected WebSocket clients
    broadcastBusLocation({
      busNumber,
      latitude,
      longitude,
      speed,
      timestamp
    });


    res.status(201).json({ message: 'Location saved successfully!', data });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// GET latest location of a bus
router.get('/latest/:busNumber', async (req, res) => {
  try {
    const busNumber = req.params.busNumber;

    const latestLocation = await Locations.getLatest(busNumber);

    if (!latestLocation) {
      return res.status(404).json({ message: 'No location found for this bus.' });
    }

    res.status(200).json({ message: 'Latest location retrieved', data: latestLocation });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

export default router;

