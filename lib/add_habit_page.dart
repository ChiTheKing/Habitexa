import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:habitexa_apk/Icon_files/icon_cubit.dart';
import 'package:habitexa_apk/Notifications/notifications.dart';
import 'package:habitexa_apk/habit.dart';
import 'package:habitexa_apk/habit_cubit.dart';

class AddNewHabitPage extends StatefulWidget {
  const AddNewHabitPage({super.key});

  @override
  State<AddNewHabitPage> createState() => _AddNewHabitPageState();
}

class _AddNewHabitPageState extends State<AddNewHabitPage> {
  final List<IconData> availableIcons = [
    Icons.home,
    Icons.star,
    Icons.favorite,
    Icons.person,
    Icons.settings,
    Icons.camera,
    Icons.flight,
    Icons.car_crash,
    Icons.music_note,
    Icons.sports_esports,
    Icons.pets,
    Icons.coffee,
    Icons.access_alarm_sharp,
  ];

  IconData? selectedIcon;
  final TextEditingController textControl = TextEditingController();
  final TextEditingController textControl2 = TextEditingController();

  final List<String> weekDays = ["M", "T", "W", "T", "F", "S", "S"];
  List<int> selectedDays = []; // 1 = Monday, 7 = Sunday
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);

  tz.TZDateTime _nextInstanceOfDayAndTime(int day, int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the time is in the past today or not the correct day, increment until it hits the target
    while (scheduledDate.weekday != day || scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    debugPrint("DEBUG: Scheduling for: $scheduledDate (Now: $now)");
    return scheduledDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add new habit")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: textControl,
              maxLength: 25,
              decoration: const InputDecoration(
                hintText: 'Enter habit name...',
              ),
            ),
            TextField(
              controller: textControl2,
              maxLength: 100,
              decoration: const InputDecoration(
                hintText: 'Enter habit description...',
              ),
            ),
            const SizedBox(height: 20),

            // Time Picker
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                "Reminder Time",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  selectedTime.format(context),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () async {
                final TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (time != null) setState(() => selectedTime = time);
              },
            ),

            const SizedBox(height: 10),
            const Text(
              "Repeat on",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Days Selection
            Wrap(
              spacing: 8.0,
              children: List.generate(7, (index) {
                final int dayNumber = index + 1;
                final bool isSelected = selectedDays.contains(dayNumber);
                return ChoiceChip(
                  label: Text(weekDays[index]),
                  selected: isSelected,
                  selectedColor: Colors.deepPurple,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                  onSelected: (bool selected) {
                    setState(() {
                      selected
                          ? selectedDays.add(dayNumber)
                          : selectedDays.remove(dayNumber);
                    });
                  },
                );
              }),
            ),

            const SizedBox(height: 30),
            const Text(
              "Select Icon",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisExtent: 60,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: availableIcons.length,
              itemBuilder: (context, index) {
                final icon = availableIcons[index];
                final isSelected = selectedIcon == icon;
                return GestureDetector(
                  onTap: () => setState(() => selectedIcon = icon),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.deepPurple
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 30,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                final habitName = textControl.text.trim();
                if (habitName.isEmpty ||
                    selectedIcon == null ||
                    selectedDays.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields")),
                  );
                  return;
                }

                // Update State
                context.read<IconCubit>().addIcon(selectedIcon!);
                context.read<HabitCubit>().addNewHabit(
                  Habit(name: habitName, description: textControl2.text.trim()),
                );

                // Notifications
                final int baseId =
                    DateTime.now().millisecondsSinceEpoch % 100000;
                showImmediateNotification(
                  baseId,
                  "Habit Added!",
                  'You have successfully added "$habitName"',
                );

                for (int day in selectedDays) {
                  final uniqueDayId = baseId + day;
                  final scheduledDate = _nextInstanceOfDayAndTime(
                    day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );

                  // Permission Check
                  final androidPlugin = plugin
                      .resolvePlatformSpecificImplementation<
                        AndroidFlutterLocalNotificationsPlugin
                      >();
                  final hasPermission = await androidPlugin
                      ?.canScheduleExactNotifications();
                  if (hasPermission == false) {
                    await androidPlugin?.requestExactAlarmsPermission();
                  }

                  await scheduleWeeklyNotification(
                    id: uniqueDayId,
                    title: "Time for your habit!",
                    body: "Let's complete: $habitName",
                    scheduledDate: scheduledDate,
                  );
                }

                await debugCheckPendingNotifications();
                if (!context.mounted) return;
                Navigator.pop(context);
              },
              child: const Text("Save Habit"),
            ),
          ],
        ),
      ),
    );
  }
}
