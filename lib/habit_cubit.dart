import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitexa_apk/habit.dart';

class HabitCubit extends Cubit<List<Habit>> {
  HabitCubit() : super([]);

  void addNewHabit(Habit newHabit) {
    List<Habit> newOne = List<Habit>.from(state);
    newOne.add(newHabit);
    emit(newOne);
  }
}
