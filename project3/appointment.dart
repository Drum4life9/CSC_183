import 'dart:convert';
import 'dart:io';

class Appointment {
  late DateTime _startTime, _endTime;
  String? _title, _description, _location;

  Appointment(
      {required DateTime startTime,
      required DateTime endTime,
      String? title,
      String? description,
      String? location})
      : _location = location,
        _description = description,
        _title = title,
        _endTime = endTime,
        _startTime = startTime {
    if (_endTime.isBefore(_startTime))
      throw Exception('End Time cannot be before Start Time!');
  }

  Appointment.fromFile({required String fileName}) {
    Map<String, dynamic> json;
    try {
      File f = File(fileName);
      json = jsonDecode(f.readAsStringSync());
    } on Exception {
      throw Exception('That file does not exist in this folder!');
    }

    _startTime = DateTime(
        json['startTime']['Year'],
        json['startTime']['Month'],
        json['startTime']['Day'],
        json['startTime']['Hour'],
        json['startTime']['Minute']);
    _endTime = DateTime(
        json['endTime']['Year'],
        json['endTime']['Month'],
        json['endTime']['Day'],
        json['endTime']['Hour'],
        json['endTime']['Minute']);
    if (_endTime.isBefore(_startTime))
      throw Exception('End Time cannot be before Start Time!');
    try {
      _title = json['title'];
    } on Exception {}
    try {
      _description = json['description'];
    } on Exception {}
    try {
      _location = json['location'];
    } on Exception {}
  }

  Appointment.defaultApp()
      : _startTime = DateTime(9999, 12, 31, 0, 0),
        _endTime = DateTime(9999, 12, 31, 0, 0);

  String? getLocation() {
    return _location;
  }

  String? getTitle() {
    return _title;
  }

  String? getDescription() {
    return _description;
  }

  bool isCurrentlyAtAppointment() {
    return _startTime.isBefore(DateTime.now()) &&
        _endTime.isAfter(DateTime.now());
  }

  bool isPastAppointment() {
    return _endTime.isBefore(DateTime.now());
  }

  Duration getAppointmentTime() {
    return _endTime.difference(_startTime);
  }

  void reschedule({DateTime? newStartDate, DateTime? newEndDate}) {
    if (newStartDate != null) _startTime = newStartDate;
    if (newEndDate != null) _endTime = newEndDate;
  }

  DateTime getStartDateTime() {
    return _startTime;
  }

  DateTime getEndDateTime() {
    return _endTime;
  }
}
