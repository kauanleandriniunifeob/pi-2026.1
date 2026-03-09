import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ── Tipos ──────────────────────────────────────────────────────────────────────
typedef _PieSec = ({String label, double value, Color color});
typedef _Causa = ({String label, double value, Color color});
typedef _Kpi = ({
  IconData icon,
  String label,
  String value,
  Color color,
  String detail,
});
typedef _Secao = ({
  String code,
  String label,
  int ocorrencias,
  Color color,
  String descricao,
});

const _kRed = Color(0xFFB71C1C);

// ════════════════════════════════════════════════════════════════════════════════
// DADOS DO DASHBOARD
// Futuramente iemos alimentar com dados reais, vindos das analises por IA.
// ════════════════════════════════════════════════════════════════════════════════

// ── KPIs (cartões de resumo no topo) ──────────────────────────────────────────
const kDashKpis = <_Kpi>[
  (
    icon: Icons.inventory_2_outlined,
    label: 'Peças\nAnalisadas',
    value: '2.500',
    color: _kRed,
    detail:
        'Total de peças inspecionadas nos últimos 30 dias.\n\n+12% em relação ao mês anterior.',
  ),
  (
    icon: Icons.speed_outlined,
    label: 'Eficiência\nGeral',
    value: '94%',
    color: Color(0xFF2E7D32),
    detail:
        'Taxa de eficiência geral da linha de produção.\n\nMeta: 95% até Q2/2026.',
  ),
  (
    icon: Icons.factory_outlined,
    label: 'Setores\nCadastrados',
    value: '11',
    color: Color(0xFF1565C0),
    detail:
        '11 setores ativos monitorados pelo sistema.\n\n2 setores em processo de cadastro.',
  ),
];

// ── Gráfico de Pizza — Defeitos Detectados ────────────────────────────────────
const kDashPieSections = <_PieSec>[
  (label: 'Trincas', value: 40.0, color: Color(0xFF6A1B9A)),
  (label: 'Calor excessivo', value: 35.0, color: _kRed),
  (label: 'Outros', value: 25.0, color: Color(0xFF546E7A)),
];

// ── Gráfico de Linha — Taxa de Defeitos (por período) ─────────────────────────
// Índice: 0 = Semana  |  1 = Mês  |  2 = Trimestre
const kDashPeriodLabels = <int, List<String>>{
  0: ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'],
  1: ['Ago', 'Set', 'Out', 'Nov', 'Dez', 'Jan', 'Fev'],
  2: ['T1/24', 'T2/24', 'T3/24', 'T4/24', 'T1/25', 'T2/25', 'T3/25'],
};
const kDashPeriodSpots = <int, List<FlSpot>>{
  0: [
    FlSpot(0, 1.2),
    FlSpot(1, 2.1),
    FlSpot(2, 1.8),
    FlSpot(3, 3.0),
    FlSpot(4, 2.5),
    FlSpot(5, 1.0),
    FlSpot(6, 0.8),
  ],
  1: [
    FlSpot(0, 2.0),
    FlSpot(1, 3.5),
    FlSpot(2, 2.8),
    FlSpot(3, 4.2),
    FlSpot(4, 3.8),
    FlSpot(5, 5.0),
    FlSpot(6, 3.2),
  ],
  2: [
    FlSpot(0, 8.0),
    FlSpot(1, 11.0),
    FlSpot(2, 9.5),
    FlSpot(3, 13.0),
    FlSpot(4, 10.5),
    FlSpot(5, 15.0),
    FlSpot(6, 12.0),
  ],
};
// Valor máximo do eixo Y para cada período
const kDashPeriodMaxY = <int, double>{0: 4.0, 1: 7.0, 2: 18.0};

// ── Principais Causas — valores entre 0.0 e 1.0 (representam %) ──────────────
const kDashCausas = <_Causa>[
  (label: 'Falha Humana', value: 0.45, color: _kRed),
  (label: 'Maquinário Antigo', value: 0.30, color: Color(0xFF6A1B9A)),
  (label: 'Matéria-prima', value: 0.15, color: Color(0xFFE65100)),
  (label: 'Manutenção', value: 0.10, color: Color(0xFF00695C)),
];

