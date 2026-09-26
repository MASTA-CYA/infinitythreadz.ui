import 'package:infinity_threadz/common/constants.dart';

class Functions {
  /// Number of grid columns for the given screen width:
  /// 1 on phones, 2 on tablets and 3 on laptops/desktops.
  static int getCrossAxisCount(double width) {
    if (width >= DeviceSize.laptopScreenWidth) {
      return 3;
    }
    if (width > DeviceSize.tabletScreenWidth) {
      return 2;
    }
    return 1;
  }
}
