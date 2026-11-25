import 'package:get/get.dart';
import 'package:retina_scan_app/res/services/data_service.dart';

/// Remembers which bottom navigation tab is selected.
/// Shared by the doctor and the patient dashboard.
class MainShellController extends GetxController {
  final RxInt currentIndex = 0.obs;

  /// Shows the tab at [index] and refreshes the data in the background.
  void setIndex(int index) {
    currentIndex.value = index;
    Get.find<DataService>().refreshReports();
  }
}