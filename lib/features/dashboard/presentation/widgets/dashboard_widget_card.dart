import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/dashboard_widget_model.dart';

class DashboardWidgetCard extends StatelessWidget {
  final DashboardWidgetModel widget;
  final bool isEditMode;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

  const DashboardWidgetCard({
    super.key,
    required this.widget,
    required this.isEditMode,
    this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEditMode ? null : onTap,
      child: Stack(
        children: [
          Card(
            elevation: isEditMode ? 8 : 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              side: isEditMode
                  ? BorderSide(color: AppColors.primary, width: 2)
                  : BorderSide.none,
            ),
            child: Container(
              padding: const EdgeInsets.all(
                  AppDimensions.paddingSmall), // Reduced padding
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Widget Icon
                  _buildWidgetIcon(),
                  const SizedBox(height: 4), // Reduced spacing

                  // Widget Title
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          // Smaller text
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppDimensions.paddingSmall),

                  // Widget Content
                  Expanded(
                    child: _buildWidgetContent(context),
                  ),
                ],
              ),
            ),
          ),

          // Edit mode controls
          if (isEditMode)
            Positioned(
              top: 4,
              right: 4,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Remove button
                  if (onRemove != null)
                    GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWidgetIcon() {
    IconData icon;
    Color color = AppColors.primary;

    switch (widget.type) {
      case WidgetType.switchWidget:
        icon = Icons.toggle_on;
        color = (widget.data['value'] as bool? ?? false)
            ? AppColors.success
            : AppColors.textSecondary;
        break;
      case WidgetType.buttonWidget:
        icon = Icons.smart_button;
        break;
      case WidgetType.gaugeWidget:
        icon = Icons.speed;
        break;
      case WidgetType.chartWidget:
        icon = Icons.show_chart;
        break;
      case WidgetType.indicatorWidget:
        icon = Icons.circle;
        color = (widget.data['active'] as bool? ?? false)
            ? AppColors.success
            : AppColors.error;
        break;
      case WidgetType.textWidget:
        icon = Icons.text_fields;
        break;
    }

    return Icon(
      icon,
      size: 28, // Smaller icon size instead of AppDimensions.iconLarge
      color: color,
    );
  }

  Widget _buildWidgetContent(BuildContext context) {
    switch (widget.type) {
      case WidgetType.switchWidget:
        return _buildSwitchContent(context);
      case WidgetType.buttonWidget:
        return _buildButtonContent(context);
      case WidgetType.gaugeWidget:
        return _buildGaugeContent(context);
      case WidgetType.chartWidget:
        return _buildChartContent(context);
      case WidgetType.indicatorWidget:
        return _buildIndicatorContent(context);
      case WidgetType.textWidget:
        return _buildTextContent(context);
    }
  }

  Widget _buildSwitchContent(BuildContext context) {
    final value = widget.data['value'] as bool? ?? false;
    return Column(
      children: [
        Text(
          value ? 'ON' : 'OFF',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: value ? AppColors.success : AppColors.textSecondary,
              ),
        ),
      ],
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    final label = widget.data['value'] as String? ?? 'PRESS';
    return Text(
      label,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildGaugeContent(BuildContext context) {
    final value = widget.data['value'] as double? ?? 0.0;
    final unit = widget.data['unit'] as String? ?? '';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value.toStringAsFixed(1),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
        ),
        if (unit.isNotEmpty)
          Text(
            unit,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
      ],
    );
  }

  Widget _buildChartContent(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
      child: const Icon(
        Icons.trending_up,
        color: AppColors.primary,
        size: 24,
      ),
    );
  }

  Widget _buildIndicatorContent(BuildContext context) {
    final active = widget.data['active'] as bool? ?? false;
    final label = widget.data['label'] as String? ?? 'Status';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: active ? AppColors.success : AppColors.error,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTextContent(BuildContext context) {
    final text = widget.data['text'] as String? ?? 'N/A';
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
