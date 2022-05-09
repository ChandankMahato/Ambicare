import 'package:ambicare_service/constants/constants.dart';
import 'package:flutter/material.dart';

class AmbulanceDetails extends StatelessWidget {
  final String? regNo;
  final String? type;
  final String? farePerKm;
  final String? driverName;
  final String? driverPhoneNumber;

  AmbulanceDetails({
    Key? key,
    required this.regNo,
    required this.type,
    required this.farePerKm,
    required this.driverName,
    required this.driverPhoneNumber,
  }) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) {
    return Container(
      // height: 400,
      padding: const EdgeInsets.only(
        bottom: 15.0,
      ),
      decoration: const BoxDecoration(
        color: kLightRedColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "images/splash.png",
                height: 100,
              ),
            ),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: kWhite,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const RequestDetails(text: 'RegNo: '),
                  const RequestDetails(text: 'Type: '),
                  const RequestDetails(text: 'farePerKm: '),
                  const RequestDetails(text: 'Driver: '),
                  driverName != null
                      ? const RequestDetails(text: 'Driver Phone: ')
                      : Container(),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RequestDetails(text: regNo.toString()),
                  RequestDetails(text: type.toString()),
                  RequestDetails(text: farePerKm.toString()),
                  driverName != null
                      ? RequestDetails(
                          text: driverName.toString(),
                        )
                      : const RequestDetails(
                          text: "No driver",
                        ),
                  driverName != null
                      ? RequestDetails(text: driverPhoneNumber.toString())
                      : Container(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RequestDetails extends StatelessWidget {
  final String text;

  const RequestDetails({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: "Ubuntu-Bold",
          fontSize: 16,
          color: kWhite,
        ),
      ),
    );
  }
}
