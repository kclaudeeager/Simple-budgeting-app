import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/budget.dart';

class BudgetUsageChart extends StatelessWidget {
  final Budget budget;

  const BudgetUsageChart({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    // Calculate the responsive font size based on screen dimensions
    final double responsiveFontSize = (MediaQuery.of(context).size.width * 0.035).clamp(10.0, 16.0);
    final double responsivePadding = (MediaQuery.of(context).size.width * 0.04).clamp(8.0, 20.0);

    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart Summary
          Padding(
            padding: EdgeInsets.all(responsivePadding),
            child: Text(
              'Budget Usage Summary',
              style: TextStyle(
                fontSize: responsiveFontSize * 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // TabBar
          const TabBar(
            tabs: [
              Tab(text: 'Line Chart'),
              Tab(text: 'Remaining Budget'),
              Tab(text: 'Transactions'),
            ],
          ),
          // TabBarView
          Expanded(
            child: TabBarView(
              children: [
                _buildLineChart(context, responsiveFontSize, responsivePadding),
                _buildRemainingBudgetChart(context, responsiveFontSize, responsivePadding),
                _buildTransactionsChart(context, responsiveFontSize, responsivePadding),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget _buildLineChart(BuildContext context, double responsiveFontSize, double responsivePadding) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.all(responsivePadding),
        child: Text(
          'This chart shows the budget usage over time, including the set budget, used budget, added budget versions, and remaining budget.',
          style: TextStyle(fontSize: responsiveFontSize),
        ),
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsets.all(responsivePadding),
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) {
                      final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "${date.day}/${date.month}",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: responsiveFontSize,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          _formatNumber(value.toInt()),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: responsiveFontSize,
                          ),
                        ),
                      );
                    },
                  ),
                  axisNameWidget: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      budget.currency,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: responsiveFontSize,
                      ),
                    ),
                  ),
                  axisNameSize: responsiveFontSize,
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.5),
                    strokeWidth: 1,
                  );
                },
                drawHorizontalLine: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.5),
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              lineBarsData: [
                _buildLineChartBarData(
                  _getInitialBudgetData(),
                  Colors.blue,
                  'Set Budget',
                ),
                _buildLineChartBarData(
                  _getUsedBudgetData(),
                  Colors.red,
                  'Used Budget',
                ),
                _buildLineChartBarData(
                  _getAddedBudgetData(),
                  Colors.green,
                  'Added Budget Versions',
                ),
                _buildLineChartBarData(
                  _getRemainingBudgetData(),
                  Colors.orange,
                  'Remaining Budget',
                ),
              ],
              lineTouchData: LineTouchData(
                enabled: true,
                getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                  return spotIndexes.map((index) {
                    return TouchedSpotIndicatorData(
                      const FlLine(color: Colors.black, strokeWidth: 2),
                      FlDotData(show: true, getDotPainter: (spot, percent, bar, index) {
                        return FlDotCirclePainter(
                          radius: 6,
                          color: Colors.white,
                          strokeWidth: 3,
                          strokeColor: barData.color ?? Colors.black,
                        );
                      }),
                    );
                  }).toList();
                },
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (List<LineBarSpot> touchedSpots) {
                    return touchedSpots.map((spot) {
                      final DateTime date = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                      return LineTooltipItem(
                        '${spot.bar.color == Colors.blue ? "Budget Set" : spot.bar.color == Colors.red ? "Used Budget" : spot.bar.color == Colors.green ? "Added Budget" : "Remaining Budget"}\n'
                            '${_formatNumber(spot.y.toInt())} ${budget.currency}\n'
                            '${date.day}/${date.month}/${date.year}',
                        TextStyle(color: Colors.white, fontSize: responsiveFontSize),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildRemainingBudgetChart(BuildContext context, double responsiveFontSize, double responsivePadding) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.all(responsivePadding),
        child: Text(
          'This chart shows the remaining budget over time, with colors indicating different budget levels.',
          style: TextStyle(fontSize: responsiveFontSize),
        ),
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsets.all(responsivePadding),
          child: BarChart(
            BarChartData(
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) {
                      final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "${date.day}/${date.month}",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: responsiveFontSize,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          _formatNumber(value.toInt()),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: responsiveFontSize,
                          ),
                        ),
                      );
                    },
                  ),
                  axisNameWidget: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      budget.currency,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: responsiveFontSize,
                      ),
                    ),
                  ),
                  axisNameSize: responsiveFontSize,
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.5),
                    strokeWidth: 1,
                  );
                },
                drawHorizontalLine: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.5),
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              barGroups: _getRemainingBudgetBarGroups(),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildTransactionsChart(BuildContext context, double responsiveFontSize, double responsivePadding) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.all(responsivePadding),
        child: Text(
          'This chart shows the transactions over time, with each bar representing a transaction amount.',
          style: TextStyle(fontSize: responsiveFontSize),
        ),
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsets.all(responsivePadding),
          child: BarChart(
            BarChartData(
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) {
                      final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "${date.day}/${date.month}",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: responsiveFontSize,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          _formatNumber(value.toInt()),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: responsiveFontSize,
                          ),
                        ),
                      );
                    },
                  ),
                  axisNameWidget: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      budget.currency,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: responsiveFontSize,
                      ),
                    ),
                  ),
                  axisNameSize: responsiveFontSize,
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.5),
                    strokeWidth: 1,
                  );
                },
                drawHorizontalLine: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.5),
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              barGroups: _getTransactionsBarGroups(),
            ),
          ),
        ),
      ),
    ],
  );
}
Color _getBarColor(double amount, double totalBudget) {
  if (amount > totalBudget * 0.5) {
    return Colors.green;
  } else if (amount > totalBudget * 0.25) {
    return Colors.yellow;
  } else {
    return Colors.red;
  }
}

