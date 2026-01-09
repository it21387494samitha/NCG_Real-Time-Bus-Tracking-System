import { GoogleMap, LoadScript } from "@react-google-maps/api";

const containerStyle = {
  width: "100%",
  height: "100vh",
};

const center = {
  lat: 6.9271,   // Colombo (temporary center)
  lng: 79.8612,
};

const GoogleMapView = () => {
  return (
    <LoadScript googleMapsApiKey={process.env.NEXT_PUBLIC_GOOGLE_MAPS_API_KEY as string}>
      <GoogleMap
        mapContainerStyle={containerStyle}
        center={center}
        zoom={12}
      >
        {/* Bus markers will come here later */}
      </GoogleMap>
    </LoadScript>
  );
};

export default GoogleMapView;
