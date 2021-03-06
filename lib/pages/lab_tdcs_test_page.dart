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
import 'dart:js' as js;
import 'package:intl/intl.dart';
import '../main.dart';

void playAudio(String path) {
  js.context.callMethod('playAudio', [path]);
// not on the web so we must use a mobile/desktop library...
}

class LabTDCSTestPage extends StatelessWidget {
  static const String testRoute = '/tDCS-3-back/test';

  Test test;

  LabTDCSTestPage({required this.test});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: new CommonPageBgWidget(
                content: new LabTestPageContentWidget(
                    test:
                        test))) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class LabTestPageContentWidget extends StatefulWidget {
  late Test test;

  LabTestPageContentWidget({required this.test});

  @override
  State<StatefulWidget> createState() {
    return new _LabTestPageContentWidgetState(test);
  }
}

class LetterShowEvent {
  String? letter;
  int? letterAppearTime;
  int? actionTime;
  String? action = "";
  String? userResult;
  String? isBack;

  @override
  String toString() {
    return 'LetterShowEvent{userResult: $userResult}';
  }
}

class _LabTestPageContentWidgetState extends State<LabTestPageContentWidget> {
  late Test test;
  late String firstSpecialLetter;
  late String secondSpecialLetter;
  late List<String> letters;

  _LabTestPageContentWidgetState(Test test) {
    this.test = test;
  }

