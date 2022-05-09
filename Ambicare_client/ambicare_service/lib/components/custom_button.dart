import 'package:ambicare_service/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double width;
  final Widget buttonContent;
  final Color buttonColor;
  final bool border;
  final double borderRadius;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.width,
    required this.buttonContent,
    this.buttonColor = kLightRedColor,
    this.border = false,
    this.borderRadius = 30.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: size.height * 0.07,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: border ? Border.all(color: Colors.blue[400]!) : null,
          boxShadow: [
            BoxShadow(
              color: kGreyColor.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(5, 10),
            ),
          ],
        ),
        child: Center(
          child: buttonContent,
        ),
      ),
    );
  }
}

class CustomButtonGray extends StatelessWidget {
  final VoidCallback onPressed;
  final double width;
  final Widget buttonContent;

  const CustomButtonGray({
    Key? key,
    required this.onPressed,
    required this.width,
    required this.buttonContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: size.height * 0.07,
        decoration: BoxDecoration(
          color: kGreyColor,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: kGreyColor.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(5, 10),
            ),
          ],
        ),
        child: Center(
          child: buttonContent,
        ),
      ),
    );
  }
}

class NewCustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double width;
  final double height;
  final String buttonTitle;
  final Color color, textColor;
  final bool boldText;
  final bool border;
  const NewCustomButton({
    Key? key,
    required this.onPressed,
    required this.width,
    required this.height,
    required this.buttonTitle,
    required this.color,
    required this.textColor,
    this.border = false,
    this.boldText = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(5),
        width: width,
        height: height,
        margin: const EdgeInsets.fromLTRB(10, 13, 10, 0),
        decoration: BoxDecoration(
          color: color,
          border: border
              ? Border.all(
                  color: kDarkRedColor,
                )
              : null,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(4, 4),
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            buttonTitle,
            style: TextStyle(
              color: textColor,
              fontWeight: boldText ? FontWeight.bold : FontWeight.normal,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
