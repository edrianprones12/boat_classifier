import 'dart:io';
import 'package:flutter/material.dart';
import '../services/classifier.dart';
import '../widgets/custom_button.dart';

class ResultScreen extends StatelessWidget {
  final ClassificationResult result;
  final File imageFile;

  const ResultScreen({
    super.key,
    required this.result,
    required this.imageFile,
  });

  String _getBoatDescription(String boatType) {
    switch (boatType.toLowerCase()) {
      case 'bamboo raft':
        return 'A traditional watercraft constructed from multiple bamboo poles lashed together with rope or vines. Features a flat, rectangular platform with a simple, open design. Typically 3-6 meters in length, these rafts have a shallow draft allowing navigation in very shallow waters. The bamboo construction provides natural buoyancy and flexibility. Commonly found in Southeast Asia, these rafts are used for short-distance transportation across rivers, fishing in shallow waters, and transporting goods to markets. They are lightweight, eco-friendly, and can be easily constructed from locally available materials.';
      case 'cargo boat':
        return 'A large commercial vessel designed specifically for transporting goods and merchandise across waterways. Characterized by a wide, boxy hull with a flat deck for cargo storage, these boats typically range from 20-100 meters in length. Features include large cargo holds, cranes or loading equipment, and a high freeboard for stability. The hull is usually made of steel or reinforced materials to withstand heavy loads. Essential for international trade, these vessels transport containers, bulk goods, and raw materials between ports. They operate on major shipping routes and are equipped with navigation systems for long-distance travel.';
      case 'ferry boat':
        return 'A passenger vessel designed to transport people and vehicles across bodies of water on regular scheduled routes. Features a wide, stable hull with multiple decks - lower deck for vehicles and upper deck for passengers. Typically 30-150 meters in length with a capacity for 50-500 passengers and numerous vehicles. Equipped with ramps for vehicle loading, seating areas, restrooms, and sometimes food service. The design prioritizes stability and safety for frequent crossings. Commonly operates on fixed routes between islands, across rivers, or connecting coastal areas. Used for daily commutes, tourism, and connecting communities separated by water.';
      case 'fishing boat':
        return 'A specialized vessel equipped with fishing equipment and storage facilities for commercial or recreational fishing. Features include fishing nets, rod holders, fish storage holds, and sometimes processing equipment. Typically 5-30 meters in length with a sturdy hull designed for various sea conditions. May have outriggers for stability, a raised bow for rough waters, and a flat working deck. Commercial versions often include refrigeration, fish finders, and navigation equipment. The design varies based on fishing method - trawling, longlining, or net fishing. Used by professional fishermen and recreational anglers for catching fish, with storage capacity for preserving the catch during extended trips.';
      case 'jet ski':
        return 'A small personal watercraft (PWC) powered by a jet propulsion system, typically 2-4 meters in length. Features a sleek, streamlined design with a narrow hull and handlebars for steering. The rider sits or stands on the craft, which can reach speeds of 50-70 mph. Characterized by its compact size, maneuverability, and high-speed capabilities. Made from fiberglass or composite materials for lightweight construction. Equipped with a powerful engine that draws water and expels it through a nozzle for propulsion. Popular for recreation, water sports, racing, and quick personal transportation on lakes, rivers, and coastal waters. Requires skill to operate safely.';
      case 'kayak':
        return 'A narrow, lightweight watercraft propelled by a double-bladed paddle, typically 2-5 meters in length. Features a closed or open cockpit design with the paddler sitting low inside the hull. The sleek, pointed bow and stern allow for efficient movement through water. Made from materials like fiberglass, plastic, or inflatable fabric. Sea kayaks are longer and more stable, while whitewater kayaks are shorter and more maneuverable. The design allows for quiet, efficient paddling with minimal water resistance. Popular for recreation, touring, fishing, whitewater sports, and exercise. Requires balance and paddling technique. Can be used solo or in tandem versions.';
      case 'sail boat':
        return 'A boat propelled primarily by wind power through sails mounted on one or more masts. Features a streamlined hull designed to minimize water resistance, with a keel or centerboard for stability. Typically 5-50 meters in length, with sail configurations varying from single-mast sloops to multi-mast schooners. The hull may be made of fiberglass, wood, or composite materials. Equipped with rigging, winches, and sailing hardware for controlling the sails. The design allows for silent, eco-friendly propulsion using wind energy. Used for recreation, racing, cruising, and traditional transportation. Requires knowledge of sailing techniques, wind patterns, and navigation. Offers a unique connection with nature and the elements.';
      case 'speed boat':
        return 'A high-performance motorboat designed for speed and agility, typically 5-15 meters in length. Features a sleek, aerodynamic hull with a pointed bow and powerful engine(s) capable of reaching 60-100+ mph. Characterized by its low profile, streamlined design, and often includes features like racing seats, safety harnesses, and performance instrumentation. The hull design may include deep-V shapes for rough water handling or flat bottoms for speed in calm conditions. Made from lightweight materials like fiberglass or carbon fiber. Equipped with powerful outboard or inboard engines. Used for racing, recreation, water sports, quick transportation, and entertainment. Requires skill and safety equipment for operation.';
      case 'tourist boat':
        return 'A vessel specifically designed for sightseeing and tourism, typically 10-50 meters in length. Features open decks for passenger viewing, comfortable seating, and often includes amenities like restrooms, snack bars, and shaded areas. The design prioritizes passenger comfort and visibility with large windows or open-air configurations. May have multiple levels for different viewing experiences. Equipped with audio systems for guided tours and safety equipment for passenger capacity. The hull is stable and designed for smooth rides in various water conditions. Used for scenic tours, wildlife viewing, historical site visits, and entertainment cruises. Operates on scheduled routes showcasing local attractions, landmarks, and natural beauty.';
      case 'yacht':
        return 'A luxury recreational vessel, typically 12-100+ meters in length, characterized by elegant design and premium amenities. Features include spacious cabins, dining areas, lounges, and often luxury facilities like hot tubs, gyms, and entertainment systems. The hull design is sleek and sophisticated, made from high-quality materials like fiberglass, aluminum, or composite. Equipped with powerful engines for cruising, advanced navigation systems, and sometimes sailing capabilities. The interior is lavishly appointed with fine finishes, modern technology, and comfortable furnishings. Used for leisure, entertainment, private cruising, corporate events, and luxury travel. Represents a symbol of wealth and lifestyle. Can accommodate guests and crew for extended voyages.';
      default:
        return 'A watercraft used for various purposes on water, designed to navigate rivers, lakes, and oceans for transportation, recreation, or commercial activities.';
    }
  }

