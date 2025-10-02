
import 'package:intl/intl.dart';

class Appointment {
  String id;
  String title;
  String notes;
  DateTime datetime;

  Appointment({
    required this.id,
    required this.title,
    required this.notes,
    required this.datetime,
  });

  factory Appointment.fromJson(Map<String, dynamic> j) => Appointment(
    id: j['id'] as String,
    title: j['title'] as String,
    notes: j['notes'] as String,
    datetime: DateTime.parse(j['datetime'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'notes': notes,
    'datetime': datetime.toIso8601String(),
  };

  String formattedDate() => DateFormat.yMMMMd().format(datetime);
  String formattedTime() => DateFormat.jm().format(datetime);
}
