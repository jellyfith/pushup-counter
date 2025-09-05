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
  int _personalRecord = 0;

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
    final maxRecord = await PushupService.getMaxRecord();

    setState(() {
      _personalRecord = maxRecord;
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

  // Add this method to show a dialog for editing the record
  Future<void> _editRecordDialog() async {
    final controller = TextEditingController(text: _personalRecord.toString());
    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Pushup Record'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Enter new record'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null && value >= 0) {
                Navigator.of(context).pop(value);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) {
      setState(() {
        _personalRecord = result;
      });
      await PushupService.saveMaxRecord(result);
    }
  }

  void _incrementRecord() async {
    setState(() {
      _personalRecord++;
    });
    await PushupService.saveMaxRecord(_personalRecord);
  }

  void _decrementRecord() async {
    if (_personalRecord > 0) {
      setState(() {
        _personalRecord--;
      });
      await PushupService.saveMaxRecord(_personalRecord);
    }
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

            // Personal Record display (main) with editable and increment/decrement controls
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
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        iconSize: 36,
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: _decrementRecord,
                      ),
                      GestureDetector(
                        onTap: _editRecordDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$_personalRecord',
                            style: TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        iconSize: 36,
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: _incrementRecord,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
