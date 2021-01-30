import 'package:enterlabs/ScreenUtls.dart';
import 'package:enterlabs/common_widget/common_page_bg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class LabTDCSRulesPage extends StatelessWidget {
  Test test;

  LabTDCSRulesPage({required this.test});

  static const String ruleRoute = '/tDCS-3-back/rule';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: new CommonPageBgWidget(
                content: new LabRulesWidget(
                    test))) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class LabRulesWidget extends StatelessWidget {
  Test? test;
  String? firstLetter;
  String? secondLetter;
  String? rules;

  LabRulesWidget(Test test) {
    this.test = test;
    rules =
        "测试开始后电脑屏幕呈现字母序列，每个字母出现在屏幕中央 3 s。每次实验由六组实验组成，每组实验序列长度为 60 个字母，一组结束后，经过 60 s 休息开始下一组实验。您需要在屏幕出现字母时判断该字母与（第）前 n 次出现的那个字母是否一致，一致则按“m”，不一致则按“n” ；判对则上下提示灯为红色，判错则显示绿色。";
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(focusNode);
    return new RawKeyboardListener(
        focusNode: focusNode,
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent && event.data is RawKeyEventDataWeb) {
            if (event.data.keyLabel == " ") {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/${test?.testType}/test",
                  arguments: test);
            }
          }
        },
        child: Column(
          children: <Widget>[
            new Expanded(child: Container()),
            new Container(
              child: new Center(
                child: Text(
                  "实验规则",
                  style: TextStyle(color: Colors.white, fontSize: 56),
                ),
              ),
            ),
            Padding(padding: new EdgeInsets.only(top:  ScreenUtils.calHeightInScreen(context, 24)),child: Image(
              height: 200,
              image:
              new AssetImage("icons/tdcs_rule.png"),
            ),),

            Padding(
              padding: new EdgeInsets.only(
                  top: ScreenUtils.calHeightInScreen(context, 70),
                  bottom: ScreenUtils.calHeightInScreen(context, 44)),
              child: Container(
                width: 750,
                height: 142,
                child: Text(
                  rules!!,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            new Expanded(child: Container())
          ],
        ));
  }
}
