import 'dart:async';

import 'package:enterlabs/ScreenUtls.dart';
import 'package:enterlabs/common_widget/common_page_bg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class LabConfigPage extends StatelessWidget {

  static const String configRoute = '/AX-CPT/config';
  @override
  Widget build(BuildContext context) {
    Test test = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: new CommonPageBgWidget(
                content:
                    new LabConfigPageContentWidget(test: test))) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class LabConfigPageContentWidget extends StatefulWidget {
  Test test;
  LabConfigPageContentWidget({this.test});
  @override
  State<StatefulWidget> createState() {
    return new _LabConfigPageContentState(test:test);
  }
}

void _saveConfigInfo(String textShowTime, String textHideTime,Test test) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("textShowTime_${test.testType}", textShowTime);
  await preferences.setString("textHideTime_${test.testType}", textHideTime);
}

class _LabConfigPageContentState extends State<LabConfigPageContentWidget> {
  Test test;
  _LabConfigPageContentState({this.test});
  String textShowTime;
  String textHideTime;
  TextEditingController textShowController;
  TextEditingController textHideController;

  bool _isInputValid = false;
  bool _isShowErrorTip = false;

  void _initConfig() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    textShowTime = preferences.getString("textShowTime_${test.testType}");
    textHideTime = preferences.getString("textHideTime_${test.testType}");
    if (textShowTime == null || textHideTime == null) {
      textShowTime = "300";
      textHideTime = "400";
      _saveConfigInfo("300", "400",test);
    }

    textShowController = new TextEditingController(text: textShowTime);
    textHideController = new TextEditingController(text: textHideTime);
    _checkInputIsValid();
  }

  @override
  void initState() {
    super.initState();
    _initConfig();
  }

  void _checkInputIsValid() {
    setState(() {
      RegExp regExp = new RegExp(r"^[0-9]*$");
      _isInputValid = regExp.hasMatch(textShowTime) &&
          regExp.hasMatch(textHideTime) &&
          textShowTime != "" &&
          textHideTime != "";
    });
  }

  void _showErrorTip() {
    new Timer(new Duration(milliseconds: 3000), _hideErrorTip);
    setState(() {
      _isShowErrorTip = true;
    });
  }

  void _hideErrorTip() {
    setState(() {
      _isShowErrorTip = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget errorTip;
    if (_isShowErrorTip) {
      errorTip = new Container(
          decoration: BoxDecoration(
              color: Color(0xFFE5137B),
              borderRadius: BorderRadius.circular(26.5)),
          child: Padding(
            child: Text(
              "请输入数字",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            padding:
                new EdgeInsets.only(left: 16, top: 4, right: 16, bottom: 4),
          ));
    } else {
      errorTip = new Container(child: null);
    }
    return Container(
      width: 472,
      child: Column(
        children: <Widget>[
          new Expanded(child: new Container()),
          errorTip,
          Padding(
            padding: new EdgeInsets.only(
                top: ScreenUtils.calHeightInScreen(context, 53),
                bottom: ScreenUtils.calHeightInScreen(context, 96)),
            child: new Center(
              child: Text(
                "实验配置",
                style: TextStyle(color: Colors.white, fontSize: 56),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              new Expanded(
                child: Container(),
              ),
              Text(
                "字母显示时长:",
                style: TextStyle(color: Colors.white, fontSize: 32),
              ),
              Padding(
                padding: new EdgeInsets.only(left: 8, right: 8),
                child: Container(
                  width: 160,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  child: TextField(
                      controller: textShowController,
                      onChanged: (text) {
                        textShowTime = text;
                        _checkInputIsValid();
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0), //没什么卵效果
                          ))),
                ),
              ),
              Text(
                "毫秒",
                style: TextStyle(color: Colors.white, fontSize: 32),
              ),
              new Expanded(
                child: Container(),
              )
            ],
          ),
          Padding(
            child: Row(
              children: <Widget>[
                new Expanded(
                  child: Container(),
                ),
                Text(
                  "显示间隔时长:",
                  style: TextStyle(color: Colors.white, fontSize: 32),
                ),
                Padding(
                  padding: new EdgeInsets.only(left: 8, right: 8),
                  child: Container(
                    width: 160,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(4.0))),
                    child: TextField(
                        controller: textHideController,
                        onChanged: (text) {
                          textHideTime = text;
                          _checkInputIsValid();
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0), //没什么卵效果
                            ))),
                  ),
                ),
                Text(
                  "毫秒",
                  style: TextStyle(color: Colors.white, fontSize: 32),
                ),
                new Expanded(
                  child: Container(),
                )
              ],
            ),
            padding: new EdgeInsets.only(
                top: ScreenUtils.calHeightInScreen(context, 48),
                bottom: ScreenUtils.calHeightInScreen(context, 175)),
          ),
          Padding(
            padding: new EdgeInsets.only(bottom: 24),
            child: Container(
                decoration: BoxDecoration(
                    color: Color(0xffF5916D),
                    borderRadius: BorderRadius.circular(4)),
                width: 176,
                height: 61,
                child: FlatButton(
                  onPressed: () {
                    if (_isInputValid) {
                      _saveConfigInfo(textShowTime, textHideTime,test);
                      Navigator.pop(context);
                    } else {
                      _showErrorTip();
                    }
                  },
                  child: Text(
                    "确认修改",
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                )),
          ),
          Container(
              decoration: BoxDecoration(
                  border: new Border.all(color: Colors.white, width: 1),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(4)),
              width: 176,
              height: 61,
              child: FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "取消修改",
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
              )),
          new Expanded(child: new Container())
        ],
      ),
    );
  }
}
