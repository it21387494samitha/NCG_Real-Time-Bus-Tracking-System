import mongoose from 'mongoose';

const permitSchema = new mongoose.Schema({

    permitId : {type : String, required : true, unique : true},
    buses : [{
        busNumber : {type : mongoose.Schema.Types.ObjectId, ref : 'Bus'}
     }],
     routeName : {type : mongoose.Schema.Types.ObjectId, ref : 'Route'},
     start : {type : String, required : true},
     destination : {type : String, required : true}

}, {timestamps : true});

export default mongoose.model('Permit', permitSchema);