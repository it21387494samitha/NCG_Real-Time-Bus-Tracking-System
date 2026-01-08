// features/tracking/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/map_provider.dart';
import 'full_map_screen.dart';
import '../widgets/map_preview.dart';
import '../widgets/todays_schedule.dart';
import '../widgets/online_toggle_bar.dart';
import '../widgets/floating_go_button.dart';
import 'calendar.dart';
import '../../../profile/presentation/screens/settings.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isOnline = false;
  int _selectedIndex = 0;
  
  @override
  void initState() {
    super.initState();
    // Initialize location
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapProvider.notifier).getCurrentLocation();
    });
  }
  
  void _openFullMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FullMapScreen(),
      ),
    );
  }
  
  void _goOnline() {
    setState(() => _isOnline = true);
    // TODO: Start sending location to backend
  }
  
  void _goOffline() {
    setState(() => _isOnline = false);
    // TODO: Stop sending location to backend
  }
  
  void _onNavItemTapped(int index) {
    setState(() => _selectedIndex = index);
    
    switch (index) {
      case 0:
        // Home - already here
        break;
      case 1:
        // Navigate to Calendar
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CalendarScreen(),
          ),
        );
        break;
      case 2:
        // Navigate to Settings
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingsScreen(),
          ),
        );
        break;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    ref.watch(mapProvider);
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isOnline ? 'You\'re Online' : 'You\'re Offline',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isOnline 
                        ? 'Your location is being tracked live'
                        : 'Go online to start your shift',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            
            // Map Preview (30% of screen)
            const SizedBox(height: 20),
            Expanded(
              flex: 3, // Takes 30% of space
              child: MapPreview(
                onTap: _openFullMap,
                height: double.infinity,
              ),
            ),
            
            // Today's Schedule (Rest of the space)
            const SizedBox(height: 20),
            Expanded(
              flex: 7, // Takes remaining 70% of space
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TodaysSchedule(),
                  const Spacer(),
                  
                  // Spacing for floating button and toggle bar
                  SizedBox(
                    height: 160, // Space for toggle bar + floating button
                    child: Stack(
                      children: [
                        // Online/Offline Toggle Bar (positioned at bottom)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: OnlineToggleBar(
                            isOnline: _isOnline,
                            onGoOnline: _goOnline,
                            onGoOffline: _goOffline,
                          ),
                        ),
                        
                        // Floating GO Button (positioned above toggle bar)
                        Positioned(
                          bottom: 80, // Just above the toggle bar
                          left: 0,
                          right: 0,
                          child: FloatingGoButton(
                            isOnline: _isOnline,
                            onPressed: _goOnline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}