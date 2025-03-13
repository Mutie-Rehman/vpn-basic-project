import 'package:get/get.dart';

class LoadingController extends GetxController {
  var isLoading = true.obs;

  void startLoading() {
    isLoading.value = true;
  }

  void stopLoading() {
    isLoading.value = false;
  }
}
