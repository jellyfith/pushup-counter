import 'package:shared_preferences/shared_preferences.dart';
import 'package:home_widget/home_widget.dart';

class PushupService {
  static const String _pushupCountKey = 'pushup_count';
  static const String _maxPushupKey = 'max_pushup_record';

  // Initialize widget
  static Future<void> initializeWidget() async {
    try {
      await HomeWidget.setAppGroupId('group.pushup_counter');
      await updateWidget();
    } catch (e) {
      print('Error initializing widget: $e');
    }
  }

  // Get current pushup count
  static Future<int> getCurrentCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_pushupCountKey) ?? 0;
  }

  // Save current pushup count
  static Future<void> saveCurrentCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pushupCountKey, count);

    // Update max record if needed
    final currentMax = await getMaxRecord();
    if (count > currentMax) {
      await saveMaxRecord(count);
    }

    // Update widget
    await updateWidget();
  }

  // Get maximum pushup record
  static Future<int> getMaxRecord() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_maxPushupKey) ?? 0;
  }

  // Save maximum pushup record
  static Future<void> saveMaxRecord(int maxCount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_maxPushupKey, maxCount);
    await updateWidget();
  }

  // Reset current count
  static Future<void> resetCurrentCount() async {
    await saveCurrentCount(0);
  }

  // Update home screen widget
  static Future<void> updateWidget() async {
    try {
      final currentCount = await getCurrentCount();
      final maxRecord = await getMaxRecord();

      await HomeWidget.saveWidgetData<int>('pushup_count', currentCount);
      await HomeWidget.saveWidgetData<int>('max_record', maxRecord);
      await HomeWidget.updateWidget(
        name: 'PushupWidgetProvider',
        androidName: 'PushupWidgetProvider',
        iOSName: 'PushupWidget',
      );
    } catch (e) {
      print('Error updating widget: $e');
    }
  }
}
