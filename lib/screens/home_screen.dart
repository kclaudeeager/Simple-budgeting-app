import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/transaction.dart';
import '../providers/budget_controller.dart';
import '../widgets/budget_card.dart';
import '../widgets/face_emoji_feedback.dart';
import '../widgets/full_width_alert_dialog.dart';
import 'add_budget_screen.dart';
import 'add_transaction_screen.dart';
import 'budget_overview_screen.dart';
import 'feedback_screen.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  BudgetController budgetController = Get.put(BudgetController());
  Timer? _feedbackTimer;
  bool _feedbackShown = false;

  @override
  void initState() {
    super.initState();
    _startFeedbackTimer();
  }

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    super.dispose();
  }


void _startFeedbackTimer() {
  debugPrint('Feedback timer started');
  _feedbackTimer = Timer(Duration(seconds: _getRandomTime()), _showRandomFeedback);
  debugPrint('Feedback timer set to ${_feedbackTimer?.tick}');
}

void _showRandomFeedback() {
  final random = Random();
  if (random.nextBool()) {
    _showFeedbackPage();
  } else {
    _showFeedbackAlert();
  }
}


  int _getRandomTime() {
    return 5 + (5 * (DateTime.now().millisecondsSinceEpoch % 6)); // Random between 5 to 30 minutes
  }


  void _showFeedbackPage() {
  debugPrint('Feedback timer triggered');
  if (!_feedbackShown) {
    _feedbackShown = true;
    Get.to(() =>  FeedbackScreen(onFeedbackSubmitted: (){
      Navigator.of(context).pop();
      _resetFeedbackTimer();
    },), fullscreenDialog: true)!.then((_) {
      _resetFeedbackTimer();
    });
  }

}
  void _showFeedbackAlert() {
    const String feedback = 'How is your experience with the app so far?';
    if (!_feedbackShown) {
      _feedbackShown = true;
      showFullWidthDialog(
        context,
        FaceEmojiFeedback(
          feedback: feedback,
          onFeedbackSubmitted: () {
            Navigator.of(context).pop();
            _resetFeedbackTimer();
          },
        ),
      );
    }
  }


  void _resetFeedbackTimer() {
  _feedbackShown = false;
  _startFeedbackTimer();
}

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
          // display budget overview screen
          FloatingActionButton(
            heroTag: 'budgetOverview',
            child: const Icon(Icons.pie_chart),
            onPressed: () => Get.to(() => BudgetOverviewScreen()),
            ),
        ],
      ),
    );
  }
}