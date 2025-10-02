import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/schedule.dart';
import 'pages/dbt_page.dart';

void main() {
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
          centerTitle: true, // optional: keep title centered
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
