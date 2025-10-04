import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/schedule.dart';
import 'pages/dbt_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
    s
