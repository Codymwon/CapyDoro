import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isPrimary;

  const ActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.isPrimary = true,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails _) {
    _scaleController.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: widget.isPrimary
            ? ElevatedButton(
                onPressed: null, // Handled by gesture detector
                style: widget.backgroundColor != null
                    ? ElevatedButton.styleFrom(
                        backgroundColor: widget.backgroundColor,
                        foregroundColor: widget.foregroundColor,
                        disabledBackgroundColor: widget.backgroundColor,
                        disabledForegroundColor:
                            widget.foregroundColor ?? Colors.white,
                      )
                    : ElevatedButton.styleFrom(
                        disabledBackgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary,
                        disabledForegroundColor: Colors.white,
                      ),
                child: Text(widget.label),
              )
            : TextButton(
                onPressed: null,
                style: widget.foregroundColor != null
                    ? TextButton.styleFrom(
                        disabledForegroundColor: widget.foregroundColor,
                      )
                    : null,
                child: Text(widget.label),
              ),
      ),
    );
  }
}

class ActionIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String tooltip;

  const ActionIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip = '',
  });

  @override
  State<ActionIconButton> createState() => _ActionIconButtonState();
}

class _ActionIconButtonState extends State<ActionIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.90).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _scaleController.forward();
  void _onTapUp(TapUpDetails _) {
    _scaleController.reverse();
    widget.onPressed();
  }

  void _onTapCancel() => _scaleController.reverse();

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? Colors.transparent;
    final fgColor =
        widget.foregroundColor ?? Theme.of(context).colorScheme.primary;

    Widget button = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Icon(widget.icon, color: fgColor, size: 28),
    );

    if (widget.tooltip.isNotEmpty) {
      button = Tooltip(message: widget.tooltip, child: button);
    }

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: button,
      ),
    );
  }
}
