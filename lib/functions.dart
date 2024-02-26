// ignore_for_file: subtype_of_sealed_class, prefer_typing_uninitialized_variables

import 'package:flutter_riverpod/flutter_riverpod.dart';

// state notifier provider is a provider that used to listen to expose State notifier

final studentProvider =
    StateNotifierProvider<StudentFunction, List<StudentClass>>((ref) {
  return StudentFunction();
});

class StudentClass {
  final name;
  final age;
  final image;
  StudentClass({required this.name, required this.age, required this.image});
}

class StudentFunction extends StateNotifier<List<StudentClass>> {
  StudentFunction() : super([]);
  void addStudnet(studentObj) {
    state = [...state, studentObj];
    print(state.length);

    
  }

  void delete(index) {
  
    state.removeAt(index);
    state = [...state];
  }

  void updateStudent(index, updatedObj) {
    if (index != -1) {
      state[index] = updatedObj;

      state = [...state];
    }
  }
}
