
class MoodEntry {
  final String dateKey; // yyyy-MM-dd
  final int mood; // 1-10
  final String? notes;

  MoodEntry({required this.dateKey, required this.mood, this.notes});

  factory MoodEntry.fromJson(Map<String, dynamic> j) => MoodEntry(
    dateKey: j['dateKey'] as String,
    mood: j['mood'] as int,
    notes: j['notes'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'dateKey': dateKey,
    'mood': mood,
    'notes': notes,
  };
}
