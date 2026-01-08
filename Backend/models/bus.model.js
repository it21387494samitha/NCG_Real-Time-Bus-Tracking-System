import mongoose from "mongoose";

const busShcema = new mongoose.Schema({

    busNumber : {type : String, required : true, unique : true},
    driverName : {type : String, required : true},
    routeNumber : {type : mongoose.Schema.Types.ObjectId, ref : "Route", required : true},
    currentLocation : {
        longitude : {type : Number, required : true},
        latitude : {type : Number, required : true},
        timestamp : {type : Date}
    },
    status : {type : String, enum : ['active', 'inactive'], default : 'inactive' }

}, {timestamps : true});

export default mongoose.model('Bus', busShcema);