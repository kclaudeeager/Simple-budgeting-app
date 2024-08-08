import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/budget.dart';
import '../models/transaction.dart';
import '../providers/budget_controller.dart';

class BudgetDetailsScreen extends StatelessWidget {
  final Budget budget;


  const BudgetDetailsScreen({super.key, required this.budget});

  bool _addNewTransaction(String productOrService, double amount) {
    return Get.find<BudgetController>().addNewTransaction(Transaction(
      productOrService: productOrService,
      amount: amount,
      category: budget.name,  // Use the budget name as the category
      date: DateTime.now(),
    ));
  }

  void _showAddTransactionBottomSheet(BuildContext context, Function(bool didWork) callback) {
    final TextEditingController productController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom, // Adjust the padding based on the keyboard height
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: productController,
                decoration: const InputDecoration(labelText: 'Product/Service'),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final String product = productController.text;
                  final double? amount = double.tryParse(amountController.text);
                  if (amount != null && product.isNotEmpty) {
                  bool isAdded = _addNewTransaction(product, amount);
                  callback(isAdded);
                    Navigator.of(ctx).pop();
                  // Close the bottom sheet
                  }
                  else {
                    // Handle invalid input
                    Get.snackbar('Error', 'Please enter valid product/service and amount',
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
                child: const Text('Add Transaction'),
              ),
            ],
          )
        ),
        );
      },
    );
  }

  void _fundBudget(BuildContext context,Function () callback) {
    final TextEditingController fundController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom, // Adjust the padding based on the keyboard height
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: fundController,
                decoration: const InputDecoration(labelText: 'Amount to Fund'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final double? fundAmount = double.tryParse(fundController.text);
                  if (fundAmount != null && fundAmount > 0) {
                    budget.fund(fundAmount); // Fund the budget
                    Navigator.of(ctx).pop();
                    callback();
                  } else {
                    // Handle invalid input
                    Get.snackbar('Error', 'Please enter a valid fund amount',
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
                child: const Text('Fund Budget'),
              ),
            ],
          )
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final budgetController = Get.find<BudgetController>();
    final budgetToUse = budgetController.getBudget(budget.name);

    return Scaffold(
      appBar: AppBar(
        title: Text(budgetToUse.name),
      ),
      floatingActionButton:Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
        FloatingActionButton(
        heroTag: 'FundBudget',
        child: const Icon(Icons.attach_money),
        onPressed: () => _fundBudget(context, () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Budget funded successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
        ),
      ),
      const SizedBox(height: 10),
      FloatingActionButton(
        heroTag: 'addTransaction',
        onPressed: () => _showAddTransactionBottomSheet(context, (didWork) {
         debugPrint('didWork: $didWork');
          if(didWork){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Transaction added successfully'),
                duration: Duration(seconds: 2),
              ),
            );
          }
          else{
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Transaction could not be added'),
                duration: const Duration(seconds: 20),
                action: SnackBarAction(
                  label: 'Fund Budget',
                  onPressed: () => _fundBudget(context, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Budget funded successfully, You can now add transaction'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                )),
              ),
            );
          }

        }),
        child: const Icon(Icons.add),
      ),
],),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            final transactions = budgetToUse.getTransactions();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Access the value of RxDouble using `.value`
                Text('Total budget value Amount: ${budgetToUse.totalAmount.toStringAsFixed(2)} ${budget.currency}'),
                const SizedBox(height: 20),
                // show the budget versions
                const Text('Budget Versions:', style: TextStyle(fontWeight: FontWeight.bold)),
                ConstrainedBox(constraints: const BoxConstraints(maxHeight: 200), child: ListView.builder(
                  itemCount: budgetToUse.versions.length,
                  itemBuilder: (ctx, index) {
                    final version = budgetToUse.versions[index];
                    return Card(
                      child: ListTile(
                        title: Text('Version ${index + 1}'),
                        subtitle: Text('Amount: ${version.amount.toStringAsFixed(2)} ${budget.currency}'),
                      ),
                    );
                  },
                )),
                Text('Remaining: ${budgetToUse.getRemaining().toStringAsFixed(2)} ${budget.currency}'),
                const SizedBox(height: 20),
                if (budgetToUse.isDepleted()) ...[
                  const Text('Warning: Budget is depleted! Please fund the budget.',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: () => _fundBudget(context, () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Budget funded successfully'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }),
                    child: const Text('Fund Budget'),
                  ),
                ],
                if (transactions.isEmpty) ...[
                  const Text('No transactions yet'),
                ] else ...[
                  const Text('Transactions:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (ctx, index) {
                        final tx = transactions[index];
                        return Card(
                          child: ListTile(
                            title: Text(tx.productOrService ?? ''),
                            subtitle: Text('Amount: ${tx.amount.toStringAsFixed(2)} ${budget.currency}'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            );
          }),
      ),
    );
  }
}
