import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/schedule_row.dart';
import 'app_panel.dart';

class ScheduleTable extends StatelessWidget {
  final List<ScheduleRow> schedule;
  final double height;

  ScheduleTable({super.key, required this.schedule, this.height = 520});

  final _fmt = DateFormat('d-MMM-yy', 'en_US');

  bool _isToday(DateTime date) {
    final now = DateTime.now();

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Widget _dateCell(DateTime date) {
    final isToday = _isToday(date);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isToday ? Colors.orange.shade600 : Colors.cyan.shade300,
        borderRadius: BorderRadius.circular(8),
        boxShadow: isToday
            ? [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isToday) ...[
            const Icon(Icons.today, size: 16, color: Colors.white),
            const SizedBox(width: 6),
          ],
          Text(
            _fmt.format(date),
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusCell(DateTime date) {
    if (!_isToday(date)) {
      return Text('-', style: TextStyle(color: Colors.grey.shade400));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.green.shade600,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Text(
        'TODAY',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roundTitle = schedule.isNotEmpty ? schedule.first.roundName : 'Round';

    return AppPanel(
      title: 'Lịch KYT đã tạo',
      icon: Icons.calendar_month,
      action: Chip(
        label: Text('${schedule.length} dòng'),
        backgroundColor: Colors.white,
      ),
      child: SizedBox(
        height: height,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
              dataRowMinHeight: 54,
              dataRowMaxHeight: 62,
              columnSpacing: 28,
              columns: [
                const DataColumn(label: Text('STT')),
                const DataColumn(label: Text('MSNV')),
                const DataColumn(label: Text('Group')),
                const DataColumn(label: Text('Họ và tên')),
                const DataColumn(label: Text('Chức vụ')),
                DataColumn(label: Text(roundTitle)),
                const DataColumn(label: Text('Status')),
              ],
              rows: schedule.map((row) {
                final isToday = _isToday(row.date);

                return DataRow(
                  color: WidgetStateProperty.resolveWith<Color?>((states) {
                    if (isToday) {
                      return Colors.orange.withOpacity(0.10);
                    }

                    return null;
                  }),
                  cells: [
                    DataCell(
                      Text(
                        '${row.stt}',
                        style: TextStyle(
                          fontWeight: isToday
                              ? FontWeight.w900
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        row.employee.msnv,
                        style: TextStyle(
                          fontWeight: isToday
                              ? FontWeight.w900
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    DataCell(Text(row.employee.groupName)),
                    DataCell(
                      SizedBox(
                        width: 210,
                        child: Text(
                          row.employee.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: isToday
                                ? FontWeight.w900
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(row.employee.position)),
                    DataCell(_dateCell(row.date)),
                    DataCell(_statusCell(row.date)),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
