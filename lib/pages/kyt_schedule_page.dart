import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../api/kyt_api.dart';
import '../models/employee.dart';
import '../models/schedule_row.dart';
import '../widgets/employee_table.dart';
import '../widgets/kyt_input_panel.dart';
import '../widgets/schedule_table.dart';

class KytSchedulePage extends StatefulWidget {
  const KytSchedulePage({super.key});

  @override
  State<KytSchedulePage> createState() => _KytSchedulePageState();
}

class _KytSchedulePageState extends State<KytSchedulePage> {
  static const String _adminPassword = '1012';

  final _msnvCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _groupCtrl = TextEditingController();
  final _positionCtrl = TextEditingController();

  late final KytApi _api;

  String _selectedFac = 'Fac_2';
  DateTime _startDate = DateTime.now();

  List<Employee> _employees = [];
  List<ScheduleRow> _schedule = [];

  bool _loading = false;
  String? _error;

  bool _viewAllRounds = false;

  @override
  void initState() {
    super.initState();

    _api = KytApi(dio: Dio(), baseUrl: 'http://192.168.122.16:9100');

    _loadData();
  }

  Future<List<ScheduleRow>> _fetchScheduleByMode() {
    if (_viewAllRounds) {
      return _api.fetchAllSchedules(fac: _selectedFac);
    }

    return _api.fetchLatestSchedule(fac: _selectedFac);
  }

  Future<void> _loadData() async {
    await _runApi(() async {
      final employees = await _api.fetchEmployees(fac: _selectedFac);
      final schedule = await _fetchScheduleByMode();

      if (!mounted) return;

      setState(() {
        _employees = employees;
        _schedule = schedule;
      });
    });
  }

  Future<bool> _askPassword() async {
    final ctrl = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('Nhập password'),
          content: TextField(
            controller: ctrl,
            obscureText: true,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) {
              if (ctrl.text.trim() == _adminPassword) {
                Navigator.pop(context, true);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () {
                final ok = ctrl.text.trim() == _adminPassword;

                if (!ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password không đúng')),
                  );
                  return;
                }

                Navigator.pop(context, true);
              },
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );

    ctrl.dispose();

    return result == true;
  }

  Future<bool> _confirmDelete(Employee emp) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc muốn xóa nhân viên:\n\n${emp.msnv} - ${emp.name} ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy'),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    return result == true;
  }

  Future<void> _runApi(Future<void> Function() action) async {
    if (!mounted) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await action();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
      });
    } finally {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _onFacChanged(String fac) async {
    setState(() {
      _selectedFac = fac;
      _employees = [];
      _schedule = [];
    });

    await _loadData();
  }

  Future<void> _generateSchedule() async {
    final ok = await _askPassword();
    if (!ok) return;

    await _runApi(() async {
      final rows = await _api.generateSchedule(
        fac: _selectedFac,
        startDate: _startDate,
      );

      if (!mounted) return;

      setState(() {
        _viewAllRounds = false;
        _schedule = rows;
      });
    });
  }

  Future<void> _addEmployee() async {
    final msnv = _msnvCtrl.text.trim();
    final name = _nameCtrl.text.trim();
    final group = _groupCtrl.text.trim();
    final position = _positionCtrl.text.trim();

    if (msnv.isEmpty || name.isEmpty) return;

    final ok = await _askPassword();
    if (!ok) return;

    await _runApi(() async {
      await _api.addEmployee(
        fac: _selectedFac,
        msnv: msnv,
        name: name,
        groupName: group,
        position: position,
      );

      _msnvCtrl.clear();
      _nameCtrl.clear();
      _groupCtrl.clear();
      _positionCtrl.clear();

      final employees = await _api.fetchEmployees(fac: _selectedFac);

      // final schedule = await _api.fetchLatestSchedule(fac: _selectedFac);
      final schedule = await _fetchScheduleByMode();
      setState(() {
        _employees = employees;
        _schedule = schedule;
      });
    });
  }

  Future<void> _deleteEmployee(int index) async {
    final emp = _employees[index];
    final id = emp.id;

    if (id == null) return;

    final confirm = await _confirmDelete(emp);
    if (!mounted || !confirm) return;

    final ok = await _askPassword();
    if (!mounted || !ok) return;

    await _runApi(() async {
      await _api.deleteEmployee(id);

      final employees = await _api.fetchEmployees(fac: _selectedFac);

      // final schedule = await _api.fetchLatestSchedule(fac: _selectedFac);
      final schedule = await _fetchScheduleByMode();
      if (!mounted) return;

      setState(() {
        _employees = employees;
        _schedule = schedule;
      });
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
    final tableHeight = MediaQuery.of(context).size.height - 260;
    final isWide = width >= 1000;

    if (!isWide) {
      return Column(
        children: [
          EmployeeTable(
            employees: _employees,
            onDelete: _deleteEmployee,
            height: tableHeight,
          ),
          const SizedBox(height: 16),
          ScheduleTable(schedule: _schedule, height: tableHeight),
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
            height: tableHeight,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 7,
          child: ScheduleTable(schedule: _schedule, height: tableHeight),
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
    final title = '$_selectedFac OFFICE KYT SCHEDULE';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: false,
                  label: Text('Latest'),
                  icon: Icon(Icons.filter_1),
                ),
                ButtonSegment(
                  value: true,
                  label: Text('All'),
                  icon: Icon(Icons.all_inbox),
                ),
              ],
              selected: {_viewAllRounds},
              onSelectionChanged: (value) async {
                setState(() {
                  _viewAllRounds = value.first;
                  _schedule = [];
                });

                await _loadData();
              },
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    KytInputPanel(
                      msnvCtrl: _msnvCtrl,
                      nameCtrl: _nameCtrl,
                      groupCtrl: _groupCtrl,
                      positionCtrl: _positionCtrl,
                      selectedFac: _selectedFac,
                      onFacChanged: _onFacChanged,
                      startDate: _startDate,
                      onAddEmployee: _addEmployee,
                      onPickDate: _pickStartDate,
                      onGenerate: _generateSchedule,
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Material(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red.shade700,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _error!,
                                  style: TextStyle(color: Colors.red.shade700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    _bodyLayout(constraints.maxWidth),
                  ],
                ),
              ),
              if (_loading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.08),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
