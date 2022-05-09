import 'dart:async';

import 'package:ambicare_user/components/app_drawer.dart';
import 'package:ambicare_user/components/waiting_dialog.dart';
import 'package:ambicare_user/constants/constants.dart';
import 'package:ambicare_user/main.dart';
import 'package:ambicare_user/models/request.dart';
import 'package:ambicare_user/screens/maps_page.dart';
import 'package:ambicare_user/screens/signup_screen.dart';
import 'package:ambicare_user/services/database.dart';
import 'package:ambicare_user/services/location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Requests extends StatelessWidget {
  static const String id = "/request";
  const Requests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   child: GestureDetector(
        //     onTap: () {},
        //     child: const Icon(
        //       Icons.refresh,
        //     ),
        //   ),
        //   backgroundColor: kDarkRedColor,
        //   onPressed: () {
        //     Authentication.signOut();
        //   },
        // ),
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text('Request'),
          // title: const Text('Profile'),
          centerTitle: true,
          backgroundColor: kDarkRedColor,
          foregroundColor: kWhite,
        ),
        backgroundColor: Colors.white,
        body: UserRequests(),
      ),
    );
  }
}

class UserRequests extends StatefulWidget {
  @override
  State<UserRequests> createState() => _UserRequestsState();
}

class _UserRequestsState extends State<UserRequests> {
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
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 20.0,
        right: 20.0,
      ),
      child: FutureBuilder<Map<String, dynamic>>(
        future: Database.getRequest(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'You have no requests',
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
          final request = Request.fromData(data: snapshot.data!);
          // return Center(
          // child:
          return Container(
            margin: const EdgeInsets.only(bottom: 30.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                // color: const Color(0xFF18171A),
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
                          showDialog(
                            context: context,
                            builder: (context) =>
                                const WaitingDialog(title: "Processing"),
                          );
                          Position position;
                          try {
                            position = await Location.determinePosition();
                          } catch (ex) {
                            navigatorKey.currentState!.pop();
                            return showSnackBar(
                              context,
                              ex.toString(),
                              Colors.red,
                            );
                          }
                          navigatorKey.currentState!.pop();
                          navigatorKey.currentState!.pushNamed(
                            MapsPage.id,
                            arguments: {
                              "id": request.id,
                              "pickUpLocation": request.pickUpLocation,
                              "destination": request.destination,
                              "isPending": request.isPending,
                              "ambulance": request.ambulance,
                              "amb_id": request.id,
                              "requestedBy": request.requestedBy,
                              "requestedTo": request.requestedTo,
                              "my_location": {
                                "longitude": position.longitude,
                                "latitude": position.latitude,
                              }
                            },
                          );
                        },
                        color: Colors.white,
                        icon: Icons.location_on_outlined,
                      ),
                      // const SizedBox(
                      //   width: ,
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          );
          // );
        },
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
