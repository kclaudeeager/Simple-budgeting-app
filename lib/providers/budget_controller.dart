import 'package:get/get.dart';
import '../models/transaction.dart';
import '../models/budget.dart';

class BudgetController extends GetxController {
  final RxList<Budget> budgets = <Budget>[].obs;

  void addNewBudget(String name, double amount) {
    budgets.add(Budget(name: name, totalAmount: amount));
  }

  bool addNewTransaction(Transaction transaction) {
    if (budgets.isEmpty) return false;

    bool isAdded = false;

    Budget? budget = budgets.firstWhere(
          (b) => b.name == transaction.category,
      orElse: () => Budget(name: '', totalAmount: 0),
    );

    if (budget.name.isNotEmpty) {
     isAdded= budget.spend(transaction);
      budgets.refresh(); // Notify GetX about the changes
    }
    return isAdded;
  }

  Budget getBudget(String name) {
    return budgets.firstWhere((b) => b.name == name);
  }
}
