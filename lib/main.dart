import 'package:enterlabs/ScreenUtls.dart';
import 'package:enterlabs/pages/lab_config_page.dart';
import 'package:enterlabs/pages/lab_rules_page.dart';
import 'package:enterlabs/pages/lab_start_page.dart';
import 'package:enterlabs/pages/lab_test_page.dart';
import 'package:enterlabs/pages/user_info_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Test {
  static String TEST_ATTENTION_LETTER = "AX-CPT";
  static String TEST_ATTENTION_AUDIO = "Auditory-CPT";
  String testType;

  Test(this.testType);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'enterlabs',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        "/AX-CPT": (context) => LabStartPage(test: new Test(Test.TEST_ATTENTION_LETTER)),
        "/AX-CPT/info": (context) =>
            UserInfoPage(test: new Test(Test.TEST_ATTENTION_LETTER)),
        "/AX-CPT/rule": (context) =>
            LabRulesPage(test: new Test(Test.TEST_ATTENTION_LETTER)),
        "/AX-CPT/test": (context) =>
            LabTestPage(test: new Test(Test.TEST_ATTENTION_LETTER)),
        "/AX-CPT/config": (context) =>
            LabConfigPage(test: new Test(Test.TEST_ATTENTION_LETTER)),
        "/Auditory-CPT": (context) =>
            LabStartPage(test: new Test(Test.TEST_ATTENTION_AUDIO)),
        "/Auditory-CPT/info": (context) =>
            UserInfoPage(test: new Test(Test.TEST_ATTENTION_AUDIO)),
        "/Auditory-CPT/rule": (context) =>
            LabRulesPage(test: new Test(Test.TEST_ATTENTION_AUDIO)),
        "/Auditory-CPT/test": (context) =>
            LabTestPage(test: new Test(Test.TEST_ATTENTION_AUDIO)),
        "/Auditory-CPT/config": (context) =>
            LabConfigPage(test: new Test(Test.TEST_ATTENTION_AUDIO))
      },
      home: HomePage(),
    );
  }
}

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
  }) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: new Center(
      child: new Container(
          child: new Row(
        children: <Widget>[
          new Expanded(child: Container()),
          new Column(
            children: <Widget>[
              Padding(
                child: new Text(
                  "实验选择",
                  style: new TextStyle(fontSize: 56),
                ),
                padding: new EdgeInsets.only(
                    bottom: ScreenUtils.calHeightInScreen(context, 96),
                    top: ScreenUtils.calHeightInScreen(context, 48)),
              ),
              new Row(
                children: <Widget>[
                  new SelectLabWidget(
                    labBigName: "AX-CPT",
                    labName: "注意力实验",
                    labBigNameTextSize: 48,
                    onButtonPress: () {
                      Navigator.pushNamed(context, "/AX-CPT");
//                      Navigator.push(
//                        context,
//                        new MaterialPageRoute(
//                          settings: RouteSettings(name: "/AX-CPT"),
//                            builder: (context) => new LabStartPage()),
//                      );
                    },
                  ),
                  Padding(
                      padding: new EdgeInsets.only(
                          left: ScreenUtils.calWidthInScreen(context, 48)),
                      child: new SelectLabWidget(
                        labName: "听觉CPT实验",
                        labBigName: "Auditory-CPT",
                        labBigNameTextSize: 24,
                        onButtonPress: () {
                          Navigator.pushNamed(context, "/Auditory-CPT");
                        },
                      )),
                  Padding(
                      padding: new EdgeInsets.only(
                          left: ScreenUtils.calWidthInScreen(context, 48)),
                      child: new SelectLabWidget(
                        labBigName: "AX-CPT",
                        labName: "未开放",
                        labBigNameTextSize: 48,
                      ))
                ],
              ),
              Padding(
                padding: new EdgeInsets.only(
                    top: ScreenUtils.calHeightInScreen(context, 48)),
                child: new Row(
                  children: <Widget>[
                    new SelectLabWidget(
                      labName: "未开放",
                      labBigName: "AX-CPT",
                      labBigNameTextSize: 48,
                    ),
                    Padding(
                        padding: new EdgeInsets.only(
                            left: ScreenUtils.calWidthInScreen(context, 48)),
                        child: new SelectLabWidget(
                          labName: "未开放",
                          labBigName: "AX-CPT",
                          labBigNameTextSize: 48,
                        )),
                    Padding(
                        padding: new EdgeInsets.only(
                            left: ScreenUtils.calWidthInScreen(context, 48)),
                        child: new SelectLabWidget(
                          labName: "未开放",
                          labBigName: "AX-CPT",
                          labBigNameTextSize: 48,
                        ))
                  ],
                ),
              )
            ],
          ),
          new Expanded(child: Container())
        ],
      )),
    )) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

//showAlertDialog(BuildContext context, String text) {
//  // set up the button
//  Widget okButton = FlatButton(
//    child: Text("OK"),
//    onPressed: () {},
//  );
//
//  // set up the AlertDialog
//  AlertDialog alert = AlertDialog(
//    title: Text(text),
//    content: Text("This is my message."),
//    actions: [
//      okButton,
//    ],
//  );
//
//  // show the dialog
//  showDialog(
//    context: context,
//    builder: (BuildContext context) {
//      return alert;
//    },
//  );
//}

class SelectLabWidget extends StatelessWidget {
  SelectLabWidget(
      {this.labName,
      this.labBigName,
      this.labBigNameTextSize,
      this.onButtonPress});

  final String labName;
  String labBigName = "--";
  double labBigNameTextSize;
  final VoidCallback onButtonPress;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: RaisedButton(
          padding: EdgeInsets.all(0),
          onPressed: onButtonPress,
          child: new Column(
            children: <Widget>[
              new Expanded(
                child: new Container(
                  child: new Center(
                    child: Text(
                      labBigName,
                      style: new TextStyle(
                          color: Colors.white, fontSize: labBigNameTextSize),
                    ),
                  ),
                  color: const Color(0xff00517D),
                ),
              ),
              new Container(
                  child: new Center(
                    child: Text(labName, style: new TextStyle(fontSize: 24)),
                  ),
                  height: ScreenUtils.calHeightInScreen(context, 71),
                  color: Colors.white),
            ],
          )),
      width: (MediaQuery.of(context).size.width) * 0.2,
      height: ScreenUtils.calHeightInScreen(context, 222),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(20, 4, 4, 4),
            spreadRadius: 4,
            blurRadius: 20,
            offset: Offset(20, 20), // changes position of shadow
          ),
        ],
      ),
    );
  }
}
