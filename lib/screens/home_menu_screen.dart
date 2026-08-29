import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'cp1_get_post_screen.dart';
import 'posts_list_screen.dart';

/// Navigation hub for the lab. Nothing to implement here — this file is
/// done. Use it to jump straight to whichever checkpoint you're working on.
class HomeMenuScreen extends StatelessWidget {
  const HomeMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('REST API Lab')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionLabel('Section 3 — http package'),
          _MenuCard(
            title: 'CP1 + Quick Challenge',
            subtitle: 'Fetch a single post with http, then handle a 404',
            icon: Icons.send_outlined,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const Cp1GetPostScreen()),
            ),
          ),
          const SizedBox(height: 20),
          const _SectionLabel('Section 6 — dio & interceptors'),
          const _MenuCard(
            title: 'CP2 — Interceptors',
            subtitle: 'No screen for this one — see network/dio_client.dart, '
                'then watch the console when you open the Posts Feed below.',
            icon: Icons.repeat,
            enabled: false,
          ),
          const SizedBox(height: 20),
          const _SectionLabel('Section 7 — MockAPI + network layer'),
          _MenuCard(
            title: 'CP3 + CP4 — Posts Feed',
            subtitle: 'Fetch the list with dio, then refactor onto ApiService',
            icon: Icons.list_alt_outlined,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PostsListScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
          color: AppColors.inkMuted,
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;

  const _MenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.6,
      child: Card(
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: AppColors.sage.withValues(alpha: 0.12),
            foregroundColor: AppColors.sageDeep,
            child: Icon(icon),
          ),
          title: Text(title),
          subtitle: Text(subtitle),
          onTap: enabled ? onTap : null,
          trailing: enabled ? const Icon(Icons.chevron_right_rounded) : null,
        ),
      ),
    );
  }
}
