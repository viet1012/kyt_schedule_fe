import 'package:dio/dio.dart';

import '../models/employee.dart';
import '../models/schedule_row.dart';

class KytApi {
  final Dio dio;
  final String baseUrl;

  KytApi({required this.dio, required this.baseUrl});

  Future<List<Employee>> fetchEmployees({required String fac}) async {
    final res = await dio.get(
      '$baseUrl/api/kyt/employees',
      queryParameters: {'fac': fac},
    );

    final data = res.data;
    if (data is! List) return [];

    return data
        .whereType<Map>()
        .map((e) => Employee.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<Employee> addEmployee({
    required String fac,
    required String msnv,
    required String name,
    required String groupName,
    required String position,
  }) async {
    final res = await dio.post(
      '$baseUrl/api/kyt/employees',
      data: {
        'fac': fac,
        'msnv': msnv,
        'name': name,
        'groupName': groupName,
        'position': position,
      },
    );

    return Employee.fromJson(Map<String, dynamic>.from(res.data));
  }

  Future<void> deleteEmployee(int id) async {
    await dio.delete('$baseUrl/api/kyt/employees/$id');
  }

  Future<List<ScheduleRow>> fetchAllSchedules({required String fac}) async {
    final res = await dio.get(
      '$baseUrl/api/kyt/schedules/all',
      queryParameters: {'fac': fac},
    );

    return _parseScheduleRows(res.data);
  }

  Future<List<ScheduleRow>> fetchLatestSchedule({required String fac}) async {
    final res = await dio.get(
      '$baseUrl/api/kyt/schedules/latest',
      queryParameters: {'fac': fac},
    );

    return _parseScheduleRows(res.data);
  }

  Future<List<ScheduleRow>> fetchScheduleByRoundNo({
    required String fac,
    required int roundNo,
  }) async {
    final res = await dio.get(
      '$baseUrl/api/kyt/schedules',
      queryParameters: {'fac': fac, 'roundNo': roundNo},
    );

    return _parseScheduleRows(res.data);
  }

  Future<List<ScheduleRow>> generateSchedule({
    required String fac,
    required DateTime startDate,
  }) async {
    final res = await dio.post(
      '$baseUrl/api/kyt/generate',
      data: {
        'fac': fac,
        'startDate': startDate.toIso8601String().substring(0, 10),
      },
    );

    return _parseScheduleRows(res.data);
  }

  List<ScheduleRow> _parseScheduleRows(dynamic data) {
    if (data is! List) return [];

    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final json = Map<String, dynamic>.from(entry.value);

      final roundNo = json['roundNo'];
      final fac = json['fac'] ?? '';

      final emp = Employee(
        id: json['employeeId'],
        fac: fac,
        msnv: json['msnv'] ?? '',
        name: json['name'] ?? '',
        groupName: json['groupName'] ?? '',
        position: json['position'] ?? '',
      );

      return ScheduleRow(
        id: json['id'],
        stt: index + 1,
        fac: fac,
        employee: emp,
        date: DateTime.parse(json['kytDate']),
        roundNo: roundNo is int ? roundNo : int.tryParse('$roundNo'),
        roundName: json['roundName'] ?? '',
      );
    }).toList();
  }
}
