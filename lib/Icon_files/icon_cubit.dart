import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IconCubit extends Cubit<List<IconData>> {
  // Initial state is an empty list
  IconCubit() : super([]);

  void addIcon(IconData newIcon) {
    // Create a new list containing all old icons plus the new one.
    // This is required because BLoC needs a new object reference to trigger a rebuild.
    final updatedList = List<IconData>.from(state)..add(newIcon);

    emit(updatedList);
  }
}
