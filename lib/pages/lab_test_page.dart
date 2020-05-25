import 'dart:async';
import 'dart:convert';

import 'dart:html' as html;
import 'package:csv/csv.dart';
import 'package:enterlabs/ScreenUtls.dart';
import 'package:enterlabs/common_widget/common_page_bg.dart';
import 'package:enterlabs/pages/lab_rules_page.dart';
import 'package:enterlabs/utils/RandomLettersGenUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LabTestPage extends StatelessWidget {
  static const String testRoute = '/AX-CPT/test';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: new CommonPageBgWidget(
                content:
                    new LabTestPageContentWidget())) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class LabTestPageContentWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LabTestPageContentWidgetState();
  }
}

class LetterShowEvent {
  String letter;
  int letterAppearTime;
  int actionTime;
  String action = "";
  String userResult;
  String rightResult;

  @override
  String toString() {
    return 'LetterShowEvent{letter: $letter, letterAppearTime: $letterAppearTime, actionTime: $actionTime, action: $action, userResult: $userResult, rightResult: $rightResult}';
  }
}

class _LabTestPageContentWidgetState extends State<LabTestPageContentWidget> {
  var letters = RandomLettersGenUtil.genRandomLetters();
  var showLetterEventList = new List<LetterShowEvent>();
  var isFirstIn = true;
  var isShowLetter = false;
  var alreadyShowLetterCount = 0;
  Timer showTextTimer;
  Timer hideTextTimer;
  int _textShowTime = 300;
  int _textHideTime = 400;
  String _testStartTime = "";
  var isTestEnd = false;
  String _user = "";
  String _labId = "";
  String _fileName = "";
  bool isFlushPrepare = true;
  int prepareCount = 4;

  FocusNode focusNode = FocusNode();