// ── Seções com Mais Ocorrências ───────────────────────────────────────────────
const kDashSecoes = <_Secao>[
  (
    code: 'F1',
    label: 'Seção F1',
    ocorrencias: 32,
    color: _kRed,
    descricao:
        'Setor de fundição primária. Alta incidência de trincas relacionadas à variação térmica acima de 800°C.',
  ),
  (
    code: 'D4',
    label: 'Seção D4',
    ocorrencias: 27,
    color: Color(0xFF6A1B9A),
    descricao:
        'Área de desbaste mecânico. Desgaste prematuro de ferramentas gera irregularidades na superfície das peças.',
  ),
  (
    code: 'G6',
    label: 'Seção G6',
    ocorrencias: 18,
    color: Color(0xFF2E7D32),
    descricao:
        'Linha de acabamento galvânico. Ocorrências pontuais associadas à variação na qualidade da matéria-prima.',
  ),
  (
    code: 'J4',
    label: 'Seção J4',
    ocorrencias: 11,
    color: Color(0xFF546E7A),
    descricao:
        'Inspeção final de qualidade. Defeitos identificados são provenientes de problemas em seções anteriores.',
  ),
];

// ── Page ───────────────────────────────────────────────────────────────────────

class DashboardRelatoriosPage extends StatefulWidget {
  const DashboardRelatoriosPage({super.key});

  @override
  State<DashboardRelatoriosPage> createState() =>
      _DashboardRelatoriosPageState();
}

