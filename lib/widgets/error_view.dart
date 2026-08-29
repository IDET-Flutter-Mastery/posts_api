import 'package:flutter/material.dart';

/// A themed error state — shared by every screen that shows a
/// `FutureBuilder`'s error state, so a failed request always looks
/// like a deliberate "something went wrong" screen instead of a raw
/// exception dumped onto the page.
///
/// This is purely presentational: it doesn't know anything about
/// `http`, `dio`, or the specific TODOs in `network/`. [message] is
/// just `'${snapshot.error}'`, passed straight through from whatever
/// exception your fetch function throws — so whatever you write for
/// the CP1 "Quick Challenge" (a friendlier message for a 404) will
/// show up here automatically.
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorView({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 44,
              color: colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.error),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
