// lib/app/widgets/app_error.dart
import 'package:flutter/material.dart';

class AppError extends StatelessWidget {
  const AppError({super.key, required this.description, this.onTap});

  final String description;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(description),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onTap,
            child: const Text('Try again'),
          )
        ],
      ),
    );
  }
}