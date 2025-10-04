import 'dart:ui'; // ✅ Needed for PlatformDispatcher
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart'; // Make sure you have this file from FlutterFire CLI
import 'pages/home.dart';
import 'pages/schedule.dart';
import 'pages/dbt_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Catch all uncaught Flutter errors
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Catch errors from outside Flutter (native errors)
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true; // Prevent app from crashing immediately
  };

  runApp(const TierApp());
}

class TierApp extends StatefulWidget {
  const TierApp({super.key});

  @override
  State<TierApp> createState() => _TierAppState();
}

class _TierAppState extends State<TierApp> {
  int _selectedIndex = 0;
  int _mood = 5;

  void _onMoodChanged(int m) => setState(() => _mood = m);

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(onMoodChanged: _onMoodChanged),
      SchedulePage(),
      DbtPage(),
    ];
  }

  void _onTap(int idx) {
    setState(() => _selectedIndex = idx);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TIER',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TIER'),
          centerTitle: true,
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTap,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
            BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'DBT'),
          ],
        ),
      ),
    );
  }
}
