import '../models/employee.dart';
import '../models/schedule_row.dart';

class KytScheduleService {
  static bool isKytDay(DateTime date) {
    return date.weekday >= DateTime.tuesday &&
        date.weekday <= DateTime.friday;
  }

  static DateTime moveToNextKytDay(DateTime date) {
    var d = date;

    while (!isKytDay(d)) {
      d = d.add(const Duration(days: 1));
    }

    return d;
  }

  static DateTime nextDateAfterAssigned(DateTime date) {
    var d = date.add(const Duration(days: 1));

    while (!isKytDay(d)) {
      d = d.add(const Duration(days: 1));
    }

    return d;
  }

  static List<ScheduleRow> generate({
    required List<Employee> employees,
    required DateTime startDate,
  }) {
    final rows = <ScheduleRow>[];
    var currentDate = moveToNextKytDay(startDate);

    for (int i = 0; i < employees.length; i++) {
      rows.add(
        ScheduleRow(
          stt: i + 1,
          employee: employees[i],
          date: currentDate,
        ),
      );

      currentDate = nextDateAfterAssigned(currentDate);
    }

    return rows;
  }
}