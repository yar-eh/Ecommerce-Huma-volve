import 'package:ecommerce_app_huma_volve/core/theme.dart';
import 'package:flutter/material.dart';

class AuthLogo extends StatelessWidget {
  final IconData icon;

  const AuthLogo({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(icon, size: 56, color: AppTheme.background),
      ),
    );
  }
}
