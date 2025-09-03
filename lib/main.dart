import 'package:flutter/material.dart';

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

  void _incrementPushups() {
    setState(() {
      _pushupCount++;
    });
  }

  void _resetCounter() {
    setState(() {
      _pushupCount = 0;
    });
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon representing pushup
            Icon(
              Icons.fitness_center,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 30),

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
                    'Pushups',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$_pushupCount',
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

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
