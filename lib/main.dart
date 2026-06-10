import 'package:flutter/material.dart';

import 'pages/kyt_schedule_page.dart';

void main() {
  runApp(const KytScheduleApp());
}

class KytScheduleApp extends StatelessWidget {
  const KytScheduleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KYT Schedule',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.cyan,
        scaffoldBackgroundColor: const Color(0xfff4f7fb),
      ),
      home: const KytSchedulePage(),
    );
  }
}