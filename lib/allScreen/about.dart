import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const colorizeTextStyle = TextStyle(
      fontSize: 35.0,
      fontFamily: 'Horizon',
    );

    const colorizeColors = [
      Colors.green,
      Colors.purple,
      Colors.pink,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text('About'),
        ),
        body: Container(
          child: AnimatedTextKit(animatedTexts: [
            ColorizeAnimatedText(
              'This App was developed by a third year Computer Science student as his Mini Project',
              textStyle: colorizeTextStyle,
              colors: colorizeColors,
            ),
          ]),
        ));
  }
}
