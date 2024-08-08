class Transaction {
  String category;
  double amount;
  String? productOrService;
  DateTime date;
  bool isPlanned;

  Transaction({
    required this.category,
    required this.amount,
    required this.date,
    this.productOrService,
    this.isPlanned = true,
  });
}