List<BarChartGroupData> _getRemainingBudgetBarGroups() {
  List<BarChartGroupData> barGroups = [];
  List<FlSpot> remainingBudgetData = _getRemainingBudgetData();

  for (var spot in remainingBudgetData) {
    barGroups.add(BarChartGroupData(
      x: spot.x.toInt(),
      barRods: [
        BarChartRodData(
          toY: spot.y,
          color: _getBarColor(spot.y, budget.totalAmount),

        ),
      ],
    ));
  }

  return barGroups;
}

  List<BarChartGroupData> _getTransactionsBarGroups() {
    List<BarChartGroupData> barGroups = [];

    for (var transaction in budget.transactions) {
      barGroups.add(BarChartGroupData(
        x: transaction.date.millisecondsSinceEpoch.toInt(),
        barRods: [
          BarChartRodData(
            toY: transaction.amount,
            color: Colors.red,
          ),
        ],
      ));
    }

    return barGroups;
  }

  LineChartBarData _buildLineChartBarData(List<FlSpot> spots, Color color, String label) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.2),
      ),
      dotData: const FlDotData(show: true),
    );
  }

  List<FlSpot> _getInitialBudgetData() {
    if (budget.transactions.isEmpty) {
      return [
        FlSpot(DateTime.now().millisecondsSinceEpoch.toDouble(), budget.totalAmount),
      ];
    }
    return [
      FlSpot(budget.transactions.first.date.millisecondsSinceEpoch.toDouble(), budget.totalAmount),
      FlSpot(DateTime.now().millisecondsSinceEpoch.toDouble(), budget.totalAmount),
    ];
  }

  List<FlSpot> _getUsedBudgetData() {
    List<FlSpot> spots = [];
    double remaining = budget.totalAmount;

    for (var transaction in budget.transactions) {
      remaining -= transaction.amount;
      spots.add(FlSpot(transaction.date.millisecondsSinceEpoch.toDouble(), remaining));
    }

    return spots;
  }

  List<FlSpot> _getAddedBudgetData() {
    List<FlSpot> spots = [];

    for (var version in budget.versions) {
      spots.add(FlSpot(version.date.millisecondsSinceEpoch.toDouble(), version.amount));
    }

    return spots;
  }

  List<FlSpot> _getRemainingBudgetData() {
    List<FlSpot> spots = [];
    double remaining = budget.totalAmount;

    // Initial spot with the full budget
    spots.add(FlSpot(budget.transactions.first.date.millisecondsSinceEpoch.toDouble(), remaining));

    // Subtract amounts from transactions and add budget versions
    for (var transaction in budget.transactions) {
      remaining -= transaction.amount;
      spots.add(FlSpot(transaction.date.millisecondsSinceEpoch.toDouble(), remaining));
    }

    for (var version in budget.versions) {
      remaining += version.amount;
      spots.add(FlSpot(version.date.millisecondsSinceEpoch.toDouble(), remaining));
    }

    return spots;
  }

  String _formatNumber(int number) {
    if (number >= 1000 && number < 1000000) {
      return '${(number / 1000).toStringAsFixed(0)}k';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(0)}M';
    }
    return number.toString();
  }
}