  late var showLetterEventList = <LetterShowEvent>[];
  late var isFirstIn = true;
  late var isShowLetter = false;
  Color clickResultColor = Colors.grey;
  late var alreadyShowLetterCount = 0;
  late Timer showTextTimer;
  late Timer hideTextTimer;
  late int _textShowTime = 3000;
  late int _textHideTime = 500;
  late int _textTotalCount = 60;
  late int _backStep = 3;
  late double _backRate = 0.25;
  late int _breakTime = 60;
  late int _testCount = 6;
  late List<String> _sourceLetters = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L"
  ];
  late String _testStartTime = "";
  late var isTestEnd = false;
  late String _user = "";
  late String _labId = "";
  late String _fileName = "";
  late bool isFlushPrepare = true;
  late int prepareCount = 4;
  late bool isPress = false;

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initConfig();
    showLetterEventList.clear();
  }

  void _initFileName() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd_HH:mm:ss');
    String startTime = formatter.format(now);
    _fileName = "${_user}_${startTime}";
  }

  void _initConfig() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var textShowTimeStr =
        preferences.getString("textShowTime_${test.testType}");
    var textHideTimeStr =
        preferences.getString("textHideTime_${test.testType}");
    var textTotalCountStr =
        preferences.getString("textTotalCount_${test.testType}");
    var lettersStr = preferences.getString("letters_${test.testType}");
    var backStepStr = preferences.getString("backStep_${test.testType}");
    var backRate = preferences.getString("backRate_${test.testType}");
    var breakTime = preferences.getString("breakTime_${test.testType}");
    var testCount = preferences.getString("testCount_${test.testType}");
    if (textShowTimeStr != "") {
      _textShowTime = int.parse(textShowTimeStr);
    }
    if (textHideTimeStr != "") {
      _textHideTime = int.parse(textHideTimeStr);
    }
    if (textTotalCountStr != "") {
      _textTotalCount = int.parse(textTotalCountStr);
    }
    if (lettersStr != "") {
      _sourceLetters = lettersStr.split(",");
    }
    if (backStepStr != "") {
      _backStep = int.parse(backStepStr);
    }
    if (backRate != "") {
      _backRate = double.parse(backRate);
    }
    if (breakTime != "") {
      _breakTime = int.parse(breakTime);
    }
    if (testCount != "") {
      _testCount = int.parse(testCount);
    }

    _user = preferences.getString("user");
    _labId = preferences.getString("labId");
    _initFileName();
  }

  void _initLetters() {
    letters = RandomLettersGenUtil.getRandomTDCS3BackLetters(
        _sourceLetters, _textTotalCount, _backStep, _backRate);
  }

  void _showTestReadyCountText() {
    setState(() {
      isFlushPrepare = true;
      prepareCount--;
    });
    if (prepareCount > 0) {
      new Timer(new Duration(milliseconds: 1000), _showTestReadyCountText);
    } else {
      _startShowTestText();
    }
  }

  void _startShowTestText() {
    _initLetters();
    alreadyShowLetterCount = 0;
    isFlushPrepare = false;
    _hideText();
  }

  void _startText() {
    _showTestReadyCountText();
  }

  void _showText() {
    alreadyShowLetterCount++;
    if (alreadyShowLetterCount >= _textTotalCount) {
      showTextTimer.cancel();
      if (breakCount < _testCount - 1) {
        new Timer(new Duration(milliseconds: _textShowTime),
            _startShowBreakCountText);
      } else {
        new Timer(new Duration(milliseconds: _textShowTime), _endTest);
      }
    } else {
      showTextTimer =
          new Timer(new Duration(milliseconds: _textShowTime), _hideText);
    }
    setState(() {
      isPress = false;
      isShowLetter = true;
    });
  }

  void _hideText() {
    hideTextTimer =
        new Timer(new Duration(milliseconds: _textHideTime), _showText);
    setState(() {
      isShowLetter = false;
    });
  }

  void _endTest() {
    setState(() {
      isTestEnd = true;
    });
  }

  int breakCount = 0;
  late Timer breakTimer;
  bool isBreak = false;
  late int currentSecond;

  void _startShowBreakCountText() {
    currentSecond = _breakTime;
    isBreak = true;
    _showTimerCount();
  }

  void _showTimerCount() {
    if (currentSecond == _breakTime) {
      breakCount++;
    }
    if (currentSecond == 0) {
      breakTimer.cancel();
      if (breakCount < 6) {
        isBreak = false;
        _startShowTestText();
      }
    } else {
      setState(() {
        currentSecond--;
        breakTimer =
            new Timer(new Duration(milliseconds: 1000), _showTimerCount);
      });
    }
  }

  void _handleLetterEventList() {
    for (int i = 0; i < showLetterEventList.length - 1; i++) {
      if (showLetterEventList[i].action == "") {
        showLetterEventList[i].userResult = "OVERTIME";
      }
    }
  }

  String _initCsvText() {
    List<List<dynamic>> rows = <List<dynamic>>[];
    List<dynamic> userTitleRow = [];
    userTitleRow.add("id");
    userTitleRow.add("user");
    userTitleRow.add("start_time");
    rows.add(userTitleRow);
    List<dynamic> userContentRow = [];
    userContentRow.add(_labId);
    userContentRow.add(_user);
    userContentRow.add(_testStartTime);
    rows.add(userContentRow);
    rows.add(<dynamic>[]);
    List<dynamic> row = [];
    row.add("letter");
    row.add("action");
    row.add("user_result");
    row.add("is_back");
    row.add("appear_time");
    row.add("action_time");
    row.add("reaction_time");
    rows.add(row);
    for (int i = 0; i < showLetterEventList.length; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = [];
      row.add(showLetterEventList[i].letter);
      row.add(showLetterEventList[i].action);
      row.add(showLetterEventList[i].userResult);
      row.add(showLetterEventList[i].isBack);
      row.add(showLetterEventList[i].letterAppearTime);
      row.add(showLetterEventList[i].actionTime);
      var reactionTime;
      if (showLetterEventList[i].actionTime != null) {
        reactionTime = showLetterEventList[i].actionTime!! -
            showLetterEventList[i].letterAppearTime!!;
      }
      row.add(reactionTime);
      rows.add(row);
    }

    rows.add(<dynamic>[]);

    late var correctCount = 0;
    late var hitCount = 0;
    late var falseAlarmCount = 0;
    late var reactionTimeNotNullCount = 0;
    late int reactionTimeSum = 0;
    for (int i = 0; i < showLetterEventList.length; i++) {
      if (showLetterEventList[i].userResult == "TRUE") {
        correctCount++;
      }
      if (showLetterEventList[i].userResult == "TRUE" &&
          showLetterEventList[i].isBack == "TRUE") {
        hitCount++;
      }
      if ((showLetterEventList[i].action == "m" ||
              showLetterEventList[i].action == "M") &&
          showLetterEventList[i].isBack == "FALSE") {
        falseAlarmCount++;
      }
      if (showLetterEventList[i].actionTime != null &&
          showLetterEventList[i].actionTime != 0) {
        reactionTimeNotNullCount++;
        reactionTimeSum = reactionTimeSum +
            (showLetterEventList[i].actionTime!! -
                showLetterEventList[i].letterAppearTime!!);
      }
    }

    var correctRate =
        (correctCount * 1.0 / showLetterEventList.length * 1000).toInt() / 1000;
    var hitRate =
        (hitCount * 1.0 / (showLetterEventList.length * _backRate) * 1000)
                .toInt() /
            1000;
    var falseAlarmRate = (falseAlarmCount *
                1.0 /
                (showLetterEventList.length * (1 - _backRate)) *
                1000)
            .toInt() /
        1000;
    var avgReactionTime =
        (reactionTimeSum * 1.0 / reactionTimeNotNullCount * 1000).toInt() /
            1000;
    List<dynamic> statistics = [];
    statistics.add("ACC回答准确率");
    statistics.add("命中率");
    statistics.add("误判率");
    statistics.add("平均反应时间");
    rows.add(statistics);
    List<dynamic> statisticsContent = [];
    statisticsContent.add(correctRate);
    statisticsContent.add(hitRate);
    statisticsContent.add(falseAlarmRate);
    statisticsContent.add(avgReactionTime);
    rows.add(statisticsContent);
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
    html.document.body?.children.add(anchor);

    // download
    anchor.click();

    // cleanup
    html.document.body?.children.remove(anchor);
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
      _startText();
      var now = DateTime.now();
      _testStartTime =
          "${now.month}/${now.day}/${now.year} ${now.hour}:${now.minute}";
      isFirstIn = false;
    }
    String showLetter = "";
    if (isFlushPrepare) {
      showLetter = "$prepareCount";
      clickResultColor = Colors.transparent;
    } else {
      if (isBreak) {
        showLetter = "${currentSecond}";
        clickResultColor = Colors.transparent;
      } else {
        if (isShowLetter) {
          showLetter = letters[alreadyShowLetterCount - 1];
          if (!isPress) {
            clickResultColor = Colors.grey;
            LetterShowEvent letterShowEvent = new LetterShowEvent();
            letterShowEvent.letter = showLetter;
            letterShowEvent.userResult = "TRUE_0";
            letterShowEvent.letterAppearTime =
                DateTime.now().millisecondsSinceEpoch;
            if (alreadyShowLetterCount > _backStep) {
              if (showLetter ==
                  letters[alreadyShowLetterCount - 1 - _backStep]) {
                letterShowEvent.isBack = "TRUE";
              } else {
                letterShowEvent.isBack = "FALSE";
              }
            } else {
              letterShowEvent.isBack = "FALSE";
            }
            showLetterEventList.add(letterShowEvent);
          }
        } else {
          clickResultColor = Colors.transparent;
          showLetter = "";
        }
      }
    }

    return new RawKeyboardListener(
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent && event.data is RawKeyEventDataWeb) {
          if ((event.data.keyLabel == "m" ||
                  event.data.keyLabel == "n" ||
                  event.data.keyLabel == "M" ||
                  event.data.keyLabel == "N") &&
              !isFlushPrepare &&
              !isPress) {
            isPress = true;
            showLetterEventList[
                    (breakCount * letters.length) + alreadyShowLetterCount - 1]
                .action = "${event.data.keyLabel.toUpperCase()}";
            showLetterEventList[
                    (breakCount * letters.length) + alreadyShowLetterCount - 1]
                .actionTime = DateTime.now().millisecondsSinceEpoch;
            if (alreadyShowLetterCount > _backStep) {
              if (letters[alreadyShowLetterCount - 1 - _backStep] ==
                          showLetter &&
                      (event.data.keyLabel == "m" ||
                          event.data.keyLabel == "M") ||
                  letters[alreadyShowLetterCount - 1 - _backStep] !=
                          showLetter &&
                      (event.data.keyLabel == "n" ||
                          event.data.keyLabel == "N")) {
                showLetterEventList[(breakCount * letters.length) +
                        alreadyShowLetterCount -
                        1]
                    .userResult = "TRUE";
                setState(() {
                  clickResultColor = Colors.green;
                });
              } else {
                showLetterEventList[(breakCount * letters.length) +
                        alreadyShowLetterCount -
                        1]
                    .userResult = "FALSE";
                setState(() {
                  clickResultColor = Colors.red;
                });
              }
            } else {
              if ((event.data.keyLabel == "m" || event.data.keyLabel == "M")) {
                showLetterEventList[(breakCount * letters.length) +
                        alreadyShowLetterCount -
                        1]
                    .userResult = "FALSE";
                setState(() {
                  clickResultColor = Colors.red;
                });
              } else {
                showLetterEventList[(breakCount * letters.length) +
                        alreadyShowLetterCount -
                        1]
                    .userResult = "TRUE";
                setState(() {
                  clickResultColor = Colors.green;
                });
              }
            }
          }
        }
        // }
      },
      focusNode: focusNode,
      child: new ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              child: Center(
                  child: Container(
                width: 250,
                child: Column(
                  children: [
                    new Expanded(child: Container()),
                    new Container(
                      decoration: BoxDecoration(color: clickResultColor),
                      height: 50,
                    ),
                    Text(
                      showLetter,
                      style: TextStyle(color: Colors.white, fontSize: 180),
                    ),
                    new Container(
                      decoration: BoxDecoration(color: clickResultColor),
                      height: 50,
                    ),
                    new Expanded(child: Container())
                  ],
                ),
              )),
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
                    Navigator.pushNamed(context, "/${test.testType}/rule",
                        arguments: test);
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
            ),
            Positioned(
              left: ScreenUtils.calWidthInScreen(context, 96),
              bottom: ScreenUtils.calHeightInScreen(context, 40),
              child: Container(
                width: 178,
                height: 60,
                child: Row(
                  children: <Widget>[
                    new Expanded(child: Container()),
                    Padding(
                      padding: new EdgeInsets.only(left: 16),
                      child: Text(
                        "${_backStep}-back",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                    new Expanded(child: Container())
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
