import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'design_system.dart';
import 'main.dart';

class GlucoseEntry {
  const GlucoseEntry({required this.value, required this.moment, required this.at});
  final int value;
  final String moment;
  final DateTime at;
  String get dateLabel => '${at.day.toString().padLeft(2, '0')}/${at.month.toString().padLeft(2, '0')}';
  String get timeLabel => '${at.hour.toString().padLeft(2, '0')}:${at.minute.toString().padLeft(2, '0')}';
}

class GlicSplash extends StatelessWidget {
  const GlicSplash({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFFF9F5FB), GlicColors.lavender, Color(0xFFF9F7FC)],
        ),
      ),
      child: SafeArea(child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              height: 116, width: 116,
              decoration: BoxDecoration(
                color: GlicColors.primary, borderRadius: BorderRadius.circular(34),
                boxShadow: [BoxShadow(color: GlicColors.primary.withValues(alpha: .16), blurRadius: 30, offset: const Offset(0, 12))],
              ),
              child: const Icon(Icons.water_drop_rounded, size: 65, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text('GlicNote', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: GlicColors.primary, fontSize: 38)),
            const SizedBox(height: 12),
            const Text('Seu cuidado, um registro de cada vez.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: GlicColors.muted)),
            const Spacer(),
            SizedBox(width: double.infinity, child: FilledButton(
              onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const GlicShell())),
              child: const Text('Começar'),
            )),
            const SizedBox(height: 24),
          ],
        ),
      )),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.records, required this.onSeeAll, required this.onAdd});
  final List<GlucoseEntry> records;
  final VoidCallback onSeeAll;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final latest = records.first;
    final average = (records.map((e) => e.value).reduce((a,b) => a+b) / records.length).round();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Olá, bem-vindo!', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text('Minha glicemia', style: Theme.of(context).textTheme.headlineSmall),
          ])),
          CircleAvatar(backgroundColor: GlicColors.lavender, child: const Icon(Icons.person_outline, color: GlicColors.primary)),
        ]),
        const SizedBox(height: 26),
        GlicCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Última medição', style: TextStyle(color: GlicColors.muted, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('${latest.value}', style: const TextStyle(fontSize: 48, height: 1, fontWeight: FontWeight.w800, color: GlicColors.primary)),
            const Padding(padding: EdgeInsets.only(left: 7, bottom: 5), child: Text('mg/dL', style: TextStyle(color: GlicColors.muted))),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            const Icon(Icons.schedule_rounded, size: 17, color: GlicColors.muted),
            const SizedBox(width: 7),
            Text('${latest.dateLabel} às ${latest.timeLabel}  •  ${latest.moment}'),
          ]),
        ])),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _MetricCard(label: 'Média de registros', value: '$average', suffix: 'mg/dL', icon: Icons.monitor_heart_outlined)),
          const SizedBox(width: 12),
          Expanded(child: _MetricCard(label: 'Medições', value: '${records.length}', suffix: 'registros', icon: Icons.analytics_outlined)),
        ]),
        const SizedBox(height: 26),
        const SectionHeading('Evolução recente'),
        const SizedBox(height: 12),
        GlicCard(child: SizedBox(height: 160, child: GlucoseChart(entries: records.take(6).toList().reversed.toList()))),
        const SizedBox(height: 26),
        SectionHeading('Últimos registros', trailing: TextButton(onPressed: onSeeAll, child: const Text('Ver todos'))),
        const SizedBox(height: 12),
        ...records.take(3).map((entry) => Padding(padding: const EdgeInsets.only(bottom: 9), child: EntryTile(entry: entry))),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: onAdd, icon: const Icon(Icons.add), label: const Text('Nova medição'))),
      ],
    );
  }
}
class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value, required this.suffix, required this.icon});
  final String label, value, suffix;
  final IconData icon;
  @override Widget build(BuildContext context) => GlicCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Icon(icon, color: GlicColors.primary),
    const SizedBox(height: 12),
    Text(label, style: const TextStyle(fontSize: 12, color: GlicColors.muted)),
    const SizedBox(height: 6),
    Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 28, color: GlicColors.ink)),
    Text(suffix, style: const TextStyle(fontSize: 11, color: GlicColors.muted)),
  ]));
}

class EntryTile extends StatelessWidget {
  const EntryTile({super.key, required this.entry});
  final GlucoseEntry entry;
  @override Widget build(BuildContext context) => GlicCard(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
    child: Row(children: [
      Container(padding: const EdgeInsets.all(11), decoration: BoxDecoration(color: GlicColors.lavender.withValues(alpha: .6), borderRadius: BorderRadius.circular(14)),
        child: const Icon(Icons.water_drop_outlined, color: GlicColors.primary)),
      const SizedBox(width: 13),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(entry.moment, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 3),
        Text('${entry.dateLabel} • ${entry.timeLabel}', style: const TextStyle(fontSize: 12, color: GlicColors.muted)),
      ])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text('${entry.value}', style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: GlicColors.primary)),
        const Text('mg/dL', style: TextStyle(fontSize: 11, color: GlicColors.muted)),
      ]),
    ]),
  );
}

