import WebSocket, { WebSocketServer } from 'ws';
import Locations from './models/locationsModel.js';

const wss = new WebSocketServer({ port: 8080 });  

// Store connected clients
const clients = new Set();

wss.on('connection', (ws) => {
  console.log('Passenger connected via WebSocket');
  clients.add(ws);

  ws.on('message', (message) => {
    console.log('Received from client:', message);
     
  });

  ws.on('close', () => {
    console.log('Passenger disconnected');
    clients.delete(ws);
  });
});

// Function to broadcast location to all connected passengers
export function broadcastBusLocation(busData) {
  const data = JSON.stringify(busData);
  clients.forEach(client => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(data);
    }
  });
}

console.log('WebSocket server running on ws://localhost:8080');
