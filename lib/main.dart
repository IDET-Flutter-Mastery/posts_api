import 'package:flutter/material.dart';

import 'network/dio_client.dart';
import 'screens/home_menu_screen.dart';
import 'theme/app_theme.dart';

void main() {
  // Wires up whatever you build in CP2 — safe to call even before CP2
  // is done, since setupInterceptors() starts out empty.
  setupInterceptors();
  runApp(const RestApiLabApp());
}

class RestApiLabApp extends StatelessWidget {
  const RestApiLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REST API Lab',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeMenuScreen(),
    );
  }
}