  void _initTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var textShowTimeStr = preferences.getString("textShowTime");
    var textHideTimeStr = preferences.getString("textHideTime");
    if (textShowTimeStr != null && textShowTimeStr != "") {
      _textShowTime = int.parse(textShowTimeStr);
    }
    if (textHideTimeStr != null && textHideTimeStr != "") {
      _textHideTime = int.parse(textHideTimeStr);
    }
    _prepareTest();
  }

  void _prepareTest() {
    setState(() {
      isFlushPrepare = true;
      prepareCount--;
    });
    if (prepareCount > 0) {
      new Timer(new Duration(milliseconds: 1000), _prepareTest);
    }else{
      isFlushPrepare = false;
      _hideText();
    }
  }

  void _startShowText() {
    _initTime();
  }

  void _showText() {
    showTextTimer =
        new Timer(new Duration(milliseconds: _textShowTime), _hideText);
    setState(() {
      isShowLetter = true;
      alreadyShowLetterCount++;
    });
  }

  void _hideText() {
    hideTextTimer =
        new Timer(new Duration(milliseconds: _textHideTime), _showText);
    setState(() {
      isShowLetter = false;
      if (alreadyShowLetterCount >= 100) {
        showTextTimer.cancel();
        hideTextTimer.cancel();
        new Timer(new Duration(milliseconds: _textHideTime), _endTest);
      }
    });
  }

  void _endTest() {
    setState(() {
      _getUserInfo();
      isTestEnd = true;
    });
  }

  void _getUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _user = preferences.getString("user");
    _labId = preferences.getString("labId");
  }

  void _handleLetterEventList() {
    for (int i = 0; i < showLetterEventList.length - 1; i++) {
      if (showLetterEventList[i].letter == "A" &&
          showLetterEventList[i + 1].letter == "X") {
        showLetterEventList[i + 1].rightResult = "TRUE_1";
        if (showLetterEventList[i + 1].action == "blankspace") {
          showLetterEventList[i + 1].userResult = "TRUE_1";
        } else {
          showLetterEventList[i + 1].userResult = "OVERTIME";
        }
      }
      if (i > 0) {
        if (showLetterEventList[i].action == "blankspace") {
          if (showLetterEventList[i].letter != "X" ||
              (showLetterEventList[i].letter == "X" &&
                  showLetterEventList[i - 1].letter != "A")) {
            showLetterEventList[i].userResult = "FALSE";
          }
        }
      }
    }

//    print(showLetterEventList.toList().toString());
  }

  String _initCsvText() {
    List<List<dynamic>> rows = List<List<dynamic>>();
    List<dynamic> userTitleRow = List();
    userTitleRow.add("id");
    userTitleRow.add("user");
    userTitleRow.add("start_time");
    rows.add(userTitleRow);
    List<dynamic> userContentRow = List();
    userContentRow.add(_labId);
    userContentRow.add(_user);
    userContentRow.add(_testStartTime);
    rows.add(userContentRow);
    rows.add(List<dynamic>());
    List<dynamic> row = List();
    row.add("letter");
    row.add("action");
    row.add("user_result");
    row.add("right_result");
    row.add("appear_time");
    row.add("action_time");
    rows.add(row);
    for (int i = 0; i < showLetterEventList.length; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = List();
      row.add(showLetterEventList[i].letter);
      row.add(showLetterEventList[i].action);
      row.add(showLetterEventList[i].userResult);
      row.add(showLetterEventList[i].rightResult);
      row.add(showLetterEventList[i].letterAppearTime);
      row.add(showLetterEventList[i].actionTime);
      rows.add(row);
    }
    return const ListToCsvConverter().convert(rows);
  }

  void _onFileDownload(String text) {
    // prepare
    final bytes = utf8.encode(text);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = '$_fileName.csv';
    html.document.body.children.add(anchor);

    // download
    anchor.click();

    // cleanup
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  void _onDownloadFileClick() async {
    _handleLetterEventList();
    var csvText = _initCsvText();
    _onFileDownload(csvText);
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(focusNode);
    if (isTestEnd) {
      _fileName = "$_user-编号：$_labId";
      return Container(
          width: 343,
          child: Column(
            children: <Widget>[
              new Expanded(child: Container()),
              Center(
                child: Image(
                  width: 80,
                  height: 80,
                  image: new AssetImage("assets/icons/icon_test_end.png"),
                ),
              ),
              Padding(
                padding: new EdgeInsets.only(
                    top: ScreenUtils.calHeightInScreen(context, 32),
                    bottom: ScreenUtils.calHeightInScreen(context, 75)),
                child: Text(
                  "实验结束！",
                  style: TextStyle(color: Colors.white, fontSize: 48),
                ),
              ),
              Center(
                child: Text(
                  "点击下方保存实验结果报表。",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Padding(
                  padding: new EdgeInsets.only(
                      top: 16,
                      bottom: ScreenUtils.calHeightInScreen(context, 175)),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    width: 343,
                    height: 60,
                    child: FlatButton(
                        onPressed: _onDownloadFileClick,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Positioned(
                              child: Image(
                                width: 18,
                                height: 21,
                                image: new AssetImage(
                                    "assets/icons/icon_file.png"),
                              ),
                              left: 16,
                            ),
                            Positioned(
                              left: 49,
                              child: Text(
                                _fileName,
                                style: TextStyle(
                                    color: Color(0xff333333), fontSize: 16),
                              ),
                            ),
                            Positioned(
                              child: Image(
                                width: 18,
                                height: 18,
                                image: new AssetImage(
                                    "assets/icons/icon_download.png"),
                              ),
                              right: 21,
                            )
                          ],
                        )),
                  )),
              Padding(
                padding: new EdgeInsets.only(top: 95),
                child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xffF5916D),
                        borderRadius: BorderRadius.circular(4)),
                    width: 176,
                    height: 61,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: Text(
                        "返回主页",
                        style: TextStyle(color: Colors.white, fontSize: 28),
                      ),
                    )),
              ),
              new Expanded(child: Container())
            ],
          ));
    }
    if (isFirstIn) {
      _startShowText();
      var now = DateTime.now();
      _testStartTime =
          "${now.month}/${now.day}/${now.year} ${now.hour}:${now.minute}";
      isFirstIn = false;
    }
    String showLetter = "";
    if(isFlushPrepare){
      showLetter = "$prepareCount";
    }else{
      if (isShowLetter) {
        showLetter = letters[alreadyShowLetterCount - 1];
        LetterShowEvent letterShowEvent = new LetterShowEvent();
        letterShowEvent.letter = showLetter;
        letterShowEvent.rightResult = "TRUE_0";
        letterShowEvent.userResult = "TRUE_0";
        letterShowEvent.letterAppearTime = DateTime.now().millisecondsSinceEpoch;
        showLetterEventList.add(letterShowEvent);
      } else {
        showLetter = "";
      }
    }

    return new RawKeyboardListener(
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent && event.data is RawKeyEventDataWeb) {
          if (event.data.keyLabel == " " && !isFlushPrepare) {
            showLetterEventList[alreadyShowLetterCount - 1].action =
                "blankspace";
            showLetterEventList[alreadyShowLetterCount - 1].actionTime =
                DateTime.now().millisecondsSinceEpoch;
          }
        }
      },
      focusNode: focusNode,
      child: new ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              child: Center(
                child: Text(
                  showLetter,
                  style: TextStyle(color: Colors.white, fontSize: 180),
                ),
              ),
            ),
            Positioned(
              left: ScreenUtils.calWidthInScreen(context, 96),
              top: ScreenUtils.calHeightInScreen(context, 40),
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(127, 255, 255, 255),
                    borderRadius: BorderRadius.circular(30)),
                width: 178,
                height: 60,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new LabRulesPage()),
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      new Expanded(child: Container()),
                      Image(
                        width: 34,
                        height: 34,
                        image:
                            new AssetImage("assets/icons/icon_restart_lab.png"),
                      ),
                      Padding(
                        padding: new EdgeInsets.only(left: 16),
                        child: Text(
                          "重新开始",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                      new Expanded(child: Container())
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
