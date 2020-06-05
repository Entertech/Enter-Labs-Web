import 'package:enterlabs/ScreenUtls.dart';
import 'package:enterlabs/common_widget/common_page_bg.dart';
import 'package:enterlabs/pages/lab_config_page.dart';
import 'package:enterlabs/pages/lab_test_page.dart';
import 'package:enterlabs/utils/NavigationUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class LabRulesPage extends StatelessWidget {
  Test test;
  LabRulesPage({this.test});
  static const String ruleRoute = '/AX-CPT/rule';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: new CommonPageBgWidget(
                content:
                    new LabRulesWidget(test))) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class LabRulesWidget extends StatelessWidget {
  Test test;
  String firstLetter;
  String secondLetter;
  String rules;
  LabRulesWidget(Test test){
    this.test = test;
    if(test.testType == Test.TEST_ATTENTION_AUDIO){
      firstLetter = "T";
      secondLetter = "S";
      rules = "实验开始后，将会播放一系列字母音频，每次一个。当听到 $firstLetter 字母出现后紧接着听到 $secondLetter 字母，则按下键盘空格键，其他字母组合不做任何反应。你需要在下一个字母出现前对当前字母做出反应。";
    }else{
      firstLetter = "A";
      secondLetter = "X";
      rules = "实验开始后，屏幕上将会闪现一系列字母，每次一个。当看到 $firstLetter 字母出现后紧接着出现的 $secondLetter 字母，则按下键盘空格键，其他字母组合不做任何反应。你需要在下一个字母出现前对当前字母做出反应。";
    }
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
              Navigator.pushNamed(context, "/${test.testType}/test",arguments: test);
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
            Padding(
              padding: new EdgeInsets.only(
                  top: ScreenUtils.calHeightInScreen(context, 42)),
              child: new Container(
                decoration: BoxDecoration(
                    color: Color(0xFFA7D8ED),
                    borderRadius: BorderRadius.circular(10)),
                width: 750,
                height: ScreenUtils.calHeightInScreen(context, 142),
                child: new Row(
                  children: <Widget>[
                    new Expanded(child: Container()),
                    Text(
                      "$firstLetter-$secondLetter",
                      style: TextStyle(color: Color(0xff323232), fontSize: 48),
                    ),
                    Padding(
                      padding: new EdgeInsets.only(left: 83, right: 83),
                      child: Text(
                        ">>>>>",
                        style:
                            TextStyle(color: Color(0xff323232), fontSize: 30),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        new Expanded(child: Container()),
                        Image(
                          width: 125,
                          height: 42,
                          image:
                              new AssetImage("assets/icons/icon_spacebar.png"),
                        ),
                        Text(
                          "按下空格键",
                          style:
                              TextStyle(color: Color(0xff323232), fontSize: 24),
                        ),
                        new Expanded(child: Container()),
                      ],
                    ),
                    new Expanded(child: Container())
                  ],
                ),
              ),
            ),
            Padding(
              padding: new EdgeInsets.only(
                  top: ScreenUtils.calHeightInScreen(context, 32)),
              child: new Container(
                decoration: BoxDecoration(
                    color: Color(0xFFA7D8ED),
                    borderRadius: BorderRadius.circular(10)),
                width: 750,
                height: ScreenUtils.calHeightInScreen(context, 142),
                child: new Row(
                  children: <Widget>[
                    new Expanded(child: Container()),
                    Text(
                      "其他组合",
                      style: TextStyle(color: Color(0xff323232), fontSize: 40),
                    ),
                    Padding(
                      padding: new EdgeInsets.only(left: 83, right: 83),
                      child: Text(
                        ">>>>>",
                        style:
                            TextStyle(color: Color(0xff323232), fontSize: 30),
                      ),
                    ),
                    Text(
                      "无操作",
                      style: TextStyle(color: Color(0xff323232), fontSize: 40),
                    ),
                    new Expanded(child: Container())
                  ],
                ),
              ),
            ),
            Padding(
              padding: new EdgeInsets.only(
                  top: ScreenUtils.calHeightInScreen(context, 70),
                  bottom: ScreenUtils.calHeightInScreen(context, 44)),
              child: Container(
                width: 750,
                height: 142,
                child: Text(
                  rules,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            Container(
              width: 750,
              child: Text(
                "一次实验总时长约 2 分钟，在准备好后按下空格键开始。",
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
            ),
            new Expanded(child: Container())
          ],
        ));
  }
}
