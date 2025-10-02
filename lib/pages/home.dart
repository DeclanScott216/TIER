
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/storage_service.dart';
import '../models/mood_entry.dart';

class HomePage extends StatefulWidget {
  final void Function(int) onMoodChanged;
  const HomePage({Key? key, required this.onMoodChanged}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StorageService _storage = StorageService();
  Map<String, MoodEntry> _moods = {};
  int _todayMood = 5;
  final _notesCtrl = TextEditingController();
  DateTime _focusedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final map = await _storage.loadMoodsMap();
    final latest = await _storage.getLatestMood();
    setState(()=> _moods = map);
    if (latest!=null) setState(()=> _todayMood = latest);
  }

  String _keyForDate(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  Color _colorForMood(int mood) {
    final start = Colors.red;
    final end = Colors.green;
    final t = (mood - 1) / 9.0;
    return Color.lerp(start, end, t)!;
  }

  Widget _buildCalendarMonth(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final startWeekday = first.weekday;
    List<Widget> tiles = [];
    int leading = first.weekday % 7;
    for (int i=0;i<leading;i++) tiles.add(Container());
    for (int d=1; d<=daysInMonth; d++) {
      final dt = DateTime(month.year, month.month, d);
      final key = _keyForDate(dt);
      final entry = _moods[key];
      tiles.add(GestureDetector(
        onTap: () => _onDayTap(dt, entry),
        child: Container(
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: entry==null ? Colors.grey.shade200 : _colorForMood(entry.mood),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('$d', style: TextStyle(fontWeight: FontWeight.w600)),
            if (entry!=null) Text('${entry.mood}', style: TextStyle(fontSize:12, fontWeight: FontWeight.w600))
          ]),
        ),
      ));
    }
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        IconButton(icon: Icon(Icons.chevron_left), onPressed: ()=> setState(()=> _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month-1))),
        Text(DateFormat.yMMMM().format(month), style: Theme.of(context).textTheme.headlineSmall),
        IconButton(icon: Icon(Icons.chevron_right), onPressed: ()=> setState(()=> _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month+1))),
      ]),
      SizedBox(height:8),
      GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        childAspectRatio: 1.2,
        children: tiles,
      )
    ],);
  }

  void _onDayTap(DateTime dt, MoodEntry? entry) {
    final key = _keyForDate(dt);
    showModalBottomSheet(context: context, builder: (c){
      final mood = entry?.mood ?? 5;
      final notes = entry?.notes ?? '';
      final notesCtrl = TextEditingController(text: notes);
      int tempMood = mood;
      return Padding(
        padding: EdgeInsets.all(12).add(EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Mood for ${DateFormat.yMMMMd().format(dt)}', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height:8),
          Row(children:[Expanded(child: StatefulBuilder(builder: (c,s){ return Slider(value: tempMood.toDouble(), min:1, max:10, divisions:9, label: '$tempMood', onChanged: (v){ s(()=> tempMood = v.round()); }); })), SizedBox(width:8), Text('$tempMood')]),
          TextField(controller: notesCtrl, decoration: InputDecoration(labelText: 'Notes (optional)'), maxLines:3),
          SizedBox(height:8),
          Row(children: [
            ElevatedButton(onPressed: ()=> Navigator.of(context).pop(), child: Text('Cancel')),
            SizedBox(width:8),
            ElevatedButton(onPressed: () async {
              await _storage.setMoodForDate(key, tempMood, notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim());
              await _load();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved mood for ${DateFormat.yMMMMd().format(dt)}')));
            }, child: Text('Save'))
          ],)
        ],),
      );
    });
  }

  Future<void> _saveToday() async {
    final key = _keyForDate(DateTime.now());
    await _storage.setMoodForDate(key, _todayMood, _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim());
    await _load();
    widget.onMoodChanged(_todayMood);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mood for today saved')));
    _notesCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(padding: EdgeInsets.all(16), children: [
        Text('Welcome', style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height:12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('How are you feeling today?', style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height:8),
              Row(children: [
                Expanded(child: Slider(value: _todayMood.toDouble(), min:1, max:10, divisions:9, label: '$_todayMood', onChanged: (v)=> setState(()=> _todayMood = v.round()))),
                SizedBox(width:8),
                Text('$_todayMood', style: TextStyle(fontSize:18, fontWeight: FontWeight.w600))
              ]),
              SizedBox(height:8),
              TextField(controller: _notesCtrl, decoration: InputDecoration(labelText: 'Notes (optional)'), maxLines:3),
              SizedBox(height:8),
              Row(children: [ElevatedButton(onPressed: _saveToday, child: Text('Save Mood'))])
            ],),
          ),
        ),
        SizedBox(height:16),
        Text('Calendar', style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height:8),
        _buildCalendarMonth(_focusedMonth),
      ],),
    );
  }
}
