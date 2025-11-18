import 'package:get/get.dart';

class MyDrawer extends GetxController {

  var selectedIndex = 0.obs;
  // var selectedChildIndex = Rxn<int>();
  //
  // void selectParent(int index) {
  //   selectedIndex.value = index;
  //   selectedChildIndex.value = null;
  // }
  //
  // void selectChild(int parentIndex, int childIndex) {
  //   selectedIndex.value = parentIndex;
  //   selectedChildIndex.value = childIndex;
  // }

  void selectIndex(int index) {
    selectedIndex.value = index;
  }
}