class _DashboardRelatoriosPageState extends State<DashboardRelatoriosPage>
    with SingleTickerProviderStateMixin {
  int _selectedPeriod = 1; // 0 = Semana, 1 = Mês, 2 = Trimestre
  int _touchedPieIndex = -1;
  late final AnimationController _animController;
  late final Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    _progressAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: _kRed,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Relatórios',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildKpiRow(),
            const SizedBox(height: 20),
            _buildPieCard(),
            const SizedBox(height: 20),
            _buildLineChartCard(),
            const SizedBox(height: 20),
            _buildCausasCard(),
            const SizedBox(height: 20),
            _buildSecoesCard(),
          ],
        ),
      ),
    );
  }

  // ── KPI row ────────────────────────────────────────────────────────────────

  Widget _buildKpiRow() {
    const kpis = kDashKpis;

    return Row(
      children: [
        for (int i = 0; i < kpis.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          Expanded(
            child: _KpiTile(
              icon: kpis[i].icon,
              label: kpis[i].label,
              value: kpis[i].value,
              color: kpis[i].color,
              onTap: () => _showKpiDetail(
                context,
                kpis[i].label.replaceAll('\n', ' '),
                kpis[i].value,
                kpis[i].detail,
                kpis[i].color,
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showKpiDetail(
    BuildContext context,
    String title,
    String value,
    String detail,
    Color color,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        title: Row(
          children: [
            Container(
              width: 6,
              height: 32,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Text(
          detail,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
            color: Color(0xFF444444),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Fechar',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ── Pie chart ──────────────────────────────────────────────────────────────

  Widget _buildPieCard() {
    const sections = kDashPieSections;

    return _DashCard(
      title: 'Defeitos Detectados',
      icon: Icons.donut_large_outlined,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 140,
            height: 150,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          response == null ||
                          response.touchedSection == null) {
                        _touchedPieIndex = -1;
                        return;
                      }
                      _touchedPieIndex =
                          response.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                sections: [
                  for (int i = 0; i < sections.length; i++)
                    PieChartSectionData(
                      value: sections[i].value,
                      color: sections[i].color,
                      title: _touchedPieIndex == i
                          ? sections[i].label
                          : '${sections[i].value.toInt()}%',
                      titleStyle: TextStyle(
                        fontSize: _touchedPieIndex == i ? 9 : 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: const [
                          Shadow(blurRadius: 2, color: Colors.black38),
                        ],
                      ),
                      radius: _touchedPieIndex == i ? 64 : 52,
                    ),
                ],
                sectionsSpace: 3,
                centerSpaceRadius: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Toque para detalhes',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                for (int i = 0; i < sections.length; i++)
                  GestureDetector(
                    onTap: () => setState(
                      () => _touchedPieIndex = _touchedPieIndex == i ? -1 : i,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: _touchedPieIndex == i
                            ? sections[i].color.withValues(alpha: 0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _touchedPieIndex == i
                              ? sections[i].color.withValues(alpha: 0.4)
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: _touchedPieIndex == i ? 14 : 10,
                            height: _touchedPieIndex == i ? 14 : 10,
                            decoration: BoxDecoration(
                              color: sections[i].color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              sections[i].label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: _touchedPieIndex == i
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          Text(
                            '${sections[i].value.toInt()}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: sections[i].color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Line chart ─────────────────────────────────────────────────────────────

  Widget _buildLineChartCard() {
    final labels = kDashPeriodLabels[_selectedPeriod]!;
    final spots = kDashPeriodSpots[_selectedPeriod]!;
    final maxY = kDashPeriodMaxY[_selectedPeriod]!;

    return _DashCard(
      title: 'Taxa de Defeitos',
      icon: Icons.trending_up,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (int i = 0; i < 3; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _PeriodChip(
                    label: const ['Semana', 'Mês', 'Trimestre'][i],
                    selected: _selectedPeriod == i,
                    onTap: () => setState(() => _selectedPeriod = i),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: SizedBox(
              key: ValueKey(_selectedPeriod),
              height: 160,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: maxY,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxY / 3,
                    getDrawingHorizontalLine: (_) => const FlLine(
                      color: Color(0xFFEEEEEE),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: maxY / 3,
                        reservedSize: 30,
                        getTitlesWidget: (v, _) => Text(
                          v.toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          final i = v.toInt();
                          if (i < 0 || i >= labels.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              labels[i],
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => const Color(0xFF1A1A1A),
                      getTooltipItems: (touchedSpots) => touchedSpots
                          .map(
                            (s) => LineTooltipItem(
                              '${s.y.toStringAsFixed(1)} defeitos',
                              const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: _kRed,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (_, _, _, _) => FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: _kRed,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            _kRed.withValues(alpha: 0.25),
                            _kRed.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Causas ─────────────────────────────────────────────────────────────────

  Widget _buildCausasCard() {
    const causas = kDashCausas;

    return _DashCard(
      title: 'Principais Causas',
      icon: Icons.analytics_outlined,
      child: Column(
        children: [
          for (final c in causas)
            _AnimatedProgressRow(
              label: c.label,
              value: c.value,
              color: c.color,
              animation: _progressAnim,
            ),
        ],
      ),
    );
  }

  // ── Seções ─────────────────────────────────────────────────────────────────

  Widget _buildSecoesCard() {
    const secoes = kDashSecoes;

    return _DashCard(
      title: 'Seções com Mais Ocorrências',
      icon: Icons.grid_view_outlined,
      child: Column(
        children: [
          for (final s in secoes)
            _SecaoTile(
              code: s.code,
              label: s.label,
              subtitle: '${s.ocorrencias} ocorrências',
              color: s.color,
              onTap: () => _showSecaoDetail(context, s),
            ),
        ],
      ),
    );
  }

  void _showSecaoDetail(BuildContext context, _Secao s) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: s.color.withValues(alpha: 0.12),
                  radius: 28,
                  child: Text(
                    s.code,
                    style: TextStyle(
                      color: s.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '${s.ocorrencias} ocorrências registradas',
                      style: TextStyle(
                        color: s.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Descrição',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              s.descricao,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Color(0xFF444444),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, size: 18),
                label: const Text('Fechar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: s.color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared widgets ─────────────────────────────────────────────────────────────

class _PeriodChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PeriodChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? _kRed : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? _kRed : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}

class _KpiTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  const _KpiTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _DashCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _kRed, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF212121),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),
          child,
        ],
      ),
    );
  }
}

class _AnimatedProgressRow extends AnimatedWidget {
  final String label;
  final double value;
  final Color color;

  const _AnimatedProgressRow({
    required this.label,
    required this.value,
    required this.color,
    required Animation<double> animation,
  }) : super(listenable: animation);

  Animation<double> get _anim => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 13)),
              Text(
                '${(value * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value * _anim.value,
              minHeight: 8,
              backgroundColor: color.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecaoTile extends StatelessWidget {
  final String code;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _SecaoTile({
    required this.code,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.12),
              child: Text(
                code,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            title: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ),
        ),
      ),
    );
  }
}
