import 'package:ambicare_service/constants/constants.dart';
import 'package:ambicare_service/main.dart';
import 'package:flutter/material.dart';

class CarInfo extends StatelessWidget {
  final String? regNo;
  final String? type;
  final bool? isAvailable;
  final String? driverName;
  final String? driverPhoneNumber;
  const CarInfo({
    Key? key,
    this.regNo,
    this.type,
    this.isAvailable,
    this.driverName,
    this.driverPhoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 15.0,
          left: 20.0,
          bottom: 15.0,
          right: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: Text(
                "Ambulance",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontFamily: "Ubuntu",
                ),
              ),
            ),
            const Center(
              child: SizedBox(
                width: 100.0,
                child: Divider(
                  thickness: 1.5,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              "Reg No: $regNo",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontFamily: "Ubuntu",
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              "Type: $type",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontFamily: "Ubuntu",
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              "Is Available: $isAvailable",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontFamily: "Ubuntu",
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              "Driver Name: $driverName",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontFamily: "Ubuntu",
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              "Driver Phone: $driverPhoneNumber",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontFamily: "Ubuntu",
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: kLightRedColor,
                ),
                onPressed: () {
                  navigatorKey.currentState!.pop();
                },
                child: const Text(
                  "Ok",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
