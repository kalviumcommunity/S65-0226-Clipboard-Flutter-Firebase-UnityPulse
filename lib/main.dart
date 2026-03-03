import 'package:clipboard_app/app.dart';
import 'package:clipboard_app/injectable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (using google-services.json on Android)
  await Firebase.initializeApp();

  // Setup Dependency Injection
  configureDependencies();

  runApp(
    const ProviderScope(
      child: ClipboardApp(),
    ),
  );
}
