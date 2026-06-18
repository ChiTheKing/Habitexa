import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

// Add this to notifications.dart
Future<void> debugCheckPendingNotifications() async {
  final List<PendingNotificationRequest> pending = await plugin
      .pendingNotificationRequests();
  print("--- DEBUG: ALARM QUEUE START ---");
  if (pending.isEmpty) {
    print("QUEUE IS EMPTY: No alarms are scheduled.");
  } else {
    for (var notification in pending) {
      print("ID: ${notification.id}, Title: ${notification.title}");
    }
  }
  print("--- DEBUG: ALARM QUEUE END ---");
}

final FlutterLocalNotificationsPlugin plugin =
    FlutterLocalNotificationsPlugin();

// 1. INITIALIZATION (Updated for v20+)
Future<void> initNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings settings = InitializationSettings(
    android: androidSettings,
  );

  // 1. Initialize the plugin with named arguments
  await plugin.initialize(
    settings: settings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle when the user taps the notification here
      print('Notification tapped: ${response.payload}');
    },
  );

  // 2. FIX: Resolve Android specific implementation to request exact alarm permissions
  final AndroidFlutterLocalNotificationsPlugin? androidPlugin = plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  if (androidPlugin != null) {
    // Requests the standard notification banner permission (Android 13+)
    await androidPlugin.requestNotificationsPermission();

    // Requests exact alarm execution clearance (Android 14+), bypassing the PlatformException
    await androidPlugin.requestExactAlarmsPermission();
  }
}

// 2. SCHEDULING A REPEATING NOTIFICATION (Updated for v20+)
// 2. SCHEDULING A REPEATING NOTIFICATION (Updated for v20+)
Future<void> scheduleWeeklyNotification({
  required int id,
  required String title,
  required String body,
  required tz.TZDateTime scheduledDate,
}) async {
  // Define the channel explicitly
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'weekly_habit_channel_v2',
    'Habit Reminders',
    channelDescription: 'Reminders for weekly habits',
    importance: Importance.max,
    priority: Priority.high,
    // Add this to ensure the OS treats this as a foreground-level alarm
    fullScreenIntent: true,
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
  );

  await plugin.zonedSchedule(
    id: id,
    title: title,
    body: body,
    scheduledDate: scheduledDate,
    notificationDetails: platformDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
  );
}

// 3. INSTANT NOTIFICATION (Updated for v20+)
Future<void> showImmediateNotification(
  int id,
  String title,
  String body,
) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'instant_channel',
    'Instant Notifications',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
  );

  // FIX: Named arguments strictly enforced
  await plugin.show(
    id: id,
    title: title,
    body: body,
    notificationDetails: platformDetails,
  );
}

// 4. CANCELLING NOTIFICATIONS (Updated for v20+)
Future<void> cancelNotification(int id) async {
  // FIX: Named argument enforced
  await plugin.cancel(id: id);
}
