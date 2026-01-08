import mongoose from 'mongoose';

const locationSchema = new mongoose.Schema({

    busNumber : {type : mongoose.Schema.Types.ObjectId, ref : 'Bus', required : true},
    latiitude : {type : Number, required : true},
    longitude : {type : Number, required : true},
    speed : {type : Number, required : true},
    timestamp : {type :Date, required : true}
}, {timestamps : true});

export default mongoose.model('Location', locationSchema);