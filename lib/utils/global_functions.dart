import 'package:get/get.dart';

void errorSnackMessage(e){
  Get.snackbar("Error:", e.toString(), snackPosition: SnackPosition.BOTTOM);
}