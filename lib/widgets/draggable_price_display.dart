import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../services/pricing_service.dart';

class DraggableFloatingPriceDisplay extends StatefulWidget {
  final double totalPrice;
  final Map<String, double> breakdown;
  final VoidCallback? onTap;

  const DraggableFloatingPriceDisplay({
    super.key,
    required this.totalPrice,
    required this.breakdown,
    this.onTap,
  });

  @override
  State<DraggableFloatingPriceDisplay> createState() =>
      _DraggableFloatingPriceDisplayState();
}

class _DraggableFloatingPriceDisplayState
    extends State<DraggableFloatingPriceDisplay>
    with TickerProviderStateMixin {
  late Offset position;
  late Size screenSize;
  bool isDragging = false;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize position to a safe default - will be updated in didChangeDependencies
    position = const Offset(0, 0);

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start pulse animation
    _pulseController.repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenSize = MediaQuery.of(context).size;
    // Initialize position above navigation bar by default
    if (position == Offset.zero ||
        position.dx > screenSize.width ||
        position.dy > screenSize.height) {
      position = Offset(
        screenSize.width - 200, // Bottom right with padding
        screenSize.height - 350, // Higher up to avoid navigation bar
      );
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _snapToEdge() {
    setState(() {
      // Snap to the nearest edge (left or right)
      final centerX = screenSize.width / 2;
      if (position.dx < centerX) {
        // Snap to left
        position = Offset(20, position.dy);
      } else {
        // Snap to right
        position = Offset(
          screenSize.width - 200,
          position.dy,
        ); // Account for bigger size
      }

      // Keep within screen bounds vertically
      position = Offset(
        position.dx,
        position.dy.clamp(
          MediaQuery.of(context).padding.top + 50,
          screenSize.height -
              300, // Above navigation with more margin (nav + extra space)
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isDragging ? 1.1 : _pulseAnimation.value,
            child: Draggable(
              feedback: Material(
                color: Colors.transparent,
                child: _buildPriceWidget(isDark, feedback: true),
              ),
              childWhenDragging: Container(), // Hide original when dragging
              onDragStarted: () {
                setState(() {
                  isDragging = true;
                });
                _bounceController.forward();
                _pulseController.stop();
              },
              onDragEnd: (details) {
                setState(() {
                  isDragging = false;
                  position = details.offset;
                });
                _bounceController.reverse();
                _snapToEdge();
                _pulseController.repeat(reverse: true);
              },
              child: _buildPriceWidget(isDark),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPriceWidget(bool isDark, {bool feedback = false}) {
    return GestureDetector(
      onTap: feedback ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _bounceAnimation.value,
            child: Container(
              width: 180,
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryRed,
                    AppTheme.primaryRed.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryRed.withValues(alpha: 0.4),
                    blurRadius: feedback ? 20 : 15,
                    spreadRadius: feedback ? 3 : 2,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.3)
                        : Colors.grey.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      PricingService.formatPrice(widget.totalPrice),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
