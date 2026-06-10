import 'package:flutter/material.dart';

import '../models/employee.dart';
import '../models/schedule_row.dart';
import '../services/kyt_schedule_service.dart';
import '../widgets/employee_table.dart';
import '../widgets/kyt_input_panel.dart';
import '../widgets/schedule_table.dart';

class KytSchedulePage extends StatefulWidget {
  const KytSchedulePage({super.key});

  @override
  State<KytSchedulePage> createState() => _KytSchedulePageState();
}

class _KytSchedulePageState extends State<KytSchedulePage> {
  final _msnvCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _groupCtrl = TextEditingController();
  final _positionCtrl = TextEditingController();

  DateTime _startDate = DateTime.now();

  final List<Employee> _employees = const [
    Employee(
      msnv: '21808',
      name: 'Lê Giang Lam Tuyền',
      group: 'Planning',
      position: 'Leader',
    ),
    Employee(
      msnv: '20397',
      name: 'Nguyễn Thanh Long',
      group: 'IT',
      position: 'Sub Leader',
    ),
    Employee(
      msnv: '22471',
      name: 'Nguyễn Bá Phúc',
      group: 'IT',
      position: 'Office staff',
    ),
  ].toList();

  List<ScheduleRow> _schedule = [];

  void _generateSchedule() {
    setState(() {
      _schedule = KytScheduleService.generate(
        employees: _employees,
        startDate: _startDate,
      );
    });
  }

  void _addEmployee() {
    final msnv = _msnvCtrl.text.trim();
    final name = _nameCtrl.text.trim();
    final group = _groupCtrl.text.trim();
    final position = _positionCtrl.text.trim();

    if (msnv.isEmpty || name.isEmpty) return;

    setState(() {
      _employees.add(
        Employee(
          msnv: msnv,
          name: name,
          group: group,
          position: position,
        ),
      );

      _msnvCtrl.clear();
      _nameCtrl.clear();
      _groupCtrl.clear();
      _positionCtrl.clear();
      _schedule.clear();
    });
  }

  void _deleteEmployee(int index) {
    setState(() {
      _employees.removeAt(index);
      _schedule.clear();
    });
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2035),
    );

    if (picked == null) return;

    setState(() {
      _startDate = picked;
      _schedule.clear();
    });
  }

  Widget _bodyLayout(double width) {
    final isWide = width >= 1000;

    if (!isWide) {
      return Column(
        children: [
          EmployeeTable(
            employees: _employees,
            onDelete: _deleteEmployee,
          ),
          const SizedBox(height: 16),
          ScheduleTable(schedule: _schedule),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: EmployeeTable(
            employees: _employees,
            onDelete: _deleteEmployee,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 7,
          child: ScheduleTable(schedule: _schedule),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _msnvCtrl.dispose();
    _nameCtrl.dispose();
    _groupCtrl.dispose();
    _positionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAC 2 OFFICE KYT SCHEDULE'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                KytInputPanel(
                  msnvCtrl: _msnvCtrl,
                  nameCtrl: _nameCtrl,
                  groupCtrl: _groupCtrl,
                  positionCtrl: _positionCtrl,
                  startDate: _startDate,
                  onAddEmployee: _addEmployee,
                  onPickDate: _pickStartDate,
                  onGenerate: _generateSchedule,
                ),
                const SizedBox(height: 16),
                _bodyLayout(constraints.maxWidth),
              ],
            ),
          );
        },
      ),
    );
  }
}