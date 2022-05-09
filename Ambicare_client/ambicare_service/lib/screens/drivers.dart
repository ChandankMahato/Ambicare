import 'package:ambicare_service/components/continue_dialog.dart';
import 'package:ambicare_service/components/custom_button.dart';
import 'package:ambicare_service/components/custom_text_field.dart';
import 'package:ambicare_service/components/waiting_dialog.dart';
import 'package:ambicare_service/constants/constants.dart';
import 'package:ambicare_service/main.dart';
import 'package:ambicare_service/models/driver.dart';
import 'package:ambicare_service/models/driver.dart';
import 'package:ambicare_service/screens/signin_screen.dart';
import 'package:ambicare_service/screens/signup_screen.dart';
import 'package:ambicare_service/services/auth.dart';
import 'package:ambicare_service/services/database.dart';
import 'package:ambicare_service/services/location.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Drivers extends StatefulWidget {
  const Drivers({Key? key}) : super(key: key);

  @override
  State<Drivers> createState() => _DriversState();
}

class _DriversState extends State<Drivers> {
  // List<DropdownMenuItem<String>>? dropDownItems() {
  final usernameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    usernameController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
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

  Widget bottomSheet(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets.copyWith(
              top: 20.0,
              left: 30.0,
              right: 30.0,
              // bottom: 20.0,
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Driver Details",
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            CustomTextField(
              controller: usernameController,
              labelText: "USERNAME",
              icon: EvaIcons.carOutline,
            ),
            const SizedBox(
              height: 20.0,
            ),
            CustomTextField(
              controller: phoneNumberController,
              labelText: "PHONE NUMBER",
              icon: EvaIcons.carOutline,
            ),
            const SizedBox(
              height: 20.0,
            ),
            CustomTextField(
              controller: passwordController,
              labelText: "PASSWORD",
              icon: EvaIcons.carOutline,
            ),
            const SizedBox(
              height: 50.0,
            ),
            CustomButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  showDialog(
                    context: context,
                    builder: (context) => const WaitingDialog(title: "Saving"),
                  );
                  final response = await Database.driverExists(
                    phoneNumberController.text.trim(),
                  );
                  if (response! ~/ 100 != 2) {
                    navigatorKey.currentState!.pop();
                    navigatorKey.currentState!.pop();
                    return showSnackBar(
                      context,
                      "Driver already exists",
                      Colors.red,
                    );
                  }
                  final data = {
                    "phoneNumber": phoneNumberController.text.trim(),
                    "password": passwordController.text,
                    "name": usernameController.text.trim(),
                  };
                  final result = await Database.saveDriver(data);

                  if (result! ~/ 100 == 2) {
                    navigatorKey.currentState!.pop();
                    navigatorKey.currentState!.pop();
                    showSnackBar(context, "Driver added", Colors.green);
                    setState(() {});
                  } else {
                    navigatorKey.currentState!.pop();
                    navigatorKey.currentState!.pop();
                    showSnackBar(
                        context, "Driver couldnot be added", Colors.red);
                  }
                }
              },
              width: double.infinity,
              buttonContent: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      EvaIcons.saveOutline,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "SAVE",
                      style: kButtonContentTextStye,
                    ),
                  ]),
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
    return Scaffold(
      // backgroundColor: Colors.black,
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Drivers'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Authentication.signOut();
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              enableDrag: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              builder: (context) {
                return bottomSheet(context);
              });
          // navigatorKey.currentState!.pushNamed(AddNewdriver.id);
        },
        // backgroundColor: const Color(0xffd17842),
        backgroundColor: kLightRedColor,
        child: const Icon(
          EvaIcons.plus,
          color: Colors.white,
        ),
      ),
      body: Scrollbar(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            left: 20.0,
            right: 20.0,
          ),
          child: FutureBuilder<List>(
            future: Database.getAllDrivers(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'You have no drivers',
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
              final drivers = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: drivers.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final Driver? driver = Driver.fromData(data: drivers[index]);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 30.0),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 15.0,
                    ),
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
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name: ${driver!.name}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Text(
                                "Number: ${driver.phoneNumber}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Text(
                                driver.ambulance == null
                                    ? "Ambulance: Not Assigned"
                                    : "Ambulance: ${driver.ambulance}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: InkWell(
                            onTap: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => continueDialog(
                                  title: "Delete Driver",
                                  message: "Are you sure you want to continue?",
                                  onYes: () async {
                                    // Navigator.of(context,
                                    //         rootNavigator: true)
                                    //     .pop();
                                    navigatorKey.currentState!.pop();
                                    showDialog(
                                      context: context,
                                      builder: (context) => const WaitingDialog(
                                          title: "Deleting"),
                                    );
                                    final result = await Database.deleteDriver(
                                      driver.id,
                                    );
                                    if (result! ~/ 100 == 2) {
                                      navigatorKey.currentState!.pop();
                                      showSnackBar(
                                          scaffoldKey.currentContext!,
                                          "Driver successfully deleted",
                                          Colors.green);
                                      setState(() {});
                                    } else {
                                      navigatorKey.currentState!.pop();
                                      showSnackBar(
                                          scaffoldKey.currentContext!,
                                          "Driver couldnot be deleted",
                                          Colors.red);
                                    }
                                  },
                                  yesContent: "Confirm",
                                  noContent: "Cancel",
                                  onNo: () {
                                    navigatorKey.currentState!.pop();
                                  },
                                ),
                              );
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    16.0,
                                  ),
                                ),
                              ),
                              child: const Icon(
                                // Icons.cancel,
                                Icons.delete,
                                color: kDarkRedColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
