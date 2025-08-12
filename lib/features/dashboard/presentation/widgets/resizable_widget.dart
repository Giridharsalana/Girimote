import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/dashboard_widget_model.dart';

class ResizableWidget extends StatefulWidget {
  final DashboardWidgetModel widget;
  final Widget child;
  final double cellSize;
  final int gridColumns;
  final int gridRows;
  final Function(int newWidth, int newHeight)? onResize;

  const ResizableWidget({
    super.key,
    required this.widget,
    required this.child,
    required this.cellSize,
    required this.gridColumns,
    required this.gridRows,
    this.onResize,
  });

  @override
  State<ResizableWidget> createState() => _ResizableWidgetState();
}

class _ResizableWidgetState extends State<ResizableWidget> {
  late Size _currentSize;
  bool _isResizing = false;

  @override
  void initState() {
    super.initState();
    _currentSize = widget.widget.size.gridSize;
  }

  @override
  void didUpdateWidget(ResizableWidget oldWidget) {
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
      width: width,
      height: height,
      child: Stack(
        children: [
          // Main widget content
          widget.child,

          // Resize handles - only show if not null callback
          if (widget.onResize != null) ...[
            _buildResizeHandle(Alignment.bottomRight),
            _buildResizeHandle(Alignment.bottomCenter),
            _buildResizeHandle(Alignment.centerRight),
          ],
        ],
      ),
    );
  }

  Widget _buildResizeHandle(Alignment alignment) {
    final width = _currentSize.width * widget.cellSize;
    final height = _currentSize.height * widget.cellSize;
    
    return Positioned(
      bottom: alignment == Alignment.bottomRight ||
              alignment == Alignment.bottomCenter
          ? -10
          : null,
      right: alignment == Alignment.bottomRight ||
              alignment == Alignment.centerRight
          ? -10
          : null,
      top: alignment == Alignment.centerRight
          ? height / 2 - 10
          : null,
      left: alignment == Alignment.bottomCenter
          ? width / 2 - 10
          : null,
      child: GestureDetector(
        onPanStart: (details) {
          _isResizing = true;
        },
        onPanUpdate: (details) {
          _handleResize(details, alignment);
        },
        onPanEnd: (details) {
          _isResizing = false;
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
          child: Icon(
            _getResizeIcon(alignment),
            color: Colors.white,
            size: 12,
          ),
        ),
      ),
    );
  }

  IconData _getResizeIcon(Alignment alignment) {
    if (alignment == Alignment.bottomRight) {
      return Icons.south_east;
    } else if (alignment == Alignment.bottomCenter) {
      return Icons.south;
    } else if (alignment == Alignment.centerRight) {
      return Icons.east;
    }
    return Icons.drag_handle;
  }

  void _handleResize(DragUpdateDetails details, Alignment alignment) {
    if (!_isResizing) return;

    final delta = details.delta;
    double newWidth = _currentSize.width;
    double newHeight = _currentSize.height;

    // Calculate new size based on drag direction and sensitivity
    final sensitivity = 0.5; // Reduce sensitivity for smoother resizing
    
    if (alignment == Alignment.bottomRight) {
      newWidth += (delta.dx / widget.cellSize) * sensitivity;
      newHeight += (delta.dy / widget.cellSize) * sensitivity;
    } else if (alignment == Alignment.bottomCenter) {
      newHeight += (delta.dy / widget.cellSize) * sensitivity;
    } else if (alignment == Alignment.centerRight) {
      newWidth += (delta.dx / widget.cellSize) * sensitivity;
    }

    // Clamp to minimum size (1x1) and maximum based on grid bounds
    newWidth =
        newWidth.clamp(1.0, (widget.gridColumns - widget.widget.x).toDouble());
    newHeight =
        newHeight.clamp(1.0, (widget.gridRows - widget.widget.y).toDouble());

    // Only update if size changed significantly (threshold to avoid jitter)
    final threshold = 0.3;
    final widthDiff = (newWidth - _currentSize.width).abs();
    final heightDiff = (newHeight - _currentSize.height).abs();
    
    if (widthDiff > threshold || heightDiff > threshold) {
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
}
