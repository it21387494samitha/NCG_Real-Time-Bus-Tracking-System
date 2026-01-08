"use client";

import React, { useState, useRef, useEffect } from "react";
import {
  LoadScript,
  Autocomplete,
  GoogleMap,
  DirectionsRenderer,
} from "@react-google-maps/api";
import Input from "@/components/ui/Input";

const libraries: ("places")[] = ["places"];

const defaultCenter = { lat: 7.8731, lng: 80.7718 }; // Sri Lanka center

export default function CreateRoutePage() {
  const [routeData, setRouteData] = useState({
    routeNumber: "",
    startLocation: "",
    endLocation: "",
  });

  const [stops, setStops] = useState<string[]>([]);
  const [stopInput, setStopInput] = useState("");
  const [directions, setDirections] =
    useState<google.maps.DirectionsResult | null>(null);

  const startRef = useRef<google.maps.places.Autocomplete | null>(null);
  const endRef = useRef<google.maps.places.Autocomplete | null>(null);
  const stopRef = useRef<google.maps.places.Autocomplete | null>(null);

  // Handle start/end place selection
  const handlePlaceSelect = (
    ref: React.MutableRefObject<google.maps.places.Autocomplete | null>,
    field: "startLocation" | "endLocation"
  ) => {
    const place = ref.current?.getPlace();
    if (place?.formatted_address) {
      setRouteData((prev) => ({ ...prev, [field]: place.formatted_address }));
    }
  };

  // Add stop
  const handleAddStop = () => {
    if (stopInput.trim()) {
      setStops((prev) => [...prev, stopInput]);
      setStopInput("");
    }
  };

  // Remove stop
  const handleRemoveStop = (index: number) => {
    setStops((prev) => prev.filter((_, i) => i !== index));
  };

  // Fetch directions
  useEffect(() => {
    if (!routeData.startLocation || !routeData.endLocation) return;

    const waypoints = stops
      .filter((s) => s.trim() !== "")
      .map((stop) => ({ location: stop, stopover: true }));

    const service = new google.maps.DirectionsService();

    service.route(
      {
        origin: routeData.startLocation,
        destination: routeData.endLocation,
        waypoints,
        travelMode: google.maps.TravelMode.DRIVING,
      },
      (result, status) => {
        if (status === "OK" && result) {
          setDirections(result);
        } else {
          setDirections(null);
          console.warn("Directions request failed:", status);
        }
      }
    );
  }, [routeData.startLocation, routeData.endLocation, stops]);

  // Submit
  const handleSubmitRoute = (e: React.FormEvent) => {
    e.preventDefault();
    const payload = { ...routeData, stops };
    console.log("ROUTE DATA 👉", payload);
    alert("Route registered successfully!");
    setRouteData({ routeNumber: "", startLocation: "", endLocation: "" });
    setStops([]);
    setDirections(null);
  };

  return (
    <LoadScript
      googleMapsApiKey={process.env.NEXT_PUBLIC_GOOGLE_MAPS_API_KEY!}
      libraries={libraries}
    >
      <div className="min-h-screen bg-gradient-to-br from-indigo-50 via-white to-cyan-50 p-8">
        <div className="max-w-7xl mx-auto grid grid-cols-1 lg:grid-cols-2 gap-10">

          {/* FORM */}
          <div className="bg-white/80 backdrop-blur-xl rounded-3xl shadow-2xl p-10 space-y-10 border border-white">
            <div>
              <h1 className="text-3xl font-bold text-gray-800">
                Create New Route
              </h1>
              <p className="text-sm text-gray-500 mt-1">
                Define locations and preview the journey instantly
              </p>
            </div>

            <form onSubmit={handleSubmitRoute} className="space-y-10">

              {/* ROUTE NUMBER */}
              <section className="space-y-4">
                <h2 className="text-sm font-semibold text-indigo-600">
                  📌 Route Information
                </h2>

                <Input
                  placeholder="Route Number (e.g. RT-01)"
                  value={routeData.routeNumber}
                  onChange={(e) =>
                    setRouteData({
                      ...routeData,
                      routeNumber: e.target.value,
                    })
                  }
                  required
                />
              </section>

              {/* LOCATIONS */}
              <section className="space-y-4">
                <h2 className="text-sm font-semibold text-indigo-600">
                  📍 Locations
                </h2>

                <Autocomplete
                  onLoad={(ref) => (startRef.current = ref)}
                  onPlaceChanged={() =>
                    handlePlaceSelect(startRef, "startLocation")
                  }
                >
                  <Input
                    placeholder="Start Location"
                    value={routeData.startLocation}
                    onChange={(e) =>
                      setRouteData({
                        ...routeData,
                        startLocation: e.target.value,
                      })
                    }
                    required
                  />
                </Autocomplete>

                <Autocomplete
                  onLoad={(ref) => (endRef.current = ref)}
                  onPlaceChanged={() =>
                    handlePlaceSelect(endRef, "endLocation")
                  }
                >
                  <Input
                    placeholder="End Location"
                    value={routeData.endLocation}
                    onChange={(e) =>
                      setRouteData({
                        ...routeData,
                        endLocation: e.target.value,
                      })
                    }
                    required
                  />
                </Autocomplete>
              </section>

              {/* STOPS */}
              <section className="space-y-4">
                <h2 className="text-sm font-semibold text-indigo-600">
                  🛑 Route Stops
                </h2>

                <div className="flex gap-3">
                  <Autocomplete
                    onLoad={(ref) => (stopRef.current = ref)}
                    onPlaceChanged={() => {
                      const place = stopRef.current?.getPlace();
                      if (place?.formatted_address) {
                        setStopInput(place.formatted_address);
                      }
                    }}
                  >
                    <Input
                      className="flex-1"
                      placeholder="Add Stop"
                      value={stopInput}
                      onChange={(e) => setStopInput(e.target.value)}
                    />
                  </Autocomplete>

                  <button
                    type="button"
                    onClick={handleAddStop}
                    className="px-6 py-3 rounded-2xl bg-gradient-to-r from-green-500 to-emerald-600 text-white font-medium hover:shadow-lg transition"
                  >
                    Add
                  </button>
                </div>

                {stops.length > 0 && (
                  <ul className="max-h-44 overflow-y-auto space-y-2">
                    {stops.map((stop, i) => (
                      <li
                        key={i}
                        className="flex justify-between items-center px-4 py-2 bg-white rounded-xl shadow-sm border"
                      >
                        <span className="text-sm truncate">{stop}</span>
                        <button
                          type="button"
                          className="text-red-500 hover:text-red-700"
                          onClick={() => handleRemoveStop(i)}
                        >
                          ✕
                        </button>
                      </li>
                    ))}
                  </ul>
                )}
              </section>

              <button
                type="submit"
                className="w-full py-4 rounded-2xl bg-gradient-to-r from-indigo-600 to-blue-600 text-white text-lg font-semibold hover:shadow-xl transition"
              >
                Register Route
              </button>
            </form>
          </div>

          {/* MAP */}
          <div className="bg-white rounded-3xl shadow-2xl p-5 sticky top-8 border">
            <div className="mb-3 text-center text-sm font-medium text-indigo-600">
              Live Route Preview
            </div>

            <GoogleMap
              mapContainerStyle={{ height: "520px", width: "100%" }}
              center={defaultCenter}
              zoom={8}
            >
              {directions && (
                <DirectionsRenderer directions={directions} />
              )}
            </GoogleMap>
          </div>

        </div>
      </div>
    </LoadScript>
  );
}
