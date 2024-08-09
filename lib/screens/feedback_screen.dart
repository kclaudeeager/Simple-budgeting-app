import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  String _feedbackText = '';
  double _rating = 0.0;
  final List<String> _elementsToImprovement = ['UI/UX', 'Performance', 'Features', 'Others'];
  final List<String> _selectedImprovements = [];

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      debugPrint('Rating: $_rating');
      debugPrint('Feedback: $_feedbackText');
      debugPrint('Improvements: $_selectedImprovements');

      // Here, you can either store the feedback locally or send it to a backend server
      await _storeFeedbackLocally();
      // or
      // await _sendFeedbackToServer();

      // Display a success message or dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you for your feedback!'),
        ),
      );

      // Close the feedback screen
      Navigator.of(context).pop();
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
                  RatingBar.builder(
                    initialRating: _rating,
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
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const Text("Tell us what you'd like to see improved:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0),
                 Wrap(
                spacing: 8.0,
                children: _elementsToImprovement.map((element) {
                  return ChoiceChip(
                    label: Text(element),
                    selected: _selectedImprovements.contains(element),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedImprovements.add(element);
                        } else {
                          _selectedImprovements.remove(element);
                        }
                      });
                    },
                    selectedColor: Colors.blue,
                  );
                }).toList(),
              ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Share your feedback',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your feedback';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _feedbackText = value!;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _submitFeedback,
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