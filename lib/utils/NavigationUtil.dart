import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationUtil {
  static List<BuildContext> contexts = [];

  static void pushPage(BuildContext context, Widget widget) {
    contexts.add(context);
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => widget),
    );
  }

  static void popPage(BuildContext context) {
    contexts.remove(context);
    Navigator.pop(context);
  }

  static void popAllPage() {
    for (int i = 0; i < contexts.length; i++) {
      Navigator.pop(contexts[i]);
    }
  }
}
