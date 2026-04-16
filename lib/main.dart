/// DroidWhisper — Application entry point.
///
/// Wraps the widget tree in a [ProviderScope] so every descendant can
/// read / watch Riverpod providers.
library;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/transcription/presentation/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from the bundled .env file.
  await dotenv.load(fileName: '.env');

  runApp(
    const ProviderScope(
      child: DroidWhisperApp(),
    ),
  );
}

/// Root application widget.
class DroidWhisperApp extends StatelessWidget {
  const DroidWhisperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DroidWhisper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6750A4),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6750A4),
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
