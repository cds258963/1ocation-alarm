import 'package:flutter/material.dart';

class RadiusSelector extends StatelessWidget {
  final double initialRadius;
  final Function(double) onRadiusChanged;

  const RadiusSelector({
    super.key,
    required this.initialRadius,
    required this.onRadiusChanged,
  });

  static const List<double> _options = [250, 500, 1000, 2000, 3000];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _options.map((radius) {
            final isSelected = initialRadius == radius;
            return GestureDetector(
              onTap: () => onRadiusChanged(radius),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    radius >= 1000
                        ? '${(radius / 1000).toStringAsFixed(1)}km'
                        : '${radius.toInt()}m',
                    style: TextStyle(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Text(
          '当前：${initialRadius >= 1000 ? '${(initialRadius / 1000).toStringAsFixed(1)}公里' : '${initialRadius.toInt()}米'}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
