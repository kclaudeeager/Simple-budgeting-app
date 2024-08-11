import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/budget.dart';
import '../providers/budget_controller.dart';
import '../widgets/budget_usage_chart.dart';

class BudgetOverviewScreen extends StatelessWidget {
  final BudgetController budgetController = Get.find();

   BudgetOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Overview'),
      ),
      body: Obx(() {
        if (budgetController.budgets.isEmpty) {
          return const Center(child: Text('No budget data available.'));
        }

        // Assuming you want to show the chart for the first budget in the list
        Budget budget = budgetController.budgets.first;

        return BudgetUsageChart(budget: budget);
      }),
    );
  }
}
