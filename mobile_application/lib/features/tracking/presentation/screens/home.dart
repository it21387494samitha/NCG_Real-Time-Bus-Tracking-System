// UPDATED HOME SCREEN CODE
// features/tracking/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/map_provider.dart';
import 'full_map_screen.dart';
import '../widgets/map_preview.dart';
import '../widgets/todays_schedule.dart';
import '../widgets/bottom_nav_bar.dart';
import '../../../../core/theme/app_theme.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapProvider.notifier).getCurrentLocation();
    });
  }
  
  void _openFullMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullMapScreen(
          isOnline: _isOnline,
          onGoOnline: _goOnline,
          onGoOffline: _goOffline,
        ),
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
  }

  Widget _buildHomeBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        bottom: 110, // Add padding at bottom for nav bar space
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Header with large clear text
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status indicator with large clear text
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isOnline ? AppColors.onlineGreen : AppColors.offlineRed,
                        boxShadow: [
                          BoxShadow(
                            color: (_isOnline ? AppColors.onlineGreen : AppColors.offlineRed).withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _isOnline ? 'LIVE TRACKING ACTIVE' : 'OFFLINE MODE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _isOnline ? AppColors.onlineGreen : AppColors.offlineRed,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  _isOnline ? 'You\'re Online' : 'You\'re Offline',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  _isOnline 
                      ? 'Your location is being tracked live'
                      : 'Tap GO to start tracking your location',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.outline,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          
          // Map Preview (30% of screen)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: MapPreview(
              onTap: _openFullMap,
              height: MediaQuery.of(context).size.height * 0.3,
            ),
          ),
          
          // Today's Schedule Header
          Padding(
            padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Today\'s Schedule',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'BUS #1234',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Today's Schedule Content
          const TodaysSchedule(),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);
    
    return Scaffold(
      extendBody: true, // This allows content to extend behind nav bar
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          SafeArea(
            bottom: false, // Important: don't apply safe area to bottom
            child: _buildHomeBody(),
          ),
          const CalendarScreen(),
          const SettingsScreen(),
        ],
      ),
      
      // Bottom Navigation Bar with glass effect
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}