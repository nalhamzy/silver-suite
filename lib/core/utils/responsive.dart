import 'package:flutter/material.dart';

extension ResponsiveContext on BuildContext {
  bool get isTablet => MediaQuery.sizeOf(this).shortestSide >= 600;

  /// On tablets everything goes a bit bigger. Tuned for comfort-first UX.
  double s(double v) => isTablet ? v * 1.35 : v;

  double get maxContentWidth => isTablet ? 720 : double.infinity;
}

class ResponsiveContentBox extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  const ResponsiveContentBox({super.key, required this.child, this.maxWidth});

  @override
  Widget build(BuildContext context) {
    if (!context.isTablet) return child;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? 720),
        child: child,
      ),
    );
  }
}
