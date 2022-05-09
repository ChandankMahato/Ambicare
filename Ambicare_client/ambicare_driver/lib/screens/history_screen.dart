import 'dart:async';

import 'package:ambicare_driver/components/continue_dialog.dart';
import 'package:ambicare_driver/components/custom_button.dart';
import 'package:ambicare_driver/components/custom_text_field.dart';
import 'package:ambicare_driver/components/waiting_dialog.dart';
import 'package:ambicare_driver/constants/constants.dart';
import 'package:ambicare_driver/main.dart';
import 'package:ambicare_driver/model/request.dart';
import 'package:ambicare_driver/screens/maps_screen.dart';
import 'package:ambicare_driver/screens/requests_page.dart';
import 'package:ambicare_driver/screens/signin_screen.dart';
import 'package:ambicare_driver/services/auth.dart';
import 'package:ambicare_driver/services/database.dart';
import 'package:ambicare_driver/services/location.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('History'),
          // title: const Text('Profile'),
          centerTitle: true,
          backgroundColor: kDarkRedColor,
          foregroundColor: kWhite,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            left: 20.0,
            right: 20.0,
          ),
          child: FutureBuilder<List>(
            future: Database.getDriverHistory(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'You have no history',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Network Error!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                );
              }
              final requests = snapshot.data!;

              return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = Request.fromData(data: requests[index]);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 30.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: kDarkRedColor,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              spreadRadius: 5.0,
                              offset: Offset(7, 7),
                            ),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          right: 10.0,
                          left: 10.0,
                          bottom: 10.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Name: ${request.requestedBy["name"]}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontFamily: "Ubuntu",
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12.0,
                                    ),
                                    Text(
                                      "Phone: ${request.requestedBy["phoneNumber"]}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontFamily: "Ubuntu",
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12.0,
                                    ),
                                    Text(
                                      "Ambulance: ${request.ambulance["registrationNumber"]}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontFamily: "Ubuntu",
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12.0,
                                    ),
                                    Text(
                                      "Driver: ${request.requestedTo["driverName"]}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontFamily: "Ubuntu",
                                      ),
                                    ),
                                  ],
                                ),
                                iconButton(
                                  onTap: () async {
                                    // showDialog(
                                    //   context: context,
                                    //   builder: (context) => Column(
                                    //     mainAxisSize: MainAxisSize.min,
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.center,
                                    //     children: const [
                                    //       CircularProgressIndicator(
                                    //         color: Colors.white,
                                    //         backgroundColor: Colors.black,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // );
                                    showDialog(
                                      context: context,
                                      builder: (context) => const WaitingDialog(
                                          title: "Processing"),
                                    );
                                    ambulanceMarker =
                                        await BitmapDescriptor.fromAssetImage(
                                      const ImageConfiguration(),
                                      "images/marker-red.png",
                                    );
                                    navigatorKey.currentState!.pop();
                                    await navigatorKey.currentState!.pushNamed(
                                      MapsPage.id,
                                      arguments: {
                                        "id": request.id,
                                        "pickUpLocation":
                                            request.pickUpLocation,
                                        "destination": request.destination,
                                        "isPending": request.isPending,
                                        "ambulance": request.ambulance,
                                        "amb_id": request.id,
                                        "requestedBy": request.requestedBy,
                                        "requestedTo": request.requestedTo,
                                      },
                                    );
                                  },
                                  color: Colors.white,
                                  icon: Icons.location_on_outlined,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
              // );
            },
          ),
        ),
      ),
    );
  }

  iconButton({
    VoidCallback? onTap,
    Color? color,
    IconData? icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(
            Radius.circular(
              16.0,
            ),
          ),
        ),
        child: Icon(
          // Icons.cancel,
          icon,
          color: kDarkRedColor,
        ),
      ),
    );
  }
}
