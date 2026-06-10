import 'package:flutter/material.dart';

import '../models/employee.dart';
import 'app_panel.dart';

class EmployeeTable extends StatelessWidget {
  final List<Employee> employees;
  final void Function(int index) onDelete;
  final double height;
  const EmployeeTable({
    super.key,
    required this.employees,
    required this.onDelete,
    this.height = 520,
  });

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      title: 'Danh sách nhân viên',
      icon: Icons.groups_2,
      action: Chip(
        label: Text('${employees.length} người'),
        backgroundColor: Colors.white,
      ),
      child: SizedBox(
        height: height,
        child: SingleChildScrollView(
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
            columns: const [
              DataColumn(label: Text('STT')),
              DataColumn(label: Text('MSNV')),
              DataColumn(label: Text('Tên')),
              DataColumn(label: Text('Xóa')),
            ],
            rows: List.generate(employees.length, (index) {
              final e = employees[index];

              return DataRow(
                cells: [
                  DataCell(Text('${index + 1}')),
                  DataCell(Text(e.msnv)),
                  DataCell(
                    SizedBox(
                      width: 180,
                      child: Text(e.name, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  DataCell(
                    IconButton(
                      onPressed: () => onDelete(index),
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}