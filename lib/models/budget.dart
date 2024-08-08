import 'package:get/get.dart';
import 'transaction.dart';

class Budget {
  String name;
  double totalAmount;
  String currency = 'RWF';
  RxDouble remainingAmount;
  List<Transaction> transactions = [];
  List<BudgetVersion> versions = []; // To track versions of the budget
  final RxBool didSpendingWork = true.obs;
  Budget({
    required this.name,
    required this.totalAmount,
  })  : remainingAmount = totalAmount.obs;

  bool spend(Transaction transaction) {
    if (transaction.amount > remainingAmount.value) {
      didSpendingWork.value = false;
      return false;
    }
    transactions.add(transaction);
    remainingAmount.value -= transaction.amount;
    return true;
  }

  bool isDepleted() {
    return remainingAmount.value <= 0;
  }

  void fund(double amount) {
    remainingAmount.value += amount;
    // Store a new version when funding occurs
    versions.add(BudgetVersion(amount: amount, date: DateTime.now()));
  }

  List<Transaction> getTransactions() {
    return transactions;
  }

  double getRemaining() {
    return remainingAmount.value;
  }
}


class BudgetVersion {
  double amount;
  DateTime date;

  BudgetVersion({
    required this.amount,
    required this.date,
  });
}
