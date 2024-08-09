import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../providers/feedback_controller.dart';


class FeedbackScreen extends StatelessWidget {
  final FeedbackController feedbackController = Get.put(FeedbackController());
  final _formKey = GlobalKey<FormState>();
  final List<String> _elementsToImprovement = ['UI/UX', 'Performance', 'Features', 'Others'];

  FeedbackScreen({super.key});

  void _submitFeedback(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      debugPrint('Rating: ${feedbackController.rating.value}');
      debugPrint('Feedback: ${feedbackController.feedbackText.value}');
      debugPrint('Improvements: ${feedbackController.selectedImprovements}');

      // Here, you can either store the feedback locally or send it to a backend server
      await _storeFeedbackLocally();
      // or
      // await _sendFeedbackToServer();

      // Display a success message or dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you for your feedback!', style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.greenAccent,
        ),
      );
      // Close the feedback screen
      Navigator.of(context).pop();
      feedbackController.resetFeedback();
    }
  }

  Future<void> _storeFeedbackLocally() async {
    // Code to store the feedback in a local database or shared preferences
  }

  Future<void> _sendFeedbackToServer() async {
    // Code to send the feedback to a backend server
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rate Your Experience:'),
                  const SizedBox(height: 8.0),
                  Obx(() => RatingBar.builder(
                    initialRating: feedbackController.rating.value,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      feedbackController.updateRating(rating);
                    },
                  )),
                  const SizedBox(height: 16.0),
                  const Text("Tell us what you'd like to see improved:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0),
                  Obx(() => Wrap(
                    spacing: 8.0,
                    children: _elementsToImprovement.map((element) {
                      return ChoiceChip(
                        label: Text(element),
                        selected: feedbackController.selectedImprovements.contains(element),
                        onSelected: (selected) {
                          feedbackController.toggleImprovement(element);
                        },
                        selectedColor: Colors.blue,
                      );
                    }).toList(),
                  )),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Share your feedback',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      // Count the number of words to be not greater than 100
                      if (value!.split(' ').length > 100) {
                        return 'Feedback should not exceed 100 words';
                      }
                      //
                      // if (value.isEmpty) {
                      //   return 'Please enter your feedback';
                      // }
                      return null;
                    },
                    onSaved: (value) {
                      feedbackController.updateFeedbackText(value!);
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () => _submitFeedback(context),
                    child: const Text('Submit Feedback'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}