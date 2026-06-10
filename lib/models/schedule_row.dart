import 'employee.dart';

class ScheduleRow {
  final int stt;
  final Employee employee;
  final DateTime date;

  const ScheduleRow({
    required this.stt,
    required this.employee,
    required this.date,
  });
}