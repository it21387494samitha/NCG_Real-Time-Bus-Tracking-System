import { supabase } from '../supabaseClient.js'; // correct relative path

const Locations = {
  tableName: 'locations',

  async add({ busNumber, latitude, longitude, speed, timestamp }) {
    const { data, error } = await supabase
  .from(this.tableName)
  .insert([
    {
      busnumber: busNumber, // lowercase column
      latitude,
      longitude,
      speed,
      timestamp: new Date(timestamp)
    }
  ])
  .select(); // <-- add this to return the inserted row


    if (error) throw error;
    return data;
  }
};

export default Locations;


