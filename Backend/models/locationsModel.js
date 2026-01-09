// locationsModel.js
import { supabase } from '../supabaseClient.js';

const Locations = {
  tableName: 'locations',

  async add({ busNumber, latitude, longitude, speed, timestamp }) {
    const { data, error } = await supabase
      .from(this.tableName)
      .insert([
        {
          busnumber: busNumber,
          latitude,
          longitude,
          speed,
          timestamp: new Date(timestamp)
        }
      ])
      .select(); // returns inserted row

    if (error) throw error;
    return data;
  },

  // Get latest location of a bus
  async getLatest(busNumber) {
    const { data, error } = await supabase
      .from(this.tableName)
      .select('*')
      .eq('busnumber', busNumber)
      .order('timestamp', { ascending: false }) // latest first
      .limit(1); // only one row

    if (error) throw error;
    return data[0]; // returns the latest location
  }
};

export default Locations;



