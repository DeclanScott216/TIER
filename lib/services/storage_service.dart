
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/appointment.dart';
import '../models/mood_entry.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static const _appointmentsKey = 'appointments_v1';
  static const _moodKey = 'moods_v1';
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Future<List<Appointment>> loadAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_appointmentsKey) ?? [];
    return raw.map((s) => Appointment.fromJson(json.decode(s))).toList();
  }

  Future<void> saveAppointments(List<Appointment> list) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = list.map((a) => json.encode(a.toJson())).toList();
    await prefs.setStringList(_appointmentsKey, raw);
  }

  Future<void> addAppointment(Appointment a) async {
    final list = await loadAppointments();
    list.add(a);
    await saveAppointments(list);
  }

  Future<void> removeAppointment(String id) async {
    final list = await loadAppointments();
    list.removeWhere((a) => a.id == id);
    await saveAppointments(list);
  }

  Future<Map<String, MoodEntry>> loadMoodsMap() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_moodKey);
    if (raw == null) return {};
    final decoded = json.decode(raw) as Map<String, dynamic>;
    return decoded.map((k, v) => MapEntry(k, MoodEntry.fromJson(v)));
  }

  Future<void> saveMoodsMap(Map<String, MoodEntry> map) async {
    final prefs = await SharedPreferences.getInstance();
    final enc = map.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString(_moodKey, json.encode(enc));
  }

  Future<void> setMoodForDate(String dateKey, int mood, String? notes) async {
    final map = await loadMoodsMap();
    map[dateKey] = MoodEntry(dateKey: dateKey, mood: mood, notes: notes);
    await saveMoodsMap(map);
  }

  Future<void> removeMoodForDate(String dateKey) async {
    final map = await loadMoodsMap();
    map.remove(dateKey);
    await saveMoodsMap(map);
  }

  Future<int?> getLatestMood() async {
    final map = await loadMoodsMap();
    if (map.isEmpty) return null;
    final keys = map.keys.toList()..sort((a,b)=>b.compareTo(a));
    return map[keys.first]!.mood;
  }

  Appointment createAppointment({required String title, required String notes, required DateTime datetime}) {
    return Appointment(id: Uuid().v4(), title: title, notes: notes, datetime: datetime);
  }
}
