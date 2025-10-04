import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/schedule.dart';
import 'pages/dbt_page.dart';
// Import your crash reporting package, e.g. Firebase Crashlytics
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize crash reporting (example for Firebase Crashlytics)
  // await Firebase.initializeApp();
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(TierApp());
}

class TierApp extends StatefulWidget {
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
