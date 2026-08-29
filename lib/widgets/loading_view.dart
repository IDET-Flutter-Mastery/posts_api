import 'package:flutter/material.dart';

/// A themed, centered loading spinner — shared by every screen that
/// shows a `FutureBuilder`'s `ConnectionState.waiting` state, so the
/// spinner always matches the app's accent color instead of falling
/// back to whatever the platform default happens to be.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
