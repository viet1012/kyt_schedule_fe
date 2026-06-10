import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../api/kyt_api.dart';
import '../models/schedule_row.dart';
import '../widgets/schedule_table.dart';

class KytScheduleViewPage extends StatefulWidget {
  final String fac;

  const KytScheduleViewPage({super.key, required this.fac});

  @override
  State<KytScheduleViewPage> createState() => _KytScheduleViewPageState();
}

class _KytScheduleViewPageState extends State<KytScheduleViewPage> {
  late final KytApi _api;

  List<ScheduleRow> _schedule = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();

    _api = KytApi(dio: Dio(), baseUrl: 'http://192.168.122.16:9100');

    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final rows = await _api.fetchLatestSchedule(fac: widget.fac);

      if (!mounted) return;

      setState(() {
        _schedule = rows;
      });
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

  Widget _buildHeader() {
    final roundName = _schedule.isNotEmpty
        ? _schedule.first.roundName
        : 'Latest Round';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_month, color: Colors.cyan.shade700, size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${widget.fac} KYT Schedule - $roundName',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
          ),

          FilledButton.icon(
            onPressed: _loading ? null : _loadSchedule,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(double tableHeight) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      );
    }

    return ScheduleTable(schedule: _schedule, height: tableHeight);
  }

  @override
  Widget build(BuildContext context) {
    final tableHeight = MediaQuery.of(context).size.height - 190;

    return Scaffold(
      backgroundColor: const Color(0xfff4f7fb),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 14),
              Expanded(child: _buildBody(tableHeight)),
            ],
          ),
        ),
      ),
    );
  }
}
