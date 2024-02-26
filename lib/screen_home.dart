import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_student_app/functions.dart';
import 'package:riverpod_student_app/screen_add.dart';
import 'package:riverpod_student_app/screen_edit.dart';

class ScreenHome extends ConsumerWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentList = ref.watch(studentProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ScreenAdd())),
        label: const Text('Add Student'),
      ),
      appBar: AppBar(
        title: const Text('Student List'),
      ),
      body: ListView.builder(
          itemCount: studentList.length,
          itemBuilder: (context, index) {
            final data = studentList[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: FileImage(
                  File(data.image),
                ),
              ),
              title: Text(data.name),
              subtitle: Text(data.age),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    // Handle edit action here
                    // You can navigate to an edit screen or show a dialog for editing
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ScreenEdit(
                              studentObj: data,
                              index: index,
                            )));
                  } else if (value == 'delete') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Student'),
                          content:
                              const Text('Are you sure you want to delete'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Delete'),
                              onPressed: () {
                                // Delete the student
                                ref
                                    .watch(studentProvider.notifier)
                                    .delete(index);

                                // Close the dialog
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                itemBuilder: (context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Edit'),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Delete'),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
