import 'package:get/get.dart';

class FeedbackController extends GetxController {
  var selectedSentiment = (-1).obs;
  var feedbackText = ''.obs;
  var rating = 0.0.obs;
  var selectedImprovements = <String>[].obs;

  void updateFeedbackText(String text) {
    feedbackText.value = text;
  }

  void updateRating(double newRating) {
    rating.value = newRating;
  }

  void toggleImprovement(String improvement) {
    if (selectedImprovements.contains(improvement)) {
      selectedImprovements.remove(improvement);
    } else {
      selectedImprovements.add(improvement);
    }
  }

  void selectSentiment(int index) {
    selectedSentiment.value = index;
  }

  // reset everything
  void resetFeedback() {
    selectedSentiment.value = -1;
    feedbackText.value = '';
    rating.value = 0.0;
    selectedImprovements.clear();
  }
}