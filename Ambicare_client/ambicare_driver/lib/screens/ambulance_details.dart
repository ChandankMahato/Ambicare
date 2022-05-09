import 'package:ambicare_driver/components/continue_dialog.dart';
import 'package:ambicare_driver/components/custom_button.dart';
import 'package:ambicare_driver/components/custom_text.dart';
import 'package:ambicare_driver/components/waiting_dialog.dart';
import 'package:ambicare_driver/constants/constants.dart';
import 'package:ambicare_driver/main.dart';
import 'package:ambicare_driver/model/ambulance.dart';
import 'package:ambicare_driver/model/driver.dart';
import 'package:ambicare_driver/screens/signin_screen.dart';
import 'package:ambicare_driver/services/auth.dart';
import 'package:ambicare_driver/services/database.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class AmbulanceDetails extends StatefulWidget {
  static const String id = '/AmbulanceDetails';
  const AmbulanceDetails({Key? key}) : super(key: key);

  @override
  State<AmbulanceDetails> createState() => _AmbulanceDetailsState();
}

class _AmbulanceDetailsState extends State<AmbulanceDetails> {
  @override
  void initState() {
    super.initState();
  }

  Ambulance? ambulance;

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
                    "Signout Successfully",
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
              width: 80,
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
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      // drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Ambulance Details'),
        // title: const Text('AmbulanceDetails'),
        centerTitle: true,
        backgroundColor: kDarkRedColor,
        foregroundColor: kWhite,
      ),
      body: ListView(
        children: [
          FutureBuilder<Map<String, dynamic>>(
            future: Database.getAmbulance(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                ambulance = Ambulance.fromData(data: snapshot.data!);
                return Column(children: [
                  IconTiles(
                    icon: EvaIcons.carOutline,
                    onTap: () {},
                    title: ambulance!.registrationNumber,
                  ),
                  IconTiles(
                    icon: Icons.arrow_forward,
                    onTap: () {},
                    title: ambulance!.type,
                  ),
                  IconTiles(
                    icon: Icons.payment,
                    onTap: () {},
                    title: "Rs. ${ambulance!.farePerKm}/km",
                  ),
                  IconTiles(
                    icon: Icons.local_hospital,
                    onTap: () {},
                    title: ambulance!.service,
                  ),
                  IconTiles(
                    icon: Icons.online_prediction,
                    onTap: () {},
                    title: ambulance!.isAvailable ? "Online" : "Offline",
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                    ),
                    child: NewCustomButton(
                      onPressed: () {
                        //TODO: change availability
                        showDialog(
                          context: navigatorKey.currentState!.overlay!.context,
                          builder: (builder) => continueDialog(
                              title: "Change Status",
                              message: "Are you sure you wish to continue?",
                              yesContent: "Change",
                              noContent: "Cancel",
                              onYes: () async {
                                navigatorKey.currentState!.pop();
                                showDialog(
                                  context: context,
                                  builder: (context) => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      CircularProgressIndicator(
                                        color: Colors.white,
                                        backgroundColor: Colors.black,
                                      ),
                                    ],
                                  ),
                                );
                                final result =
                                    await Database.changeAvailability(
                                        !ambulance!.isAvailable, ambulance!.id);
                                if (result! ~/ 100 == 2) {
                                  navigatorKey.currentState!.pop();
                                  (ambulance!.isAvailable)
                                      ? showSnackBar(
                                          scaffoldKey.currentContext!,
                                          "The ambulance is now offline",
                                          Colors.green,
                                        )
                                      : showSnackBar(
                                          scaffoldKey.currentContext!,
                                          "The ambulance is now online",
                                          Colors.green,
                                        );
                                  setState(() {});
                                } else {
                                  navigatorKey.currentState!.pop();
                                  showSnackBar(
                                    context,
                                    "Ambulance availablity coulnot be changed",
                                    kLightRedColor,
                                  );
                                }
                              },
                              onNo: () {
                                navigatorKey.currentState!.pop();
                              }),
                        );
                      },
                      width: double.infinity,
                      height: 50.0,
                      buttonTitle: "Change Status",
                      color: kDarkRedColor,
                      textColor: Colors.white,
                      boldText: false,
                    ),
                  ),
                ]);
              } else {
                return Column(children: [
                  IconTiles(
                    icon: Icons.account_circle_outlined,
                    onTap: () {},
                    title: 'registration number',
                  ),
                  IconTiles(
                    icon: Icons.phone_android_rounded,
                    onTap: () {},
                    title: 'ambulance type',
                  ),
                  IconTiles(
                    icon: Icons.payment,
                    onTap: () {},
                    title: "fare per km",
                  ),
                  IconTiles(
                    icon: Icons.local_hospital,
                    onTap: () {},
                    title: "service",
                  ),
                  IconTiles(
                    icon: Icons.online_prediction,
                    onTap: () {},
                    title: "offline",
                  ),
                ]);
              }
            },
          ),
        ],
      ),
    );
  }
}

class IconTiles extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String title;
  const IconTiles(
      {Key? key, required this.icon, required this.onTap, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color.fromARGB(255, 180, 32, 37),
          size: 40.0,
        ),
        title: Center(
          child: CustomTextStyle(
            text: title,
            textColor: kDarkRedColor,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
