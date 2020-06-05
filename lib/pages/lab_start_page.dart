import 'package:enterlabs/ScreenUtls.dart';
import 'package:enterlabs/common_widget/common_page_bg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class LabStartPage extends StatelessWidget {
  static const String startRoute = '/AX-CPT';
  Test test;
  LabStartPage({this.test});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: new CommonPageBgWidget(
                content: new LabStartPageContentWidget(
                    test))) // This trailing comma makes auto-formatting nicer for build methods.
        );
//    return new CommonPageBgWidget(content: new LabStartPageContentWidget());
  }
}

class LabStartPageContentWidget extends StatelessWidget {
  Test test;
  String introduceText;
  double introduceTextSize;

  LabStartPageContentWidget(Test test) {
    this.test = test;
    if (test.testType == Test.TEST_ATTENTION_AUDIO) {
      introduceTextSize = 22;
      this.introduceText =
          "CPT是一个著名的对连续专注力的测试范式，要求被试对一系列字母保持专注，并对特定字母对做出反应，最初在1956年由Rosvold等人提出，被称为持续注意力测试的“黄金标准”。本实验是在上述视觉CPT的基础上，为获取更好的EEG信号质量并更贴近实际应用而改造形成的范式，该范式要求被试保持闭眼状态，用听觉对字母序列保持专注，并对特定字母对作出反应，旨在减少睁眼状态下眼电带来的噪声，并希望更接近冥想时的专注状态。";
    } else if (test.testType == Test.TEST_ATTENTION_LETTER) {
      introduceTextSize = 32;
      this.introduceText =
          "AX-CPT 范式（AX version of Continuous Performance Task）是一个连续执行任务，连续性能测试。通过 AX-CPT 范式可以测试持续注意力。持续注意是保持对某些连续活动或刺激的持续关注的能力。";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Expanded(
          child: Container(),
        ),
        new Container(
            child: new Center(
          child: Text(
            "实验介绍",
            style: TextStyle(color: Colors.white, fontSize: 56),
          ),
        )),
        Padding(
          padding: new EdgeInsets.only(
              top: ScreenUtils.calHeightInScreen(context, 28),
              left: ScreenUtils.calWidthInScreen(context, 176),
              right: ScreenUtils.calWidthInScreen(context, 176)),
          child: new Container(
              width: ScreenUtils.calWidthInScreen(context, 1087),
              child: new Center(
                child: Text(
                  introduceText,
                  style: TextStyle(color: Colors.white, fontSize: introduceTextSize),
                ),
              )),
        ),
        Padding(
          padding: new EdgeInsets.only(
              top: ScreenUtils.calHeightInScreen(context, 230)),
          child: new Container(
            alignment: Alignment.center,
            width: 214,
            height: 61,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: new Border.all(color: Colors.white, width: 1)),
            child: FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, "/${test.testType}/config", arguments: test);
//                Navigator.push(
//                  context,
//                  new MaterialPageRoute(
//                      builder: (context) => new LabConfigPage()),
//                );
              },
              child: new Center(
                child: new Row(
                  children: <Widget>[
                    new Expanded(child: Container()),
                    new Image(
                        width: 48,
                        height: 48,
                        image: new AssetImage("assets/icons/lab_settings.png")),
                    Padding(
                      child: Text(
                        "实验配置",
                        style: TextStyle(color: Colors.white, fontSize: 28),
                      ),
                      padding: new EdgeInsets.only(left: 12),
                    ),
                    new Expanded(child: Container()),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: new EdgeInsets.only(top: 56),
          child: Container(
              decoration: BoxDecoration(
                  color: Color(0xffF5916D),
                  borderRadius: BorderRadius.circular(4)),
              width: 176,
              height: 61,
              child: FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/${test.testType}/info", arguments: test);
//                  Navigator.push(
//                    context,
//                    new MaterialPageRoute(
//                        builder: (context) => new UserInfoPage()),
//                  );
                },
                child: Text(
                  "确认",
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
              )),
        ),
        new Expanded(
          child: Container(),
        )
      ],
    );
  }
}
