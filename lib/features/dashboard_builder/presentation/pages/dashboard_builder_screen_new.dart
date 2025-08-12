import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/dashboard_service.dart';
import '../../../../core/models/dashboard_widget_model.dart';
import 'package:uuid/uuid.dart';

class DashboardBuilderScreenNew extends StatefulWidget {
  const DashboardBuilderScreenNew({super.key});

  @override
  State<DashboardBuilderScreenNew> createState() =>
      _DashboardBuilderScreenNewState();
}

class _DashboardBuilderScreenNewState extends State<DashboardBuilderScreenNew> {
  final Uuid _uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.dashboardBuilder),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _showResetDialog(context);
            },
            tooltip: 'Reset Dashboard',
          ),
        ],
      ),
      body: Consumer<DashboardService>(
        builder: (context, dashboardService, child) {
          return Column(
            children: [
              // Widget Templates Section
              Container(
                height:
                    280, // Fixed height instead of flex to ensure visibility
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Compact header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingMedium,
                        vertical: AppDimensions.paddingSmall,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.widgets,
                            color: AppColors.primary,
                            size: 20, // Smaller icon
                          ),
                          const SizedBox(width: AppDimensions.paddingSmall),
                          Text(
                            'Widget Templates',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  // Smaller title
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${dashboardService.widgetTemplates.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingSmall),
                    // Grid View
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              4, // More columns for smaller templates
                          childAspectRatio: 0.8,
                          crossAxisSpacing: AppDimensions.paddingSmall,
                          mainAxisSpacing: AppDimensions.paddingSmall,
                        ),
                        itemCount: dashboardService.widgetTemplates.length,
                        itemBuilder: (context, index) {
                          final template =
                              dashboardService.widgetTemplates[index];
                          return _buildTemplateCard(
                              context, template, dashboardService);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              Container(
                height: 1,
                color: AppColors.divider,
                margin: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMedium),
              ),

              // Current Widgets Section
              Expanded(
                // This will take the remaining space
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dashboard Widgets (${dashboardService.widgets.length})',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (dashboardService.widgets.isNotEmpty)
                            TextButton.icon(
                              onPressed: () {
                                dashboardService.clearAllWidgets();
                              },
                              icon: const Icon(Icons.clear_all),
                              label: const Text('Clear All'),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      Expanded(
                        child: dashboardService.widgets.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.widgets_outlined,
                                      size: 64,
                                      color: AppColors.textSecondary
                                          .withOpacity(0.5),
                                    ),
                                    const SizedBox(
                                        height: AppDimensions.paddingMedium),
                                    Text(
                                      'No widgets added',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                    ),
                                    const SizedBox(
                                        height: AppDimensions.paddingSmall),
                                    Text(
                                      'Tap on templates above to add widgets',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: dashboardService.widgets.length,
                                itemBuilder: (context, index) {
                                  final widget =
                                      dashboardService.widgets[index];
                                  return _buildWidgetListItem(
                                      context, widget, dashboardService);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTemplateCard(BuildContext context, Map<String, dynamic> template,
      DashboardService dashboardService) {
    final widgetType = template['type'] as WidgetType;
    final title = template['title'] as String;
    final icon = template['icon'] as IconData;
    final defaultSize = template['defaultSize'] as WidgetSize;
    final description = template['description'] as String;

    return GestureDetector(
      onTap: () {
        _addWidgetFromTemplate(
            widgetType, title, defaultSize, dashboardService);

        // Show feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title added to dashboard'),
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.success,
          ),
        );
      },
      child: Card(
        elevation: 4,
        shadowColor: AppColors.primary.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          side: BorderSide(
            color: AppColors.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingSmall),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                AppColors.primary.withOpacity(0.02),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetListItem(BuildContext context, DashboardWidgetModel widget,
      DashboardService dashboardService) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryLight,
          child: Icon(
            _getWidgetIcon(widget.type),
            color: AppColors.primary,
            size: 20,
          ),
        ),
        title: Text(widget.title),
        subtitle: Text(
            '${widget.type.toString().split('.').last} • ${widget.size.toString().split('.').last}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: AppColors.error),
          onPressed: () {
            dashboardService.removeWidget(widget.id);
          },
        ),
      ),
    );
  }

  IconData _getWidgetIcon(WidgetType type) {
    switch (type) {
      case WidgetType.switchWidget:
        return Icons.toggle_on;
      case WidgetType.buttonWidget:
        return Icons.smart_button;
      case WidgetType.gaugeWidget:
        return Icons.speed;
      case WidgetType.chartWidget:
        return Icons.show_chart;
      case WidgetType.indicatorWidget:
        return Icons.circle;
      case WidgetType.textWidget:
        return Icons.text_fields;
    }
  }

  void _addWidgetFromTemplate(WidgetType type, String baseTitle,
      WidgetSize size, DashboardService dashboardService) {
    final widget = DashboardWidgetModel(
      id: _uuid.v4(),
      title: baseTitle,
      type: type,
      size: size,
      x: 0,
      y: dashboardService.widgets.length ~/ 2,
      data: _getDefaultData(type),
      settings: _getDefaultSettings(type),
    );

    dashboardService.addWidget(widget);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${baseTitle} added to dashboard'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            dashboardService.removeWidget(widget.id);
          },
        ),
      ),
    );
  }

  Map<String, dynamic> _getDefaultData(WidgetType type) {
    switch (type) {
      case WidgetType.switchWidget:
        return {'value': false};
      case WidgetType.buttonWidget:
        return {'value': 'PRESS'};
      case WidgetType.gaugeWidget:
        return {'value': 50.0, 'unit': '%'};
      case WidgetType.chartWidget:
        return {
          'values': [10, 20, 15, 25, 30],
          'labels': ['1h', '2h', '3h', '4h', '5h']
        };
      case WidgetType.indicatorWidget:
        return {'active': true, 'label': 'Online'};
      case WidgetType.textWidget:
        return {'text': 'Sample Text'};
    }
  }

  Map<String, dynamic> _getDefaultSettings(WidgetType type) {
    return {
      'deviceId': 'device_${_uuid.v4().substring(0, 8)}',
      'updateInterval': 1000,
    };
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Dashboard'),
          content: const Text(
              'This will remove all widgets and load the default ones. Continue?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<DashboardService>().loadDefaultWidgets();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Dashboard reset to default widgets'),
                  ),
                );
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}
