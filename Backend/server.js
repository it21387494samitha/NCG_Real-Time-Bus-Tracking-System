import express from 'express';
import mongoose from 'mongoose';
import dotenv from 'dotenv';
import cors from 'cors';
import bodyParser from 'body-parser';

//import routes

import driverRoutes from './routes/driver.routes.js';
import loginRoutes from './routes/auth.route.js';
import addingRoutes from './routes/adding.routes.js';
import locationRoutes from './controllers/locationsController.js';


const app = express();

app.use(cors());
app.use(bodyParser.json());
app.use(express.json());

dotenv.config();

const PORT = process.env.PORT || 8070;

const URL = process.env.MONGODB_URL;
mongoose.connect(URL);

const connection = mongoose.connection;

connection.once('open', () => {
    console.log('Mongodb connection is successfull');
});

app.use('/driver', driverRoutes);
app.use('/auth', loginRoutes);
app.use('/bus-route', addingRoutes);
app.use('/locations', locationRoutes);

app.listen(PORT, () => {
    console.log( `App is running on ${PORT}`);
});