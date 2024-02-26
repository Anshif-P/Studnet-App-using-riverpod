import 'package:flutter_riverpod/flutter_riverpod.dart';

final imageProvider = StateNotifierProvider((ref) {
  return ImagePickFunctions();
});

class ImagePickFunctions extends StateNotifier<String?> {
  //state initialization
  ImagePickFunctions() : super(null);
  bool imagePicked = false;
  void imagePicker(path) {
    state = path;
    imagePicked = true;
  }
}
