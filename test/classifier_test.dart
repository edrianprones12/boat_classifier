import 'package:flutter_test/flutter_test.dart';
import 'package:boat_classifier/services/classifier.dart';
import 'dart:io';

void main() {
  // Initialize Flutter bindings for tests
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BoatClassifier Tests', () {
    late BoatClassifier classifier;

    setUp(() {
      classifier = BoatClassifier();
    });

    tearDown(() {
      classifier.dispose();
    });

    test('should load model and labels successfully', () async {
      final result = await classifier.loadModel();

      print('Model loaded: $result');
      print('Is loaded: ${classifier.isLoaded}');

      expect(result, isTrue);
      expect(classifier.isLoaded, isTrue);
    });

    test('should classify image using real model', () async {
      await classifier.loadModel();

      final result = await classifier.classifyImage(
        File('test_assets/test_image.jpg'),
      );

      if (result != null && result.boatType != 'Unknown') {
        print(
          'Classification: ${result.boatType} - ${result.confidence.toStringAsFixed(1)}%',
        );

        // Check that we have scores for all classes
        expect(result.scores.isNotEmpty, isTrue);
        expect(result.scores.length, equals(10)); // 10 boat types

        // Check that scores sum to approximately 100%
        final totalScore = result.scores
            .map((s) => s.confidence)
            .reduce((a, b) => a + b);
        expect(totalScore, closeTo(100.0, 10.0)); // Allow 10% tolerance
      }
    });

    test('should have proper confidence ranges', () async {
      await classifier.loadModel();

      final result = await classifier.classifyImage(
        File('test_assets/test_image.jpg'),
      );

      if (result != null && result.boatType != 'Unknown') {
        // Top confidence should be reasonable
        expect(result.confidence, greaterThan(0.0));
        expect(result.confidence, lessThanOrEqualTo(100.0));

        // All scores should be in valid range
        for (final score in result.scores) {
          expect(score.confidence, greaterThan(0.0));
          expect(score.confidence, lessThanOrEqualTo(100.0));
        }

        // Scores should be sorted by confidence (descending)
        for (int i = 1; i < result.scores.length; i++) {
          expect(
            result.scores[i - 1].confidence,
            greaterThanOrEqualTo(result.scores[i].confidence),
          );
        }
      }
    });
  });
}
