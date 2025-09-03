import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'pushup_service.dart';

void main() {
  runApp(const PushupCounterApp());
}

class PushupCounterApp extends StatelessWidget {
  const PushupCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pushup Counter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const PushupCounterHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PushupCounterHome extends StatefulWidget {
  const PushupCounterHome({super.key});

  @override
  State<PushupCounterHome> createState() => _PushupCounterHomeState();
}

class _PushupCounterHomeState extends State<PushupCounterHome> {
  int _pushupCount = 0;
  int _maxRecord = 0;

  @override
  void initState() {
    super.initState();
    _initializeApp();
    _setupWidgetListener();
  }

  Future<void> _initializeApp() async {
    // Initialize widget
    await PushupService.initializeWidget();

    // Load saved data
    final currentCount = await PushupService.getCurrentCount();
    final maxRecord = await PushupService.getMaxRecord();

    setState(() {
      _pushupCount = currentCount;
      _maxRecord = maxRecord;
    });
  }

  void _setupWidgetListener() {
    // Listen for widget taps
    HomeWidget.widgetClicked.listen((Uri? uri) {
      if (uri != null) {
        _showWidgetTappedMessage();
      }
    });
  }

  void _showWidgetTappedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('🎯 Opened from widget! Ready to count pushups!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _incrementPushups() async {
    final newCount = _pushupCount + 1;
    setState(() {
      _pushupCount = newCount;
      if (newCount > _maxRecord) {
        _maxRecord = newCount;
      }
    });

    await PushupService.saveCurrentCount(newCount);
  }

  Future<void> _resetCounter() async {
    setState(() {
      _pushupCount = 0;
    });

    await PushupService.resetCurrentCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Pushup Counter',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Record: $_maxRecord',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Widget preview section
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Home Screen Widget Preview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Circular widget preview
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$_pushupCount',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'pushups',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  Text(
                    'Tap widget to open app',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            // Icon representing pushup
            Icon(
              Icons.fitness_center,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),

            // Counter display
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Current Session',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$_pushupCount',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Reset button
                ElevatedButton.icon(
                  onPressed: _pushupCount > 0 ? _resetCounter : null,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),

                // Add pushup button
                ElevatedButton.icon(
                  onPressed: _incrementPushups,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Pushup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Motivational text
            if (_pushupCount > 0)
              Text(
                _getMotivationalMessage(_pushupCount),
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),

      // Large floating action button for easy tapping
      floatingActionButton: FloatingActionButton.large(
        onPressed: _incrementPushups,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }

  String _getMotivationalMessage(int count) {
    if (count >= 100) {
      return "🔥 Amazing! You're crushing it! 🔥";
    } else if (count >= 50) {
      return "💪 Halfway to 100! Keep going! 💪";
    } else if (count >= 25) {
      return "🚀 Great progress! You're doing awesome! 🚀";
    } else if (count >= 10) {
      return "⭐ Nice work! Keep it up! ⭐";
    } else {
      return "🎯 Great start! Every rep counts! 🎯";
    }
  }
}
