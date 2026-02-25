import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:bsms/exports.dart';

class RevenueChartCard extends StatefulWidget {
  const RevenueChartCard({super.key});

  @override
  State<RevenueChartCard> createState() => _RevenueChartCardState();
}

class _RevenueChartCardState extends State<RevenueChartCard> {
  bool isDaily = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppDecorations.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Income vs Expenses',
                style: AppTextStyles.heading.copyWith(
                  fontSize: 18,
                  color: AppColors.black,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBg,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildToggleButton('Daily', true),
                    _buildToggleButton('Monthly', false),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildLegend(color: AppColors.primary, label: 'Income'),
              const SizedBox(width: 16),
              _buildLegend(color: AppColors.error, label: 'Expense'),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: LineChart(isDaily ? _dailyChartData() : _monthlyChartData()),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String title, bool isDailyOption) {
    final isSelected = isDaily == isDailyOption;
    return GestureDetector(
      onTap: () {
        setState(() {
          isDaily = isDailyOption;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.grey,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildLegend({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  LineChartData _baseChartData(
    List<FlSpot> incomeSpots,
    List<FlSpot> expenseSpots,
    double maxX,
  ) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.border,
            strokeWidth: 1,
            dashArray: [4, 4],
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final titles = isDaily
                  ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                  : ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];
              if (value.toInt() >= 0 && value.toInt() < titles.length) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 8,
                  child: Text(
                    titles[value.toInt()],
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 2,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  '\$${value.toInt()}k',
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: maxX,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        // Income Line
        LineChartBarData(
          spots: incomeSpots,
          isCurved: true,
          color: AppColors.primary,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.2),
                AppColors.primary.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Expense Line
        LineChartBarData(
          spots: expenseSpots,
          isCurved: true,
          color: AppColors.error,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppColors.error.withOpacity(0.2),
                AppColors.error.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => AppColors.black.withOpacity(0.8),
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final textStyle = TextStyle(
                color: touchedSpot.bar.color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              );
              return LineTooltipItem('\$${touchedSpot.y}k', textStyle);
            }).toList();
          },
        ),
      ),
    );
  }

  LineChartData _dailyChartData() {
    return _baseChartData(
      const [
        FlSpot(0, 3),
        FlSpot(1, 4.5),
        FlSpot(2, 3.5),
        FlSpot(3, 5),
        FlSpot(4, 7),
        FlSpot(5, 6),
        FlSpot(6, 8),
      ],
      const [
        FlSpot(0, 2),
        FlSpot(1, 3),
        FlSpot(2, 2.5),
        FlSpot(3, 3),
        FlSpot(4, 4),
        FlSpot(5, 3.5),
        FlSpot(6, 4.5),
      ],
      6,
    );
  }

  LineChartData _monthlyChartData() {
    return _baseChartData(
      const [
        FlSpot(0, 4),
        FlSpot(1, 5.5),
        FlSpot(2, 5),
        FlSpot(3, 7.5),
        FlSpot(4, 6),
        FlSpot(5, 8.5),
        FlSpot(6, 9),
      ],
      const [
        FlSpot(0, 2.5),
        FlSpot(1, 3.5),
        FlSpot(2, 3.5),
        FlSpot(3, 4.5),
        FlSpot(4, 3.5),
        FlSpot(5, 5),
        FlSpot(6, 4.5),
      ],
      6,
    );
  }
}
