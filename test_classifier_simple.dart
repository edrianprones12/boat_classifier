import 'dart:io';
import 'dart:math' as math;

void main() {
  print('=== Testing Randomization Logic ===');

  final labels = [
    'bamboo raft',
    'cargo boat',
    'ferry boat',
    'fishing boat',
    'jet ski',
    'kayak',
    'sail boat',
    'speed boat',
    'tourist boat',
    'yacht',
  ];

  // Test multiple generations with different seeds
  for (int test = 0; test < 5; test++) {
    print('\n--- Test ${test + 1} ---');

    // Use different seed each time
    final seed = DateTime.now().millisecondsSinceEpoch + test * 1000;
    final random = math.Random(seed);
    print('Seed: $seed');

    final scores = <String, double>{};
    double totalConfidence = 0.0;
    final rawScores = <double>[];

    // Generate random scores
    for (int i = 0; i < labels.length; i++) {
      final score = random.nextDouble() * 100.0;
      rawScores.add(score);
      totalConfidence += score;
    }

    // Normalize to percentages
    for (int i = 0; i < labels.length; i++) {
      final normalizedScore = (rawScores[i] / totalConfidence) * 100.0;
      final confidence = normalizedScore.clamp(1.0, 95.0);
      scores[labels[i]] = confidence;
    }

    // Sort by confidence
    final sortedScores = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    print(
      'Top prediction: ${sortedScores.first.key} (${sortedScores.first.value.toStringAsFixed(1)}%)',
    );
    print('Top 3:');
    for (int i = 0; i < 3; i++) {
      print(
        '  ${i + 1}. ${sortedScores[i].key}: ${sortedScores[i].value.toStringAsFixed(1)}%',
      );
    }

    // Add delay to ensure different timestamps
    sleep(Duration(milliseconds: 100));
  }

  print('\n=== Test Complete ===');
}
