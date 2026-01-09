// features/tracking/presentation/widgets/dynamic_island.dart
import 'package:flutter/material.dart';

class DynamicIsland extends StatefulWidget {
  final bool isExpanded;
  final VoidCallback onTap;
  final double distance;
  final String? customerName;
  final String? phoneNumber;
  final String? seatNumber;
  final String? eta;

  const DynamicIsland({
    super.key,
    this.isExpanded = false,
    required this.onTap,
    this.distance = 0.0,
    this.customerName,
    this.phoneNumber,
    this.seatNumber,
    this.eta,
  });

  @override
  State<DynamicIsland> createState() => _DynamicIslandState();
}

class _DynamicIslandState extends State<DynamicIsland> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  late Animation<double> _widthAnimation;
  late Animation<double> _borderRadiusAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _heightAnimation = Tween<double>(
      begin: 83,
      end: 339,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _widthAnimation = Tween<double>(
      begin: 150,
      end: 260,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _borderRadiusAnimation = Tween<double>(
      begin: 35,
      end: 20,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    if (widget.isExpanded) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant DynamicIsland oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded && !oldWidget.isExpanded) {
      _controller.forward();
    } else if (!widget.isExpanded && oldWidget.isExpanded) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final colorScheme = Theme.of(context).colorScheme;
        final topColor = Color.lerp(colorScheme.primary, colorScheme.surface, _controller.value)!;
        final bottomColor = colorScheme.surface;
        final splitHeight = _heightAnimation.value * 0.5;
        final splitRatio = splitHeight / _heightAnimation.value;

        return TapRegion(
          onTapOutside: (event) {
            if (widget.isExpanded) {
              widget.onTap();
            }
          },
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              width: _widthAnimation.value,
              height: _heightAnimation.value,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    topColor,
                    topColor,
                    bottomColor,
                    bottomColor,
                  ],
                  stops: [0, splitRatio, splitRatio, 1],
                ),
                borderRadius: BorderRadius.circular(_borderRadiusAnimation.value),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(_controller.value > 0.5 ? 20 : 12),
                child: _buildContent(context),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_controller.value < 0.5) {
      // Collapsed state - Show only distance
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'NEXT PICKUP',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: Color.lerp(
                Theme.of(context).colorScheme.onPrimary,
                Theme.of(context).colorScheme.outline,
                _controller.value,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${widget.distance.toStringAsFixed(1)} km',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      );
    } else {
      // Expanded state - Show all details
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person_pin_circle,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Next Pickup',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: widget.onTap,
                icon: Icon(
                  Icons.expand_less,
                  size: 20,
                  color: Theme.of(context).colorScheme.outline,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Distance & ETA
          Row(
            children: [
              _InfoChip(
                icon: Icons.directions_walk,
                value: '${widget.distance.toStringAsFixed(1)} km',
                label: 'Distance',
                context: context,
              ),
              const SizedBox(width: 12),
              _InfoChip(
                icon: Icons.access_time,
                value: widget.eta ?? '15 min',
                label: 'ETA',
                context: context,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Customer Details
          _DetailRow(
            icon: Icons.person,
            title: 'Customer',
            value: widget.customerName ?? 'John Smith',
            context: context,
          ),
          _DetailRow(
            icon: Icons.phone,
            title: 'Phone',
            value: widget.phoneNumber ?? '+94 77 123 4567',
            context: context,
          ),
          _DetailRow(
            icon: Icons.chair,
            title: 'Seat',
            value: widget.seatNumber ?? 'A12',
            context: context,
          ),
        ],
      );
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final BuildContext context;

  const _InfoChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final BuildContext context;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}