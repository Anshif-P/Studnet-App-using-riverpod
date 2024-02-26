// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'functions.dart';
import 'image_function.dart';

class ScreenEdit extends ConsumerWidget {
  ScreenEdit({super.key, required this.studentObj, this.index});
  final studentObj;
  final index;
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  File? imageTemp;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    nameController.text = studentObj.name;
    ageController.text = studentObj.age;

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
              backgroundImage: imageTemp != null
                  ? FileImage(
                      File(imageTemp!.path),
                    )
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
              updateStudent(ref, imagepath, context, index);
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
      imageTemp = File(image.path);
      ref.read(imageProvider.notifier).imagePicker(image.path);
    }
  }

  updateStudent(WidgetRef ref, imagePath, context, index) {
    final name = nameController.text;
    final age = ageController.text;
    if (name.isNotEmpty && age.isNotEmpty && imagePath != null) {
      final studentObj = StudentClass(name: name, age: age, image: imagePath);

      ref.read(studentProvider.notifier).updateStudent(index, studentObj);
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
