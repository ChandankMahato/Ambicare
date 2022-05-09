import 'package:ambicare_service/components/custom_button.dart';
import 'package:ambicare_service/components/waiting_dialog.dart';
import 'package:ambicare_service/constants/constants.dart';
import 'package:ambicare_service/main.dart';
import 'package:ambicare_service/models/request.dart';
import 'package:ambicare_service/screens/history_maps_screen.dart';
import 'package:ambicare_service/screens/maps_screen.dart';
import 'package:ambicare_service/screens/signin_screen.dart';
import 'package:ambicare_service/screens/signup_screen.dart';
import 'package:ambicare_service/services/auth.dart';
import 'package:ambicare_service/services/database.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

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

  Future<void> logoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SizedBox(
        height: 100,
        child: AlertDialog(
          titlePadding: const EdgeInsets.only(
            top: 10.0,
            // bottom: 10.0,
            left: 24.0,
            right: 24.0,
          ),
          contentPadding: const EdgeInsets.only(
            top: 20.0,
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
          title: const Text(
            'Are you sure?',
            style: TextStyle(
              fontFamily: 'Ubuntu',
              fontSize: 24,
            ),
          ),
          content: const Text(
            'Do you want to logout?',
            style: TextStyle(
              fontFamily: 'Ubuntu',
              fontSize: 20,
            ),
          ),
          actions: [
            NewCustomButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) => const WaitingDialog(
                    title: "Logging out",
                  ),
                );
                final result = await Authentication.signOut();
                if (result) {
                  navigatorKey.currentState!
                      .pushNamedAndRemoveUntil(Signin.id, (route) => false);
                  showSnackBar(
                    context,
                    "Signout Successful",
                    Colors.green,
                  );
                  // setState(() {});
                } else {
                  navigatorKey.currentState!.pop();
                  showSnackBar(
                    context,
                    "Couldnot signout",
                    Colors.green,
                  );
                }
              },
              width: 100,
              height: 40,
              buttonTitle: 'Log out',
              color: kWhite,
              textColor: kDarkRedColor,
              border: true,
              boldText: false,
            ),
            NewCustomButton(
              onPressed: () {
                navigatorKey.currentState!.pop();
              },
              width: 80,
              height: 40,
              buttonTitle: 'Cancel',
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Database.getServiceHistory();
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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  logoutDialog(navigatorKey.currentState!.overlay!.context);
                },
                child: const Icon(
                  EvaIcons.logOutOutline,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            left: 20.0,
            right: 20.0,
          ),
          child: FutureBuilder<List>(
            // service history
            future: Database.getServiceHistory(),
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
                                        fontSize: 16.0,
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
                                        fontSize: 16.0,
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

                                    navigatorKey.currentState!.pop();
                                    await navigatorKey.currentState!.pushNamed(
                                      HistoryMapsPage.id,
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
