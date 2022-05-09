import 'package:ambicare_user/components/custom_text.dart';
import 'package:ambicare_user/components/custom_button.dart';
import 'package:ambicare_user/components/waiting_dialog.dart';
import 'package:ambicare_user/constants/constants.dart';
import 'package:ambicare_user/main.dart';
import 'package:ambicare_user/screens/history_screen.dart';
import 'package:ambicare_user/screens/khalti_payment.dart';
import 'package:ambicare_user/screens/profile.dart';
import 'package:ambicare_user/screens/requests_screen.dart';
import 'package:ambicare_user/screens/signin_screen.dart';
import 'package:ambicare_user/screens/signup_screen.dart';
import 'package:ambicare_user/screens/user_home.dart';
import 'package:ambicare_user/screens/user_support.dart';
import 'package:ambicare_user/services/auth.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Future<void> logoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SizedBox(
        height: 100,
        child: AlertDialog(
          titlePadding: const EdgeInsets.only(
            top: 10.0,
            left: 24.0,
            right: 24.0,
          ),
          contentPadding: const EdgeInsets.only(
            top: 20.0,
            left: 24.0,
            right: 24.0,
          ),
          actionsPadding: const EdgeInsets.only(
            bottom: 10.0,
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
    return Drawer(
      child: ListView(
        children: [
          AppBar(
            backgroundColor: kDarkRedColor,
            foregroundColor: kWhite,
            elevation: 0,
            title: ListTile(
              leading: const Icon(
                Icons.home,
                color: kWhite,
                size: 30,
              ),
              title: const Text(
                'Menu',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kWhite,
                  fontFamily: "Ubuntu",
                  fontSize: 20,
                ),
              ),
              onTap: () {
                navigatorKey.currentState!.pop();
              },
            ),
            automaticallyImplyLeading: false,
          ),
          IconTiles(
            icon: Icons.home,
            onTap: () {
              navigatorKey.currentState!.pushReplacementNamed(UserHome.id);
            },
            title: 'Home',
          ),
          IconTiles(
            icon: Icons.add_location_sharp,
            onTap: () {
              navigatorKey.currentState!.pushReplacementNamed(Requests.id);
            },
            title: 'Request',
          ),
          IconTiles(
            icon: Icons.account_circle_rounded,
            onTap: () {
              navigatorKey.currentState!.pushReplacementNamed(Profile.id);
            },
            title: 'Profile',
          ),
          IconTiles(
            icon: Icons.history,
            onTap: () {
              navigatorKey.currentState!.pushReplacementNamed(History.id);
            },
            title: 'History',
          ),
          IconTiles(
            icon: Icons.mail_outline,
            onTap: () {
              navigatorKey.currentState!.pushReplacementNamed(UserSupport.id);
            },
            title: 'Support',
          ),
          IconTiles(
            icon: Icons.exit_to_app,
            onTap: () {
              navigatorKey.currentState!.pop();
              logoutDialog(navigatorKey.currentState!.overlay!.context);
            },
            title: 'Logout',
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
      padding: const EdgeInsets.only(top: 20.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color.fromARGB(255, 180, 32, 37),
          size: 40.0,
        ),
        title: CustomTextStyle(
          text: title,
          textColor: kDarkRedColor,
        ),
        onTap: onTap,
      ),
    );
  }
}