  String _getTypicalUsage(String boatType) {
    switch (boatType.toLowerCase()) {
      case 'bamboo raft':
        return 'Transportation, Fishing, Traditional Use';
      case 'cargo boat':
        return 'Commercial Transport, Trade, Logistics';
      case 'ferry boat':
        return 'Passenger Transport, Vehicle Transport, Public Transit';
      case 'fishing boat':
        return 'Commercial Fishing, Recreational Fishing';
      case 'jet ski':
        return 'Recreation, Water Sports, Personal Transport';
      case 'kayak':
        return 'Recreation, Touring, Whitewater Sports, Exercise';
      case 'sail boat':
        return 'Recreation, Racing, Sailing, Traditional Transport';
      case 'speed boat':
        return 'Racing, Recreation, Water Sports, Quick Transport';
      case 'tourist boat':
        return 'Sightseeing, Tourism, Passenger Tours';
      case 'yacht':
        return 'Luxury Cruising, Entertainment, Leisure, Private Use';
      default:
        return 'Various water activities';
    }
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 95) return Colors.green;
    if (confidence >= 80) return Colors.orange;
    return Colors.red;
  }

  String _getAccuracyRating(double confidence) {
    if (confidence >= 95) return 'Excellent';
    if (confidence >= 85) return 'Very Good';
    if (confidence >= 70) return 'Good';
    if (confidence >= 60) return 'Fair';
    return 'Low';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Image.asset('assets/boat_logo.png', fit: BoxFit.contain),
        ),
        title: const Text(
          'Image Analysis Results',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 18,
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 2,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title + main image card (matches sketch "Title" + large area)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.boatType,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 220,
                        color: Colors.grey[300],
                        child: Image.file(imageFile, fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
              ),
              // Results row + full class distribution
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Results',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _MetricCard(
                            label: 'Top accuracy',
                            value: '${result.confidence.toStringAsFixed(1)}%',
                            color: _getConfidenceColor(result.confidence),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MetricCard(
                            label: 'Rating',
                            value: _getAccuracyRating(result.confidence),
                            color: const Color(0xFF0D47A1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Class predictions',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...result.scores.map(
                            (score) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: _ClassRow(score: score),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Graph section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Graph',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade50, Colors.blue.shade100],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: CustomPaint(
                        painter: _WaveGraphPainter(result.scores),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Image Analysis Results',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Rate',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Higher is better',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Lower analytics row (bar-like + pie-like widgets)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(child: _BarSummaryCard()),
                    SizedBox(width: 12),
                    Expanded(child: _PieSummaryCard(scores: result.scores)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Detailed information + button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.info_outline,
                              color: Color(0xFF2196F3),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Boat details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _getBoatDescription(result.boatType),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Typical usage',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getTypicalUsage(result.boatType),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomButton(
                  text: 'Scan Another',
                  icon: Icons.camera_alt,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: const Color(0xFF2196F3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClassRow extends StatelessWidget {
  const _ClassRow({required this.score});

  final ClassificationScore score;

  @override
  Widget build(BuildContext context) {
    final barColor = const Color(0xFF0D47A1);
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            score.label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: (score.confidence / 100).clamp(0.0, 1.0),
              backgroundColor: Colors.blue.shade50,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 70,
          child: Text(
            '${score.confidence.toStringAsFixed(1)}%',
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _WaveGraphPainter extends CustomPainter {
  final List<ClassificationScore> scores;

  _WaveGraphPainter(this.scores);

  @override
  void paint(Canvas canvas, Size size) {
    if (scores.isEmpty) return;

    final paint = Paint()
      ..color = const Color(0xFF0D47A1)
      ..style = PaintingStyle.fill;

    final maxScore = scores
        .map((s) => s.confidence)
        .reduce((a, b) => a > b ? a : b);
    final barWidth = size.width / scores.length;

    // Draw bars for each classification score
    for (int i = 0; i < scores.length; i++) {
      final score = scores[i];
      final barHeight = (score.confidence / maxScore) * (size.height - 20);
      final rect = Rect.fromLTWH(
        i * barWidth + 2,
        size.height - barHeight - 10,
        barWidth - 4,
        barHeight,
      );

      // Use different colors for top 3
      if (i < 3) {
        paint.color = const Color(0xFF0D47A1);
      } else {
        paint.color = const Color(0xFF0D47A1).withOpacity(0.3);
      }

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(2)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BarSummaryCard extends StatelessWidget {
  const _BarSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent scans',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Bar(heightFactor: 0.3, label: '1'),
                _Bar(heightFactor: 0.6, label: '2'),
                _Bar(heightFactor: 0.8, label: '3'),
                _Bar(heightFactor: 0.5, label: '4'),
                _Bar(heightFactor: 0.7, label: '5'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.heightFactor, this.label = ''});

  final double heightFactor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FractionallySizedBox(
        heightFactor: heightFactor,
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: const Color(0xFF2196F3),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PieSummaryCard extends StatelessWidget {
  const _PieSummaryCard({required this.scores});

  final List<ClassificationScore> scores;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(child: CustomPaint(painter: _PiePainter(scores))),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Boat mix',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text(
                  'Distribution of recent classifications (approximate).',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PiePainter extends CustomPainter {
  final List<ClassificationScore> scores;

  _PiePainter(this.scores);

  @override
  void paint(Canvas canvas, Size size) {
    if (scores.isEmpty) return;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..style = PaintingStyle.fill;

    // Calculate top 3 boat types
    final topScores = scores.take(3).toList();
    if (topScores.isEmpty) return;

    // Draw pie segments for top 3
    double startAngle = 0;
    final colors = [
      const Color(0xFF2196F3), // Blue
      Colors.orangeAccent, // Orange
      Colors.greenAccent.shade400, // Green
    ];

    for (int i = 0; i < topScores.length; i++) {
      final sweepAngle =
          (topScores[i].confidence / 100) * 6.28; // Convert to radians
      paint.color = colors[i % colors.length];
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
