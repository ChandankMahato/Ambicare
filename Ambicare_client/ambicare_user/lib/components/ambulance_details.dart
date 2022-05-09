import 'package:ambicare_user/constants/constants.dart';
import 'package:flutter/material.dart';

class AmbulanceDetails extends StatelessWidget {
  final Map<String, dynamic> amb;
  final Map<String, dynamic> otherDetails;

  AmbulanceDetails({Key? key, required this.amb, required this.otherDetails})
      : super(key: key);

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
                children: const [
                  RequestDetails(text: 'RegNo: '),
                  RequestDetails(text: 'Type: '),
                  RequestDetails(text: 'farePerKm: '),
                  RequestDetails(text: 'Driver: '),
                  RequestDetails(text: 'Driver Phone: '),
                  RequestDetails(text: 'Service: '),
                  RequestDetails(text: 'Service Phone: '),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RequestDetails(text: amb["registrationNumber"].toString()),
                  RequestDetails(text: amb["type"].toString()),
                  RequestDetails(text: amb["farePerKm"].toString()),
                  RequestDetails(text: otherDetails["driverName"].toString()),
                  RequestDetails(
                      text: otherDetails["driverPhoneNumber"].toString()),
                  RequestDetails(
                      text: otherDetails["ambulanceService"].toString()),
                  RequestDetails(
                      text: otherDetails["servicePhoneNumber"].toString()),
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
