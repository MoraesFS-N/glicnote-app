import 'package:flutter/material.dart';
import 'design_system.dart';
import 'screens.dart';

void main() => runApp(const GlicNoteApp());

class GlicNoteApp extends StatelessWidget {
  const GlicNoteApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'GlicNote',
    debugShowCheckedModeBanner: false,
    theme: GlicTheme.light,
    home: const GlicSplash(),
  );
}

class GlicShell extends StatefulWidget {
  const GlicShell({super.key});
  @override
  State<GlicShell> createState() => _GlicShellState();
}

class _GlicShellState extends State<GlicShell> {
  int selected = 0;
  final records = <GlucoseEntry>[
    GlucoseEntry(value: 94, moment: 'Jejum', at: DateTime(2026, 10, 20, 7, 30)),
    GlucoseEntry(value: 109, moment: 'Após café', at: DateTime(2026, 10, 19, 9, 10)),
    GlucoseEntry(value: 159, moment: 'Após almoço', at: DateTime(2026, 10, 19, 13, 20)),
    GlucoseEntry(value: 115, moment: 'Após lanche', at: DateTime(2026, 10, 18, 16, 30)),
    GlucoseEntry(value: 90, moment: 'Após café', at: DateTime(2026, 10, 18, 9, 0)),
    GlucoseEntry(value: 119, moment: 'Após almoço', at: DateTime(2026, 10, 17, 13, 20)),
  ];

  void addEntry(GlucoseEntry entry) {
    setState(() {
      records.insert(0, entry);
      records.sort((a,b) => b.at.compareTo(a.at));
      selected = 1;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: IndexedStack(
        index: selected,
        children: [
          HomeScreen(records: records, onSeeAll: () => setState(() => selected = 1), onAdd: () => setState(() => selected = 2)),
          HistoryScreen(records: records),
          AddRecordScreen(onSave: addEntry),
        ],
      ),
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: selected,
      onDestinationSelected: (value) => setState(() => selected = value),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Início'),
        NavigationDestination(icon: Icon(Icons.show_chart_outlined), selectedIcon: Icon(Icons.show_chart), label: 'Histórico'),
        NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle), label: 'Registrar'),
      ],
    ),
  );
}
