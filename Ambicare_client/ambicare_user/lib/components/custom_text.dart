import 'package:flutter/cupertino.dart';

class CustomTextStyle extends StatelessWidget {
  final String text;
  final Color textColor;
  const CustomTextStyle({Key? key, required this.text, required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child:
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontFamily: 'Ubuntu',
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
    // );
  }
}
