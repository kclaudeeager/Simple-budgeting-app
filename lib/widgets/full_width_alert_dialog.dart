import 'package:flutter/material.dart';

class FullWidthAlertDialog extends StatelessWidget {
  final Widget content;

  const FullWidthAlertDialog({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width, // Full width
          maxHeight: MediaQuery.of(context).size.height * 0.9, // Max height, if content is very tall
        ),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0), // Padding inside the dialog
                  child: content,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showFullWidthDialog(BuildContext context, Widget content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return FullWidthAlertDialog(content: content);
    },
  );
}
