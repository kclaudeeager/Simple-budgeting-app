import 'package:flutter/material.dart';

class AddBudgetScreen extends StatefulWidget {
  final Function(String, double) addBudget;

  const AddBudgetScreen({super.key, required this.addBudget});

  @override
  AddBudgetScreenState createState() => AddBudgetScreenState();
}

class AddBudgetScreenState extends State<AddBudgetScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  void _submitData() {
    final enteredName = _nameController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredName.isEmpty || enteredAmount <= 0) {
      return;
    }

    widget.addBudget(enteredName, enteredAmount);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Budget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(labelText: 'Budget Name'),
              controller: _nameController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Total Amount'),
              controller: _amountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitData,
              child: const Text('Add Budget'),
            ),
          ],
        ),
      ),
    );
  }
}
