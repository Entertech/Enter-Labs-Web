import 'package:enterlabs/ScreenUtls.dart';
import 'package:enterlabs/common_widget/common_page_bg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class UserInfoPage extends StatelessWidget {
  static const String infoRoute = '/AX-CPT/info';
  Test test;
  UserInfoPage({this.test});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: new CommonPageBgWidget(
                content:
                    new UserInfoPageContentWidget(test:test))) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class UserInfoPageContentWidget extends StatefulWidget {
  Test test;
  UserInfoPageContentWidget({this.test});
  @override
  State<StatefulWidget> createState() {
    return new _UserInfoPageContentState(test:test);
  }
}

class _UserInfoPageContentState extends State<UserInfoPageContentWidget> {
  Test test;
  _UserInfoPageContentState({this.test});
  bool _isInputValid = false;
  String _name = "";
  String _labId = "";

  void _checkInputIsValid() {
    setState(() {
      _isInputValid = _name != "" && _labId != "";
    });
  }

  @override
  Widget build(BuildContext context) {
    Color btnColor;
    if (_isInputValid) {
      btnColor = Color(0xffF5916D);
    } else {
      btnColor = Color(0xffABABAB);
    }
    return new Container(
      width: 474,
      child: Column(
        children: <Widget>[
          new Expanded(child: Container()),
          new Center(
              child: new Text(
            "信息填写",
            style: TextStyle(color: Colors.white, fontSize: 56),
          )),
          Padding(
            child: new Container(
              child: new Text(
                "姓名",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              alignment: Alignment.centerLeft,
            ),
            padding: new EdgeInsets.only(
                top: ScreenUtils.calHeightInScreen(context, 120)),
          ),
          Padding(
              padding: new EdgeInsets.only(
                  top: ScreenUtils.calHeightInScreen(context, 8)),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  child: new TextField(
                    onChanged: (text) {
                      _name = text;
                      _checkInputIsValid();
                    },
                    style: TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                        hintText: "输入名字",
                        hintStyle:
                            TextStyle(color: Color(0xff999999), fontSize: 24),
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
//            borderSide: BorderSide(color: Colors.red, width: 3.0, style: BorderStyle.solid)//没什么卵效果
                        )),
                  ))),
          Padding(
            child: new Container(
              child: new Text(
                "实验编号",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              alignment: Alignment.centerLeft,
            ),
            padding: new EdgeInsets.only(
                top: ScreenUtils.calHeightInScreen(context, 56)),
          ),
          Padding(
              padding: new EdgeInsets.only(
                  top: ScreenUtils.calHeightInScreen(context, 8)),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  child: new TextField(
                    onChanged: (text) {
                      _labId = text;
                      _checkInputIsValid();
                    },
                    style: TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                        hintText: "输入实验编号",
                        hintStyle:
                            TextStyle(color: Color(0xff999999), fontSize: 24),
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
//            borderSide: BorderSide(color: Colors.red, width: 3.0, style: BorderStyle.solid)//没什么卵效果
                        )),
                  ))),
          Padding(
            padding: new EdgeInsets.only(top: 95),
            child: Container(
                decoration: BoxDecoration(
                    color: btnColor, borderRadius: BorderRadius.circular(4)),
                width: 176,
                height: 61,
                child: FlatButton(
                  onPressed: () {
                    if (_isInputValid) {
                      _saveUserInfo();
                      Navigator.pushNamed(context, "/${test.testType}/rule",arguments: test);
//                      Navigator.push(
//                        context,
//                        new MaterialPageRoute(builder: (context) => new LabRulesPage()),
//                      );
                    }
                  },
                  child: Text(
                    "开始测试",
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                )),
          ),
          new Expanded(child: Container()),
        ],
      ),
    );
  }

  void _saveUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("user", _name);
    await preferences.setString("labId", _labId);
  }
//
//  void _initUserInfo(BuildContext context) async {
//    SharedPreferences preferences = await SharedPreferences.getInstance();
//    showAlertDialog(context,"111111");
//    _name = preferences.getString("user");
//    _labId = preferences.getString("labId");
//  }
}
