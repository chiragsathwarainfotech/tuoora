import 'package:get/get.dart';

class ResourceDetailController extends GetxController {
  final isPlaying = false.obs;
  final progress = 0.3.obs;

  void togglePlay() {
    isPlaying.value = !isPlaying.value;
  }
}
