import 'dart:io';
import 'lib/services/classifier.dart';

void main() async {
  print('=== Testing Boat Classifier ===');

  final classifier = BoatClassifier();

  // Test model loading
  print('Loading model...');
  final loaded = await classifier.loadModel();
  print('Model loaded: $loaded');
  print('Is loaded: ${classifier.isLoaded}');

  // Test multiple classifications
  print('\n=== Testing Multiple Classifications ===');
  for (int i = 0; i < 5; i++) {
    print('\n--- Test ${i + 1} ---');

    // Create a dummy file to trigger classification
    final result = await classifier.classifyImage(File('dummy.jpg'));

    if (result != null) {
      print(
        'Top prediction: ${result.boatType} (${result.confidence.toStringAsFixed(1)}%)',
      );
      print('Top 3 scores:');
      for (int j = 0; j < 3 && j < result.scores.length; j++) {
        print(
          '  ${j + 1}. ${result.scores[j].label}: ${result.scores[j].confidence.toStringAsFixed(1)}%',
        );
      }
    } else {
      print('Classification failed');
    }

    // Small delay to ensure different timestamps
    await Future.delayed(Duration(milliseconds: 100));
  }

  classifier.dispose();
  print('\n=== Test Complete ===');
}
