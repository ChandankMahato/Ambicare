import 'package:ambicare_service/components/custom_button.dart';
import 'package:ambicare_service/constants/constants.dart';
import 'package:flutter/material.dart';

Widget continueDialog({
  String? title,
  String? message,
  String? yesContent,
  String? noContent,
  VoidCallback? onYes,
  VoidCallback? onNo,
}) {
  return SizedBox(
    height: 100,
    child: AlertDialog(
      titlePadding: const EdgeInsets.only(
        top: 15.0,
        // bottom: 10.0,
        left: 24.0,
        right: 24.0,
      ),
      contentPadding: const EdgeInsets.only(
        top: 15.0,
        // bottom: 10.0,
        left: 24.0,
        right: 24.0,
      ),
      actionsPadding: const EdgeInsets.only(
        // top: 20.0,
        bottom: 10.0,
        // left: 24.0,
        // right: 24.0,
      ),
      backgroundColor: Colors.white,
      title: Text(
        title!,
        style: const TextStyle(
          fontFamily: 'Ubuntu',
          fontSize: 24,
        ),
      ),
      content: Text(
        message!,
        style: const TextStyle(
          fontFamily: 'Ubuntu',
          fontSize: 20,
        ),
      ),
      actions: [
        NewCustomButton(
          onPressed: onYes!,
          width: 100,
          height: 40,
          buttonTitle: yesContent!,
          color: kWhite,
          textColor: kDarkRedColor,
          border: true,
          boldText: false,
        ),
        NewCustomButton(
          onPressed: onNo!,
          width: 80,
          height: 40,
          buttonTitle: noContent!,
          color: kLightRedColor,
          textColor: kWhite,
          boldText: false,
          border: false,
        ),
        const SizedBox(
          height: 20.0,
        ),
      ],
    ),
  );
}
