import 'package:flutter/cupertino.dart';
class ScreenUtils {
  static double calHeightInScreen(BuildContext context, double height) {
    return (MediaQuery.of(context).size.height) * (height / 927.0);
  }
  static double calWidthInScreen(BuildContext context, double width) {
    return (MediaQuery.of(context).size.width) * (width / 1024.0);
  }
}
