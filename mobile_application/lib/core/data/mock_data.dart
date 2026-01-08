// core/data/mock_data.dart
class MockData {
  static final driverSchedule = [
    {
      'date': '2024-01-15',
      'route': 'Route 101',
      'startTime': '08:00 AM',
      'endTime': '04:00 PM',
      'busNumber': 'BUS-101',
      'status': 'Upcoming',
    },
    {
      'date': '2024-01-14',
      'route': 'Route 102',
      'startTime': '07:30 AM',
      'endTime': '03:30 PM',
      'busNumber': 'BUS-102',
      'status': 'Completed',
    },
    {
      'date': '2024-01-13',
      'route': 'Route 103',
      'startTime': '09:00 AM',
      'endTime': '05:00 PM',
      'busNumber': 'BUS-103',
      'status': 'Completed',
    },
  ];

  static final activeRoutes = [
    {
      'id': '1',
      'name': 'Downtown Express',
      'busNumber': 'BUS-101',
      'nextStop': 'Main Street Station',
      'eta': '15 min',
      'status': 'On Time',
    },
    {
      'id': '2',
      'name': 'Northside Loop',
      'busNumber': 'BUS-102',
      'nextStop': 'University Campus',
      'eta': '25 min',
      'status': 'Delayed',
    },
    {
      'id': '3',
      'name': 'Airport Shuttle',
      'busNumber': 'BUS-103',
      'nextStop': 'Terminal B',
      'eta': '8 min',
      'status': 'On Time',
    },
  ];
}