class GlucoseChart extends StatelessWidget {
  const GlucoseChart({super.key, required this.entries});
  final List<GlucoseEntry> entries;
  @override Widget build(BuildContext context) {
    if (entries.isEmpty) return const Center(child: Text('Sem medições'));
    return LayoutBuilder(builder: (context, constraints) {
      final maximum = math.max(180, entries.map((e) => e.value).reduce(math.max) + 20);
      return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        for (final entry in entries)
          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text('${entry.value}', style: const TextStyle(fontSize: 10, color: GlicColors.muted)),
              const SizedBox(height: 5),
              Container(
                height: math.max(8.0, (constraints.maxHeight - 50) * entry.value / maximum),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
                  gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [GlicColors.coral, GlicColors.primary]),
                ),
              ),
              const SizedBox(height: 6),
              Text(entry.dateLabel, style: const TextStyle(fontSize: 9, color: GlicColors.muted)),
            ]),
          )),
      ]);
    });
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, required this.records});
  final List<GlucoseEntry> records;
  @override State<HistoryScreen> createState() => _HistoryScreenState();
}
class _HistoryScreenState extends State<HistoryScreen> {
  String filter = 'Todos';
  @override Widget build(BuildContext context) {
    final items = widget.records.where((entry) => filter == 'Todos' || entry.moment == filter).toList();
    return ListView(padding: const EdgeInsets.fromLTRB(20, 20, 20, 28), children: [
      Text('Histórico', style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 5),
      const Text('Acompanhe a evolução dos seus registros.'),
      const SizedBox(height: 24),
      SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
        for (final option in ['Todos', 'Jejum', 'Após café', 'Após almoço', 'Após lanche'])
          Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(
            selected: filter == option, label: Text(option),
            selectedColor: GlicColors.lavender,
            onSelected: (_) => setState(() => filter = option),
          )),
      ])),
      const SizedBox(height: 20),
      const SectionHeading('Visão geral'),
      const SizedBox(height: 12),
      GlicCard(child: SizedBox(height: 185, child: GlucoseChart(entries: items.take(7).toList().reversed.toList()))),
      const SizedBox(height: 22),
      SectionHeading('Medições', trailing: Text('${items.length} registros', style: const TextStyle(fontSize: 12))),
      const SizedBox(height: 12),
      if (items.isEmpty) const GlicCard(child: Text('Nenhum registro encontrado.')),
      ...items.map((item) => Padding(padding: const EdgeInsets.only(bottom: 9), child: EntryTile(entry: item))),
    ]);
  }
}

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({super.key, required this.onSave});
  final ValueChanged<GlucoseEntry> onSave;
  @override State<AddRecordScreen> createState() => _AddRecordScreenState();
}
class _AddRecordScreenState extends State<AddRecordScreen> {
  final form = GlobalKey<FormState>();
  final controller = TextEditingController();
  String moment = 'Jejum';
  @override void dispose() { controller.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    Text('Nova medição', style: Theme.of(context).textTheme.headlineSmall),
    const SizedBox(height: 8),
    const Text('Registre uma nova medição de glicemia.'),
    const SizedBox(height: 24),
    GlicCard(child: Form(key: form, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      TextFormField(
        controller: controller,
        autofocus: false,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Glicemia (mg/dL)', prefixIcon: Icon(Icons.water_drop_outlined)),
        validator: (value) {
          final number = int.tryParse(value?.trim() ?? '');
          return number == null || number <= 0 || number > 1000 ? 'Informe um valor válido.' : null;
        },
      ),
      const SizedBox(height: 18),
      DropdownButtonFormField<String>(
        initialValue: moment,
        decoration: const InputDecoration(labelText: 'Momento da medição'),
        items: ['Jejum', 'Após café', 'Após almoço', 'Após lanche', 'Após janta', 'Outro']
          .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) => setState(() => moment = v ?? moment),
      ),
      const SizedBox(height: 24),
      FilledButton.icon(
        onPressed: () {
          if (form.currentState?.validate() != true) return;
          widget.onSave(GlucoseEntry(value: int.parse(controller.text.trim()), moment: moment, at: DateTime.now()));
          controller.clear();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Medição adicionada nesta sessão.')));
        },
        icon: const Icon(Icons.check),
        label: const Text('Salvar medição'),
      ),
    ]))),
    const SizedBox(height: 15),
    const Text('Os dados ficam apenas em memória nesta versão.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
  ]);
}
