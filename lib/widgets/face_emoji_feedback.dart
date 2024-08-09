import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/emoji_feed.dart';
import '../providers/feedback_controller.dart';

class FaceEmojiFeedback extends StatelessWidget {
  final String feedback;
  final FeedbackController feedbackController = Get.put(FeedbackController());
  final VoidCallback onFeedbackSubmitted;

  final List<EmojiFeed> emojis = [
    EmojiFeed(emoji: Icons.sentiment_dissatisfied, name: "Dissatisfied"),
    EmojiFeed(emoji: Icons.sentiment_neutral, name: "Neutral"),
    EmojiFeed(emoji: Icons.sentiment_satisfied, name: "Satisfied"),
  ];


  FaceEmojiFeedback({super.key, required this.feedback, required this.onFeedbackSubmitted});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Rate us",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                feedback,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(emojis.length, (index) {
                  return GestureDetector(
                    onTap: () => feedbackController.selectSentiment(index),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: feedbackController.selectedSentiment.value == index
                                ? Colors.amber
                                : Colors.grey[300],
                            shape: BoxShape.circle,
                            boxShadow: feedbackController.selectedSentiment.value == index
                                ? [BoxShadow(color: Colors.amber.withOpacity(0.5), blurRadius: 8, spreadRadius: 2)]
                                : [],
                          ),
                          child: Icon(
                            emojis[index].emoji,
                            color: feedbackController.selectedSentiment.value == index ? Colors.white : Colors.black,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          emojis[index].name,
                          style: TextStyle(
                            fontSize: 12,
                            color: feedbackController.selectedSentiment.value == index ? Colors.amber : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }),
              )),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Handle the submission of feedback
                  debugPrint('Feedback: ${feedbackController.selectedSentiment.value}');
                  onFeedbackSubmitted();
                  feedbackController.resetFeedback();
                  Get.snackbar(
                    'Thank you!',
                    'Your feedback has been submitted.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.greenAccent,
                    colorText: Colors.black,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Submit Feedback'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
