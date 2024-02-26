// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_student_app/functions.dart';
import 'package:riverpod_student_app/image_function.dart';

class ScreenAdd extends ConsumerWidget {
  ScreenAdd({super.key});
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var imagepath = ref.watch(imageProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Student')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(children: [
          InkWell(
            onTap: () {
              imagePick(ref);
            },
            child: CircleAvatar(
              backgroundImage:
                  ref.watch(imageProvider.notifier).imagePicked != true
                      ? const AssetImage('lib/image/person image.jpeg')
                      : FileImage(File(imagepath as String)) as ImageProvider,
              backgroundColor: Colors.blue,
              radius: 50,
            ),
          ),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Enter Your Name',
            ),
          ),
          TextField(
            controller: ageController,
            decoration: const InputDecoration(
              hintText: 'Enter Your Age',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              addStudent(ref, imagepath, context);
            },
            child: const Text('Add'),
          ),
        ]),
      ),
    );
  }

  void imagePick(WidgetRef ref) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      ref.read(imageProvider.notifier).imagePicker(image.path);
    }
  }

  addStudent(WidgetRef ref, imagePath, context) {
    final name = nameController.text;
    final age = ageController.text;
    if (name.isNotEmpty && age.isNotEmpty && imagePath != null) {
      final studentObj = StudentClass(name: name, age: age, image: imagePath);

      ref.read(studentProvider.notifier).addStudnet(studentObj);
      ref.read(imageProvider.notifier).imagePicked = false;
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Fill All Details'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
