import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/transaction.dart';
import '../providers/budget_controller.dart';
import '../widgets/budget_card.dart';
import 'add_budget_screen.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  BudgetController budgetController = Get.put(BudgetController());

  void _addNewBudget(String name, double amount) {
    budgetController.addNewBudget(name, amount);
  }

  bool _addNewTransaction(String category, String productOrService, double amount) {
    return budgetController.addNewTransaction(Transaction(category: category, productOrService: productOrService, amount: amount, date: DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgeting App'),
      ),
      body: Obx(() => ListView.builder(
        itemCount: budgetController.budgets.length,
        itemBuilder: (ctx, index) {
          return BudgetCard(budget: budgetController.budgets[index]);
        },
      )),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'addBudget',
            child: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddBudgetScreen(addBudget: _addNewBudget),
              ),
            ),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'addTransaction',
            child: const Icon(Icons.attach_money),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddTransactionScreen(
                    addTransaction: _addNewTransaction
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
