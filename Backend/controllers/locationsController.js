import express from 'express';
import Locations from '../models/locationsModel.js';  

const router = express.Router();

router.post('/add-location', async (req, res) => {
  try {
    const { busNumber, latitude, longitude, speed, timestamp } = req.body;

    // validation
    if (!busNumber || !latitude || !longitude || !speed || !timestamp) {
      return res.status(400).json({ message: 'All fields are required.' });
    }

    const data = await Locations.add({ busNumber, latitude, longitude, speed, timestamp });

    res.status(201).json({ message: 'Location saved successfully!', data });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

export default router;

