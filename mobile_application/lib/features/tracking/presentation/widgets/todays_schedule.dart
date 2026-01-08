// features/tracking/presentation/widgets/todays_schedule.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodaysSchedule extends StatelessWidget {
  const TodaysSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayFormatted = DateFormat('EEEE, MMMM d').format(today);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Schedule',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  todayFormatted,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180, // Fixed height for schedule cards
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _ScheduleCard(
                time: '08:00 AM',
                title: 'Start Shift',
                location: 'Depot A',
                isCompleted: true,
              ),
              const SizedBox(width: 12),
              _ScheduleCard(
                time: '08:30 AM',
                title: 'Route 101',
                location: 'Downtown Express',
                isActive: true,
              ),
              const SizedBox(width: 12),
              _ScheduleCard(
                time: '12:00 PM',
                title: 'Lunch Break',
                location: 'Main Station',
              ),
              const SizedBox(width: 12),
              _ScheduleCard(
                time: '01:00 PM',
                title: 'Route 102',
                location: 'Northside Loop',
              ),
              const SizedBox(width: 12),
              _ScheduleCard(
                time: '04:00 PM',
                title: 'End Shift',
                location: 'Depot A',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final String time;
  final String title;
  final String location;
  final bool isCompleted;
  final bool isActive;

  const _ScheduleCard({
    required this.time,
    required this.title,
    required this.location,
    this.isCompleted = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive 
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive 
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: isActive ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted 
                      ? Colors.green
                      : isActive
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  time,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              if (isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'NOW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            location,
            style: TextStyle(
              color: Theme.of(context).colorScheme.outline,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}