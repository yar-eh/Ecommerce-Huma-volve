import 'package:ecommerce_app_huma_volve/core/theme.dart';
import 'package:flutter/material.dart';

class TopGradientBackground extends StatelessWidget {
  final Widget child;

  const TopGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.sizeOf(context).height,
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: AppTheme.topGradient()),
          ),
        ),
        child,
      ],
    );
  }
}
