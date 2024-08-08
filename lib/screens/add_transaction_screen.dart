import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../providers/budget_controller.dart';

class AddTransactionScreen extends StatefulWidget {
  final Function(String, String, double) addTransaction;

  const AddTransactionScreen({super.key, required this.addTransaction});

  @override
  AddTransactionScreenState createState() => AddTransactionScreenState();
}

class AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _productOrServiceController = TextEditingController();
  String? _selectedBudget;

  void _submitData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final enteredProductOrService = _productOrServiceController.text;

    if (_selectedBudget == null || enteredAmount == null || enteredAmount <= 0 || enteredProductOrService.isEmpty) {
      Get.snackbar('Invalid Input', 'Please ensure all fields are filled and valid.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final budgetController = Get.find<BudgetController>();
    final selectedBudget = budgetController.getBudget(_selectedBudget!);

    if (selectedBudget.isDepleted()) {
      _showFundBudgetBottomSheet(context, selectedBudget, enteredProductOrService, enteredAmount);
    } else {
      bool didWork = widget.addTransaction(_selectedBudget!, enteredProductOrService, enteredAmount);
      if (!didWork) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Transaction could not be added'),
            duration: const Duration(seconds: 20),
            action: SnackBarAction(
                label: 'Fund Budget',
                onPressed: () => _showFundBudgetBottomSheet(context, selectedBudget, enteredProductOrService, enteredAmount)
            ),
          ),
        );
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction added successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
      }

    }
  }

  void _showFundBudgetBottomSheet(BuildContext context, budget, String productOrService, double amount) {
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
              const Text('Please fund the budget to proceed.',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
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
                    widget.addTransaction(budget.name, productOrService, amount); // Add the transaction after funding
                    Navigator.of(ctx).pop(); // Close the bottom sheet
                    Navigator.of(context).pop(); // Close the AddTransactionScreen
                  } else {
                    Get.snackbar('Invalid Input', 'Please enter a valid amount to fund the budget.',
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
                child: const Text('Fund Budget and Add Transaction'),
              ),
            ],
          )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    BudgetController budgetController = Get.find<BudgetController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(labelText: 'Product or Service'),
              controller: _productOrServiceController,
            ),
            Obx(() => DropdownButton<String>(
              hint: const Text('Select Budget'),
              value: _selectedBudget,
              items: budgetController.budgets.map((budget) {
                return DropdownMenuItem<String>(
                  value: budget.name,
                  child: Text(budget.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBudget = value!;
                });
              },
            )),
            TextField(
              decoration: const InputDecoration(labelText: 'Amount'),
              controller: _amountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitData,
              child: const Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
