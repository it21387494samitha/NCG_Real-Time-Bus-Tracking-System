import dynamic from "next/dynamic";
import type { NextPage } from "next";

// Dynamically import GoogleMapView with SSR disabled
const GoogleMapView = dynamic(
  () => import("../../components/maps/GoogleMapView"),
  { ssr: false }
);

const TrackingPage: NextPage = () => {
  return (
    <div style={{ width: "100%", height: "100vh" }}>
      <h2 style={{ padding: "10px" }}>Live Bus Tracking</h2>
      <GoogleMapView />
    </div>
  );
};

export default TrackingPage;
