import 'employee.dart';

class ScheduleRow {
  final int? id;
  final int stt;
  final String fac;
  final Employee employee;
  final DateTime date;
  final int? roundNo;
  final String roundName;

  const ScheduleRow({
    this.id,
    required this.stt,
    required this.fac,
    required this.employee,
    required this.date,
    this.roundNo,
    required this.roundName,
  });
}
