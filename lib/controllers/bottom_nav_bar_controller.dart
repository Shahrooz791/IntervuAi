import 'package:get/get.dart';

class NavController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changePage(int index) {
    if (currentIndex.value == index) return;
    currentIndex.value = index;
  }
}
