import 'package:clipboard_app/app.dart';
import 'package:clipboard_app/injectable.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup Dependency Injection
  configureDependencies();

  runApp(
    const ProviderScope(
      child: ClipboardApp(),
    ),
  );
}
