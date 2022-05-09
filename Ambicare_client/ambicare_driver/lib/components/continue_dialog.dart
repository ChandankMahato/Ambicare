import 'package:ambicare_driver/components/custom_button.dart';
import 'package:ambicare_driver/constants/constants.dart';
import 'package:ambicare_driver/main.dart';
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
          width: 80,
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

// Widget continueDialog({
//   String? title,
//   String? message,
//   VoidCallback? onYes,
//   VoidCallback? onNo,
// }) {
//   return Center(
//     child: Container(
//       padding: const EdgeInsets.all(10.0),
//       height: 150,
//       // width: MediaQuery.of(context).size.width * 0.7,
//       width: 280,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20.0),
//         color: Colors.white,
//       ),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
//         Flexible(
//           child: Text(
//             title!,
//             style: const TextStyle(
//               color: Colors.black,
//               fontSize: 25.0,
//             ),
//           ),
//         ),
//         const SizedBox(
//           height: 15.0,
//         ),
//         Flexible(
//           child: Text(
//             message!,
//             style: const TextStyle(
//               color: Colors.black,
//               fontSize: 16.0,
//             ),
//           ),
//         ),
//         const SizedBox(
//           height: 15.0,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             // Container(
//             //   padding: const EdgeInsets.all(5.0),
//             //   decoration: BoxDecoration(
//             //     color: Colors.black,
//             //     borderRadius: BorderRadius.circular(5.0),
//             //   ),
//             //   child: GestureDetector(
//             //     onTap: onYes,
//             //     child: const Text("Yes"),
//             //   ),
//             // ),
//             ElevatedButton(
//               onPressed: onYes,
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(
//                   Colors.black,
//                 ),
//               ),
//               child: Text("Yes"),
//             ),
//             ElevatedButton(
//               onPressed: onNo,
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(
//                   Colors.black,
//                 ),
//               ),
//               child: Text("No"),
//             ),
//           ],
//         ),
//       ]),
//     ),
//   );
// }
