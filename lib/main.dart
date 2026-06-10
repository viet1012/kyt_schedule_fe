import 'package:flutter/material.dart';
import 'package:kyt_schedule/widgets/kyt_schedule_view_page.dart';

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
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '');

        if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'kyt-view') {
          final fac = uri.pathSegments[1];

          return MaterialPageRoute(
            builder: (_) => KytScheduleViewPage(fac: fac),
          );
        }

        if (uri.path == '/kyt-admin') {
          return MaterialPageRoute(builder: (_) => const KytSchedulePage());
        }

        return MaterialPageRoute(builder: (_) => const KytSchedulePage());
      },
    );
  }
}
