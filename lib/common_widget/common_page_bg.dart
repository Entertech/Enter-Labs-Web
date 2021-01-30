import 'package:flutter/cupertino.dart';

class CommonPageBgWidget extends StatelessWidget {
  CommonPageBgWidget({required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff00517D), Color(0xff192E4C)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
          ),
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: Image(image: AssetImage("assets/icons/icon_page_bg.png")),
          ),
          Container(
            child: content,
          )
        ],
      ),
    );
  }
}
