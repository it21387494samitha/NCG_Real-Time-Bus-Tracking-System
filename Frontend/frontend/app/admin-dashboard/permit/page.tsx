'use client';
import React, { useEffect, useState } from 'react';
import Input from '@/components/ui/Input'; // Adjust the path if needed
// import { getRoutes } from '@/lib/api/routes'; // You should have an API util for fetching routes




interface Route {
    id: string;
    name: string;
}

const PermitPage: React.FC = () => {
    const [permitId, setPermitId] = useState('');
    const [routes, setRoutes] = useState<Route[]>([]);
    const [selectedRoute, setSelectedRoute] = useState('');

    const getRoutes = async (): Promise<Route[]> => {
        // Mock API call - replace with actual API call
        return Promise.resolve([
            { id: '1', name: 'Route 1' },
            { id: '2', name: 'Route 2' },
        ]);
    }
    useEffect(() => {
        async function fetchRoutes() {
            try {
                const data = await getRoutes();
                setRoutes(data);
            } catch (error) {
                // Handle error as needed
            }
        }
        fetchRoutes();
    }, []);

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        // Handle form submission logic here
    };

    return (
        <div className="max-w-xl mx-auto mt-12 p-8 bg-white rounded-3xl shadow-lg">
            <h1 className="text-3xl font-bold mb-2">Add Permit</h1>
            <p className="text-gray-500 mb-8">Fill in the permit details and assign a route.</p>
            <form onSubmit={handleSubmit} className="space-y-8">
                {/* Permit Information Section */}
                <div>
                    <div className="flex items-center mb-2">
                        <span className="text-lg mr-2">📄</span>
                        <span className="font-semibold text-blue-700">Permit Information</span>
                    </div>
                    <Input
                        placeholder="Permit ID (e.g. P-1234)"
                        value={permitId}
                        onChange={e => setPermitId(e.target.value)}
                        name="permitId"
                        required
                        className="w-full rounded-xl border border-gray-300 px-4 py-3 text-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
                    />
                </div>

                {/* Route Selection Section */}
                <div>
                    <div className="flex items-center mb-2">
                        <span className="text-lg mr-2">🛣️</span>
                        <span className="font-semibold text-purple-700">Select Route</span>
                    </div>
                    <select
                        className="w-full rounded-xl border border-gray-300 px-4 py-3 text-lg focus:border-purple-500 focus:ring-2 focus:ring-purple-100 bg-white"
                        value={selectedRoute}
                        onChange={e => setSelectedRoute(e.target.value)}
                        required
                    >
                        <option value="" disabled>
                            Select a route
                        </option>
                        {routes.map(route => (
                            <option key={route.id} value={route.id}>
                                {route.name}
                            </option>
                        ))}
                    </select>
                </div>

                {/* Submit Button */}
                <button
                    type="submit"
                    className="w-full bg-gradient-to-r from-blue-600 to-blue-500 text-white py-3 rounded-xl text-lg font-semibold shadow-md hover:from-blue-700 hover:to-blue-600 transition"
                >
                    Register Permit
                </button>
            </form>
        </div>
    );
};

export default PermitPage;