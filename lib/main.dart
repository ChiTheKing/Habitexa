import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timezone/data/latest_all.dart'
    as tz; // IMPORT THIS: For timezone database initialization
import 'package:habitexa_apk/Notifications/notifications.dart'; // Imports top-level initNotifications
import 'package:habitexa_apk/add_habit_page.dart';
import 'package:habitexa_apk/habit_cubit.dart';
import 'package:habitexa_apk/Icon_files/icon_cubit.dart';
import 'package:habitexa_apk/my_home_page.dart';

void main() async {
  // Ensure Flutter binding is ready before calling native platform plugins
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Timezones (Crucial step for v20+ dynamic scheduling)
  tz.initializeTimeZones();

  // 2. Initialize Notifications (Calls your clean, top-level function directly)
  await initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => IconCubit()),
          BlocProvider(create: (context) => HabitCubit()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (_) => const MyHomePage(),
            'add habit': (_) => const AddNewHabitPage(),
          },
          title: 'Habitexa',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true, // Enhances modern UI rendering
          ),
        ),
      ),
    );
  }
}
