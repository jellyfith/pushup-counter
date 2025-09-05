import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'pushup_service.dart';

void main() {
  runApp(const PushupRecordKeeperApp());
}

class PushupRecordKeeperApp extends StatelessWidget {
  const PushupRecordKeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pushup Record Keeper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const PushupRecordKeeperHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PushupRecordKeeperHome extends StatefulWidget {
  const PushupRecordKeeperHome({super.key});

  @override
  State<PushupRecordKeeperHome> createState() => _PushupRecordKeeperHomeState();
}

class _PushupRecordKeeperHomeState extends State<PushupRecordKeeperHome> {
  int _currentSessionCount = 0;
  int _personalRecord = 0;
  bool _newRecordSet = false;

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
      _currentSessionCount = currentCount;
      _personalRecord = maxRecord;
      _newRecordSet = currentCount > maxRecord;
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
        content: const Text('🎯 Opened from widget! Ready to set a new record!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _incrementPushups() async {
    final newCount = _currentSessionCount + 1;
    setState(() {
      _currentSessionCount = newCount;
      if (newCount > _personalRecord) {
        _personalRecord = newCount;
        _newRecordSet = true;
      }
    });
    await PushupService.saveCurrentCount(newCount);
  }

  Future<void> _resetCounter() async {
    setState(() {
      _currentSessionCount = 0;
      _newRecordSet = false;
    });
    await PushupService.resetCurrentCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Pushup Record Keeper',
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
                'Record: $_personalRecord',
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
            // Icon representing pushup
            Icon(
              Icons.fitness_center,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),

            // Personal Record display (main)
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
                  Text(
                    'Personal Record',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: _newRecordSet ? Theme.of(context).colorScheme.primary : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$_personalRecord',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: _newRecordSet ? Theme.of(context).colorScheme.primary : Colors.black,
                    ),
                  ),
                  if (_newRecordSet)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '🎉 New Record! 🎉',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Current Session display (secondary)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Current Session',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$_currentSessionCount',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Reset button
                ElevatedButton.icon(
                  onPressed: _currentSessionCount > 0 ? _resetCounter : null,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset Session'),
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
            if (_currentSessionCount > 0)
              Text(
                _getMotivationalMessage(_currentSessionCount),
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
