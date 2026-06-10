import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/schedule_row.dart';
import 'app_panel.dart';

class ScheduleTable extends StatelessWidget {
  final List<ScheduleRow> schedule;

  ScheduleTable({
    super.key,
    required this.schedule,
  });

  final _fmt = DateFormat('d-MMM-yy', 'en_US');

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      title: 'Lịch KYT đã tạo',
      icon: Icons.calendar_month,
      action: Chip(
        label: Text('${schedule.length} dòng'),
        backgroundColor: Colors.white,
      ),
      child: SizedBox(
        height: 520,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
              columns: const [
                DataColumn(label: Text('STT')),
                DataColumn(label: Text('MSNV')),
                DataColumn(label: Text('Group')),
                DataColumn(label: Text('Họ và tên')),
                DataColumn(label: Text('Chức vụ')),
                DataColumn(label: Text('Round 3')),
              ],
              rows: schedule.map((row) {
                return DataRow(
                  cells: [
                    DataCell(Text('${row.stt}')),
                    DataCell(Text(row.employee.msnv)),
                    DataCell(Text(row.employee.group)),
                    DataCell(
                      SizedBox(
                        width: 190,
                        child: Text(
                          row.employee.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(Text(row.employee.position)),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.cyan.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _fmt.format(row.date),
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
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