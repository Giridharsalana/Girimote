import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/dashboard_widget_model.dart';

class DraggableResizableWidget extends StatefulWidget {
  final DashboardWidgetModel widget;
  final Widget child;
  final double cellSize;
  final int gridColumns;
  final int gridRows;
  final Function(int newWidth, int newHeight)? onResize;

  const DraggableResizableWidget({
    super.key,
    required this.widget,
    required this.child,
    required this.cellSize,
    required this.gridColumns,
    required this.gridRows,
    this.onResize,
  });

  @override
  State<DraggableResizableWidget> createState() =>
      _DraggableResizableWidgetState();
}

class _DraggableResizableWidgetState extends State<DraggableResizableWidget> {
  late Size _currentSize;
  bool _isResizing = false;

  @override
  void initState() {
    super.initState();
    _currentSize = widget.widget.size.gridSize;
  }

  @override
  void didUpdateWidget(DraggableResizableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.widget.size != widget.widget.size) {
      setState(() {
        _currentSize = widget.widget.size.gridSize;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = _currentSize.width * widget.cellSize;
    final height = _currentSize.height * widget.cellSize;

    return SizedBox(
      width: width + 20, // Add padding for resize handles
      height: height + 20, // Add padding for resize handles
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main draggable widget
          Positioned(
            top: 0,
            left: 0,
            child: Draggable<DashboardWidgetModel>(
              data: widget.widget,
              feedback: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  border: Border.all(color: AppColors.primary, width: 2),
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: widget.child,
              ),
              childWhenDragging: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  border: Border.all(
                      color: AppColors.primary.withOpacity(0.3), width: 2),
                  color: AppColors.primary.withOpacity(0.1),
                ),
              ),
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: widget.child,
              ),
            ),
          ),

          // Resize handles
          if (widget.onResize != null && !_isResizing) ...[
            // Bottom-right corner resize handle
            Positioned(
              bottom: -10,
              right: -10,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeDownRight,
                child: GestureDetector(
                  onPanStart: (details) {
                    setState(() {
                      _isResizing = true;
                    });
                  },
                  onPanUpdate: (details) {
                    _handleResize(details, ResizeDirection.bottomRight);
                  },
                  onPanEnd: (details) {
                    setState(() {
                      _isResizing = false;
                    });
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.south_east,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              ),
            ),

            // Right edge resize handle
            Positioned(
              top: height / 2 - 10,
              right: -10,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: GestureDetector(
                  onPanStart: (details) {
                    setState(() {
                      _isResizing = true;
                    });
                  },
                  onPanUpdate: (details) {
                    _handleResize(details, ResizeDirection.right);
                  },
                  onPanEnd: (details) {
                    setState(() {
                      _isResizing = false;
                    });
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.east,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              ),
            ),

            // Bottom edge resize handle
            Positioned(
              bottom: -10,
              left: width / 2 - 10,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeUpDown,
                child: GestureDetector(
                  onPanStart: (details) {
                    setState(() {
                      _isResizing = true;
                    });
                  },
                  onPanUpdate: (details) {
                    _handleResize(details, ResizeDirection.bottom);
                  },
                  onPanEnd: (details) {
                    setState(() {
                      _isResizing = false;
                    });
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.south,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _handleResize(DragUpdateDetails details, ResizeDirection direction) {
    final delta = details.delta;
    double newWidth = _currentSize.width;
    double newHeight = _currentSize.height;

    // Calculate new size based on drag direction
    switch (direction) {
      case ResizeDirection.bottomRight:
        newWidth += delta.dx / widget.cellSize;
        newHeight += delta.dy / widget.cellSize;
        break;
      case ResizeDirection.right:
        newWidth += delta.dx / widget.cellSize;
        break;
      case ResizeDirection.bottom:
        newHeight += delta.dy / widget.cellSize;
        break;
    }

    // Clamp to minimum size (1x1) and maximum based on grid bounds
    newWidth = newWidth.clamp(1.0, (widget.gridColumns - widget.widget.x).toDouble());
    newHeight = newHeight.clamp(1.0, (widget.gridRows - widget.widget.y).toDouble());

    // Round to nearest grid cell
    final roundedWidth = newWidth.round();
    final roundedHeight = newHeight.round();

    if (roundedWidth != _currentSize.width.round() ||
        roundedHeight != _currentSize.height.round()) {
      setState(() {
        _currentSize = Size(roundedWidth.toDouble(), roundedHeight.toDouble());
      });

      // Call resize callback
      widget.onResize?.call(roundedWidth, roundedHeight);
    }
  }
}

enum ResizeDirection {
  bottomRight,
  right,
  bottom,
}
