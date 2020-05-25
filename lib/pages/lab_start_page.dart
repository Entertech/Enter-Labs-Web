import 'package:enterlabs/ScreenUtls.dart';
import 'package:enterlabs/common_widget/common_page_bg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class LabStartPage extends StatelessWidget {

  static const String startRoute = '/AX-CPT';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: new CommonPageBgWidget(
                content:
                    new LabStartPageContentWidget())) // This trailing comma makes auto-formatting nicer for build methods.
        );
    return new CommonPageBgWidget(content: new LabStartPageContentWidget());
  }
}

class LabStartPageContentWidget extends StatelessWidget {
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
                  "AX-CPT 范式（AX version of Continuous Performance Task）是一个连续执行任务，连续性能测试。通过 AX-CPT 范式可以测试持续注意力。持续注意是保持对某些连续活动或刺激的持续关注的能力。",
                  style: TextStyle(color: Colors.white, fontSize: 32),
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
                Navigator.pushNamed(context, "/AX-CPT/config");
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
                  Navigator.pushNamed(context, "/AX-CPT/info");
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
