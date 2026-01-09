'use client';
import React, { useEffect, useState } from 'react';
import Input from '../../../components/ui/Input'; 

const BusRegister: React.FC = () => {
    const [busModel, setBusModel] = useState('');
    const [busName, setBusName] = useState('');
    const [registerNumber, setRegisterNumber] = useState('');
    const [seatCount, setSeatCount] = useState('');
    const [permits, setPermits] = useState<any[]>([]);
    const [selectedPermit, setSelectedPermit] = useState<any | null>(null);
    const [route, setRoute] = useState('');

    useEffect(() => {
        // Fetch permits from the database
        const fetchPermits = async () => {
            const response = await fetch('/api/permits'); // Adjust the API endpoint as needed
            const data = await response.json();
            setPermits(data);
        };
        fetchPermits();
    }, []);

    const handlePermitChange = (event: React.ChangeEvent<HTMLSelectElement>) => {
        const permitId = event.target.value;
        const permit = permits.find(p => p.id === permitId);
        setSelectedPermit(permit);
        setRoute(permit ? permit.route : '');
    };

    const handleSubmit = (event: React.FormEvent) => {
        event.preventDefault();
        // Handle form submission logic here
    };

    return (
        <div className='bg-gray-900'>
             <div className="max-w-xl mx-auto mt-12 p-8 bg-white rounded-3xl shadow-lg">
            <h1 className="text-3xl font-bold mb-2 text-blue-950">Register New Bus</h1>
            <p className="text-gray-500 mb-8">Enter bus details and assign a permit.</p>
            <form onSubmit={handleSubmit} className="space-y-8">
                {/* Bus Information Section */}
                <div>
                    <div className="flex items-center mb-2">
                        <span className="text-lg mr-2">🚌</span>
                        <span className="font-semibold text-blue-700">Bus Information</span>
                    </div>
                    <Input
                        placeholder="Bus Model (e.g. Volvo 9700)"
                        value={busModel}
                        onChange={e => setBusModel(e.target.value)}
                        name="busModel"
                        required
                        className="w-full rounded-xl border border-gray-300 px-4 py-3 text-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-100 mb-3"
                    />
                    <Input
                        placeholder="Bus Name (e.g. City Express)"
                        value={busName}
                        onChange={e => setBusName(e.target.value)}
                        name="busName"
                        required
                        className="w-full rounded-xl border border-gray-300 px-4 py-3 text-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-100 mb-3"
                    />
                    <Input
                        placeholder="Register Number (e.g. ABC-1234)"
                        value={registerNumber}
                        onChange={e => setRegisterNumber(e.target.value)}
                        name="registerNumber"
                        required
                        className="w-full rounded-xl border border-gray-300 px-4 py-3 text-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-100 mb-3"
                    />
                    <Input
                        placeholder="Seat Count"
                        value={seatCount}
                        onChange={e => setSeatCount(e.target.value)}
                        name="seatCount"
                        type="number"
                        min="1"
                        required
                        className="w-full rounded-xl border border-gray-300 px-4 py-3 text-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
                    />
                </div>

                {/* Permit Selection Section */}
                <div>
                    <div className="flex items-center mb-2">
                        <span className="text-lg mr-2">📝</span>
                        <span className="font-semibold text-purple-700">Assign Permit</span>
                    </div>
                    <select
                        id="permit"
                        onChange={handlePermitChange}
                        className="w-full rounded-xl border border-gray-300 px-4 py-3 text-lg focus:border-purple-500 focus:ring-2 focus:ring-purple-100 bg-white"
                        required
                        value={selectedPermit ? selectedPermit.id : ''}
                    >
                        <option value="">Select a permit</option>
                        {permits.map(permit => (
                            <option key={permit.id} value={permit.id}>{permit.name}</option>
                        ))}
                    </select>
                    {selectedPermit && (
                        <div className="mt-2 text-gray-600 text-sm">Route: <span className="font-semibold text-blue-600">{route}</span></div>
                    )}
                </div>

                {/* Submit Button */}
                <button
                    type="submit"
                    className="w-full bg-gradient-to-r from-blue-600 to-blue-500 text-white py-3 rounded-xl text-lg font-semibold shadow-md hover:from-blue-700 hover:to-blue-600 transition"
                >
                    Register Bus
                </button>
            </form>
        </div>
        </div>
       
    );
};

export default BusRegister;