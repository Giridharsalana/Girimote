import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/dashboard_widget_model.dart';
import '../../../../core/services/dashboard_service.dart';
import '../widgets/dashboard_widget_card.dart';
import '../widgets/draggable_resizable_widget.dart';

class DashboardScreenNew extends StatefulWidget {
  const DashboardScreenNew({super.key});

  @override
  State<DashboardScreenNew> createState() => _DashboardScreenNewState();
}

class _DashboardScreenNewState extends State<DashboardScreenNew> {
  @override
  void initState() {
    super.initState();
    // Load default widgets on first run
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardService>().loadDefaultWidgets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.dashboard),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          Consumer<DashboardService>(
            builder: (context, dashboardService, child) {
              return IconButton(
                icon: Icon(
                  dashboardService.isEditMode ? Icons.check : Icons.edit,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  dashboardService.toggleEditMode();
                },
                tooltip: dashboardService.isEditMode ? 'Save' : 'Edit',
              );
            },
          ),
        ],
      ),
      body: Consumer<DashboardService>(
        builder: (context, dashboardService, child) {
          final widgets = dashboardService.widgets;

          if (widgets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.dashboard_outlined,
                    size: 80,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  Text(
                    'No widgets added yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  Text(
                    'Go to Builder tab to add widgets',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: SingleChildScrollView(
              child: Center(
                child: _buildDashboardGrid(context, widgets, dashboardService),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDashboardGrid(BuildContext context,
      List<DashboardWidgetModel> widgets, DashboardService dashboardService) {
    // Make grid responsive to screen size
    final screenWidth =
        MediaQuery.of(context).size.width - (AppDimensions.paddingMedium * 2);
    final screenHeight = MediaQuery.of(context).size.height -
        200; // Account for appbar and padding

    // Higher resolution grid
    const double cellSize = 60.0; // Smaller cells for higher resolution
    final int gridColumns = (screenWidth / cellSize)
        .floor()
        .clamp(8, 20); // 8-20 columns based on screen
    final int gridRows = (screenHeight / cellSize)
        .floor()
        .clamp(6, 15); // 6-15 rows based on screen

    final double actualWidth = gridColumns * cellSize;
    final double actualHeight = gridRows * cellSize;

    return DragTarget<DashboardWidgetModel>(
      onWillAccept: (data) => true,
      onAccept: (draggedWidget) {
        // This will be handled by individual drop targets in the grid
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: actualWidth,
          height: actualHeight,
          child: Stack(
            children: [
              // Grid background (only in edit mode)
              if (dashboardService.isEditMode)
                _buildGridBackground(gridColumns, gridRows, cellSize),

              // Drop targets for each grid cell (only in edit mode)
              if (dashboardService.isEditMode)
                ..._buildDropTargets(context, dashboardService, gridColumns,
                    gridRows, cellSize, widgets),

              // Widgets positioned on the grid
              ...widgets
                  .map((widget) => _buildPositionedWidget(context, widget,
                      dashboardService, cellSize, gridColumns, gridRows))
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGridBackground(int columns, int rows, double cellSize) {
    return CustomPaint(
      size: Size(columns * cellSize, rows * cellSize),
      painter: GridPainter(
        columns: columns,
        rows: rows,
        cellSize: cellSize,
      ),
    );
  }

  List<Widget> _buildDropTargets(
    BuildContext context,
    DashboardService dashboardService,
    int columns,
    int rows,
    double cellSize,
    List<DashboardWidgetModel> widgets,
  ) {
    List<Widget> dropTargets = [];

    for (int x = 0; x < columns; x++) {
      for (int y = 0; y < rows; y++) {
        // Check if this position is occupied
        bool isOccupied = widgets.any((widget) {
          final size = widget.size.gridSize;
          return widget.x <= x &&
              x < widget.x + size.width &&
              widget.y <= y &&
              y < widget.y + size.height;
        });

        if (!isOccupied) {
          dropTargets.add(
            Positioned(
              left: x * cellSize,
              top: y * cellSize,
              child: DragTarget<DashboardWidgetModel>(
                onWillAccept: (data) {
                  if (data == null) return false;
                  return dashboardService.canPlaceWidget(
                      data, x, y, columns, rows);
                },
                onAccept: (draggedWidget) {
                  if (dashboardService.canPlaceWidget(
                      draggedWidget, x, y, columns, rows)) {
                    dashboardService.updateWidgetPosition(
                        draggedWidget.id, x, y);
                  }
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: cellSize,
                    height: cellSize,
                    decoration: BoxDecoration(
                      border: candidateData.isNotEmpty
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
                      color: candidateData.isNotEmpty
                          ? AppColors.primary.withOpacity(0.1)
                          : Colors.transparent,
                    ),
                  );
                },
              ),
            ),
          );
        }
      }
    }

    return dropTargets;
  }

  Widget _buildPositionedWidget(
    BuildContext context,
    DashboardWidgetModel widget,
    DashboardService dashboardService,
    double cellSize,
    int gridColumns,
    int gridRows,
  ) {
    final size = widget.size.gridSize;
    final width = cellSize * size.width;
    final height = cellSize * size.height;
    final left = widget.x * cellSize;
    final top = widget.y * cellSize;

    if (dashboardService.isEditMode) {
      return Positioned(
        left: left,
        top: top,
        child: DraggableResizableWidget(
          widget: widget,
          cellSize: cellSize,
          gridColumns: gridColumns,
          gridRows: gridRows,
          onResize: (newWidth, newHeight) {
            dashboardService.resizeWidgetByDimensions(
                widget.id, newWidth, newHeight, gridColumns, gridRows);
          },
          child: SizedBox(
            width: width,
            height: height,
            child: DashboardWidgetCard(
              widget: widget,
              isEditMode: true,
              onRemove: () {
                dashboardService.removeWidget(widget.id);
              },
              onTap: () {
                _handleWidgetTap(context, widget);
              },
            ),
          ),
        ),
      );
    } else {
      return Positioned(
        left: left,
        top: top,
        child: SizedBox(
          width: width,
          height: height,
          child: DashboardWidgetCard(
            widget: widget,
            isEditMode: false,
            onTap: () {
              _handleWidgetTap(context, widget);
            },
          ),
        ),
      );
    }
  }

  void _handleWidgetTap(BuildContext context, widget) {
    // Handle different widget types
    switch (widget.type) {
      case WidgetType.switchWidget:
        _toggleSwitch(context, widget);
        break;
      case WidgetType.buttonWidget:
        _triggerButton(context, widget);
        break;
      default:
        // For display widgets, show details
        _showWidgetDetails(context, widget);
    }
  }

  void _toggleSwitch(BuildContext context, widget) {
    final currentValue = widget.data['value'] as bool? ?? false;
    final newData = <String, dynamic>{...widget.data, 'value': !currentValue};

    context.read<DashboardService>().updateWidgetData(widget.id, newData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.title} ${!currentValue ? 'ON' : 'OFF'}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _triggerButton(BuildContext context, widget) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.title} activated'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showWidgetDetails(BuildContext context, widget) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${widget.type.toString().split('.').last}'),
            const SizedBox(height: 8),
            Text('Data: ${widget.data.toString()}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final int columns;
  final int rows;
  final double cellSize;

  GridPainter({
    required this.columns,
    required this.rows,
    required this.cellSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.1)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw vertical lines
    for (int i = 0; i <= columns; i++) {
      final x = i * cellSize;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, rows * cellSize),
        paint,
      );
    }

    // Draw horizontal lines
    for (int i = 0; i <= rows; i++) {
      final y = i * cellSize;
      canvas.drawLine(
        Offset(0, y),
        Offset(columns * cellSize, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
