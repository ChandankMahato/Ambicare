import 'package:ambicare_user/components/custom_button.dart';
import 'package:ambicare_user/components/waiting_dialog.dart';
import 'package:ambicare_user/constants/constants.dart';
import 'package:ambicare_user/main.dart';
import 'package:ambicare_user/models/ambulance.dart';
import 'package:ambicare_user/screens/signup_screen.dart';
import 'package:ambicare_user/services/database.dart';
import 'package:ambicare_user/services/location.dart';
import 'package:ambicare_user/services/notification.dart';
import 'package:flutter/material.dart';

class RequestDetailsDialog extends StatefulWidget {
  final Ambulance amb;
  final List? dropLocation;

  const RequestDetailsDialog(
      {Key? key, required this.amb, required this.dropLocation})
      : super(key: key);

  @override
  State<RequestDetailsDialog> createState() => _RequestDetailsDialogState();
}

class _RequestDetailsDialogState extends State<RequestDetailsDialog> {
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
      height: 400,
      decoration: const BoxDecoration(
        color: kLightRedColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      child: Column(
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
                children: const [
                  RequestDetails(text: 'RegNo'),
                  RequestDetails(text: 'Type'),
                  RequestDetails(text: 'farePerKm'),
                  RequestDetails(text: 'Driver'),
                  RequestDetails(text: 'Driver Phone'),
                  RequestDetails(text: 'Service'),
                  RequestDetails(text: 'Service Phone'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RequestDetails(
                      text: widget.amb.registrationNumber.toString()),
                  RequestDetails(text: widget.amb.type.toString()),
                  RequestDetails(text: widget.amb.farePerKm.toString()),
                  RequestDetails(text: widget.amb.driver["name"].toString()),
                  RequestDetails(
                      text: widget.amb.driver["phoneNumber"].toString()),
                  RequestDetails(
                      text: widget.amb.ownedBy["ambulanceService"].toString()),
                  RequestDetails(
                      text: widget.amb.ownedBy["phoneNumber"].toString()),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                NewCustomButton(
                  onPressed: () async {
                    navigatorKey.currentState!.pop();
                  },
                  width: 80,
                  height: 40,
                  buttonTitle: 'Cancel',
                  color: kWhite,
                  textColor: kLightRedColor,
                ),
                NewCustomButton(
                  onPressed: () async {
                    // if (formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      builder: (context) => const WaitingDialog(
                        title: "Sending Request",
                      ),
                    );
                    final pickupPostion = await Location.determinePosition();
                    print(widget.amb.driver);
                    final data = {
                      "isPending": true,
                      "pickupLocation": {
                        "longitude": pickupPostion.longitude,
                        "latitude": pickupPostion.latitude,
                      },
                      "destination": widget.dropLocation!.isEmpty
                          ? {}
                          : {
                              "longitude": widget.dropLocation![0],
                              "latitude": widget.dropLocation![1],
                            },
                      "requestedTo": {
                        "ambulanceService": widget.amb.ownedBy["_id"],
                        "driver": widget.amb.driver["_id"]
                      },
                      "ambulanceRegNo": widget.amb.registrationNumber,
                    };
                    final result = await Database.sendRequest(data);
                    if (result! ~/ 100 == 2) {
                      navigatorKey.currentState!.pop();
                      showSnackBar(
                        context,
                        "Request Sent Successfully",
                        Colors.green,
                      );
                      // TODO: await halna man lagena paxi man lage haldinxu
                      final token = await Database.getDriversToken(
                        widget.amb.driver["_id"],
                      );
                      if (token["token"] != null) {
                        NotificationHandler.sendNotification(
                          body: "You have a new request",
                          title: "New Request",
                          token: token["token"],
                        );
                      }
                      setState(() {});
                    } else if (result == 400) {
                      navigatorKey.currentState!.pop();
                      showSnackBar(
                        context,
                        "You already have a pending request",
                        Colors.red,
                      );
                    } else {
                      navigatorKey.currentState!.pop();
                      showSnackBar(
                        context,
                        "Request could not be sent",
                        Colors.red,
                      );
                    }
                    navigatorKey.currentState!.pop();
                    // navigatorKey.currentState!.pushNamed(routeName);
                  },
                  // },
                  width: 80,
                  height: 40,
                  buttonTitle: 'Confirm',
                  color: Colors.green,
                  textColor: kWhite,
                ),
              ],
            ),
          )
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
