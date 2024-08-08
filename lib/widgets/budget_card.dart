import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/budget.dart';
import '../screens/budget_details_screen.dart';

class BudgetCard extends StatelessWidget {
  final Budget budget;

  const BudgetCard({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(budget.name),
        subtitle: Obx(() => Text('Remaining: ${budget.remainingAmount.value.toStringAsFixed(2)} ${budget.currency}')),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BudgetDetailsScreen(budget: budget),
            ),
          );
        },
      ),
    );
  }
}
