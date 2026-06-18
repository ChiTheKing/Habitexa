import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habitexa_apk/Icon_files/icon_cubit.dart';
import 'package:habitexa_apk/habit.dart';
import 'package:habitexa_apk/habit_cubit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Habits"), centerTitle: true),
      // FIX: Nest builders at the top level, NOT inside the row loop
      body: BlocBuilder<HabitCubit, List<Habit>>(
        builder: (context, habitList) {
          return BlocBuilder<IconCubit, List<IconData>>(
            builder: (context, iconList) {
              if (habitList.isEmpty) {
                return const Center(
                  child: Text("No habits added yet. Tap + to begin!"),
                );
              }

              return ListView.builder(
                itemCount: habitList.length,
                itemBuilder: (context, index) {
                  // Safe lookup guard: Fallback to a default icon if lists mismatch
                  final IconData habitIcon = index < iconList.length
                      ? iconList[index]
                      : Icons.star;

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    child: Container(
                      // FIX: Allow width to expand naturally across the screen for a cleaner card layout
                      height: 85.h,
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(
                          12.r,
                        ), // FIX: Added missing 'BorderRadius'
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // FIX: Added missing 'CrossAxisAlignment'
                        mainAxisAlignment: MainAxisAlignment
                            .start, // FIX: Added missing 'MainAxisAlignment'
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 16.w),
                            child: Icon(
                              habitIcon,
                              size: 32.w,
                              color: Colors.deepPurple,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // FIX: Added missing 'MainAxisAlignment'
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // FIX: Added missing 'CrossAxisAlignment'
                              children: [
                                Text(
                                  habitList[index].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  habitList[index].description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // UI Improvement: Wrapped the dead icon inside an interactive InkWell/IconButton
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              // TODO: Connect this to your Cubits' delete functions:
                              // context.read<HabitCubit>().deleteHabit(index);
                              // context.read<IconCubit>().deleteIcon(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add, size: 36),
        onPressed: () {
          Navigator.pushNamed(context, 'add habit');
        },
      ),
    );
  }
}
