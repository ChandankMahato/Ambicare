import 'dart:async';
import 'package:ambicare_user/components/IconTiles.dart';
import 'package:ambicare_user/components/app_drawer.dart';
import 'package:ambicare_user/components/custom_text.dart';
import 'package:ambicare_user/components/custom_button.dart';
import 'package:ambicare_user/components/request_details_dialog.dart';
import 'package:ambicare_user/constants/constants.dart';
import 'package:ambicare_user/main.dart';
import 'package:ambicare_user/models/ambulance.dart';
import 'package:ambicare_user/screens/splash_screen.dart';
import 'package:ambicare_user/services/location.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/database.dart';

class UserHome extends StatefulWidget {
  static const String id = "/home";
  const UserHome({Key? key}) : super(key: key);

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  List<Marker>? markers = [];
  GoogleMapController? _mapController;
  Timer? timer;
  List dropLocation = [];
  Marker? dropOffMarker;
  Position? position;
  bool? dropOffPicked = false;
  String? _ambulanceType;
  String? _distanceValue;
  double? _distanceValueNum;
  final Map<String, double> _distanceMap = {
    '1 Kilometer': 1000,
    '2 Kilometer': 2000,
    '3 Kilometer': 3000,
    '5 Kilometer': 5000,
    '6 Kilometer': 6000,
    '8 Kilometer': 8000,
    '10 Kilometer': 10000,
    '12 Kilometer': 12000,
    '15 Kilometer': 15000,
  };

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  void dispose() {
    _mapController!.dispose();
    timer!.cancel();
    super.dispose();
  }

  List<DropdownMenuItem<String>> _getAmbulanceTypes() {
    List<DropdownMenuItem<String>> items = [];
    List<String> ambulanceTypes = [
      "Mobile ICU",
      "Multiple Victim",
      "Neonatal",
      "Isolation",
      "Basic Life Support"
    ];
    for (String type in ambulanceTypes) {
      items.add(
        DropdownMenuItem(
          child: Text(type),
          value: type,
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<String>> _getItems() {
    List<DropdownMenuItem<String>> items = [];
    List<String> distances = [];
    _distanceMap.forEach((key, value) {
      distances.add(key);
    });
    for (String distance in distances) {
      items.add(
        DropdownMenuItem(
          child: Text(distance),
          value: distance,
        ),
      );
    }
    return items;
  }

  setMarker() async {
    markers!.add(
      Marker(
        markerId: const MarkerId(
          "yourLocation",
        ),
        infoWindow: const InfoWindow(
          title: "Your Location",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: LatLng(
          position!.latitude,
          position!.longitude,
        ),
      ),
    );
    for (final ambulance in availableAmbulances) {
      final amb = Ambulance.fromData(data: ambulance);
      if (Location.getDistance(
                amb.location["latitude"],
                amb.location["longitude"],
                position!.latitude,
                position!.longitude,
              ) <=
              _distanceValueNum! &&
          amb.type == _ambulanceType) {
        markers!.add(Marker(
          infoWindow: InfoWindow(title: amb.registrationNumber),
          markerId: MarkerId(amb.id),
          icon: mapMarker,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => RequestDetailsDialog(
                amb: amb,
                dropLocation: dropLocation,
              ),
            );
          },
          position: LatLng(
            amb.location["latitude"],
            amb.location["longitude"],
          ),
        ));
      }
    }
  }

  setAmbulances() async {
    List ambulances = [];
    try {
      ambulances = await Database.getAllAmbulances();
      availableAmbulances = ambulances;
      markers = [];
      if (mounted) {
        setState(() {
          markers!.add(
            Marker(
              markerId: const MarkerId(
                "yourLocation",
              ),
              infoWindow: const InfoWindow(
                title: "Your Location",
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              position: LatLng(
                position!.latitude,
                position!.longitude,
              ),
            ),
          );

          for (final ambulance in availableAmbulances) {
            final amb = Ambulance.fromData(data: ambulance);
            if (Location.getDistance(
                      amb.location["latitude"],
                      amb.location["longitude"],
                      position!.latitude,
                      position!.longitude,
                    ) <=
                    _distanceValueNum! &&
                amb.type == _ambulanceType) {
              markers!.add(
                Marker(
                  infoWindow: InfoWindow(title: amb.registrationNumber),
                  markerId: MarkerId(amb.id),
                  icon: mapMarker,
                  position: LatLng(
                    amb.location["latitude"],
                    amb.location["longitude"],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => RequestDetailsDialog(
                        amb: amb,
                        dropLocation: dropLocation,
                      ),
                    );
                  },
                ),
              );
            }
          }
          if (dropOffMarker != null) {
            markers!.add(dropOffMarker!);
          }
        });
      }
    } catch (ex) {}
  }

  @override
  void initState() {
    _distanceValue = '1 Kilometer';
    _ambulanceType = "Mobile ICU";
    _distanceValueNum = _distanceMap[_distanceValue];
    position = userPosition;
    setMarker();

    timer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      setAmbulances();
    });
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _showStartDialog(navigatorKey.currentState!.overlay!.context),
    );
    super.initState();
  }

  Future<void> _showStartDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.only(
            bottom: 15.0,
          ),
          titlePadding: const EdgeInsets.only(
            top: 20.0,
            // bottom: 10.0,
            left: 24.0,
            right: 24.0,
          ),
          contentPadding: const EdgeInsets.only(
            top: 10.0,
            // bottom: 10.0,
            left: 24.0,
            right: 24.0,
          ),
          title: const CustomTextStyle(
            text: 'Get Quick Overview',
            textColor: kLightRedColor,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                IconTilesComponent(
                  icon: Icons.location_on_outlined,
                  onTap: () {},
                  title: 'Your Location',
                  iconColor: Colors.blue,
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      'images/marker-red.png',
                      width: 50,
                      height: 50,
                    ),
                    const CustomTextStyle(
                        text: 'Ambulance Location', textColor: kDarkRedColor)
                  ],
                ),
                IconTilesComponent(
                  icon: Icons.pin_drop_outlined,
                  onTap: () {},
                  title: 'Dropoff Location',
                  iconColor: Colors.green,
                ),
                const Divider(),
                const CustomTextStyle(
                  text: 'Long Press on Map to choose Dropoff Location',
                  textColor: kLightRedColor,
                ),
                const Divider(),
                const CustomTextStyle(
                  text:
                      'Then, tap on ambulance near to your location to send request',
                  textColor: kLightRedColor,
                ),
              ],
            ),
          ),
          actions: [
            NewCustomButton(
              onPressed: () {
                navigatorKey.currentState!.pop();
              },
              width: 100,
              height: 40,
              buttonTitle: 'Got It',
              color: kLightRedColor,
              textColor: kWhite,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                position!.latitude,
                position!.longitude,
              ),
              zoom: 16,
            ),
            mapType: MapType.normal,
            markers: Set.from(markers!),
            zoomControlsEnabled: false,
            myLocationButtonEnabled: true,
            onLongPress: (latLng) {
              if (markers!.isEmpty) return;
              dropOffMarker = Marker(
                infoWindow: const InfoWindow(title: "Dropoff Location"),
                markerId: const MarkerId('dropOffLocation'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
                position: LatLng(latLng.latitude, latLng.longitude),
              );
              setState(() {
                if (!dropOffPicked!) {
                  markers!.add(dropOffMarker!);
                  dropOffPicked = true;
                } else {
                  markers!.removeLast();
                  markers!.add(dropOffMarker!);
                }
              });
              dropLocation = [latLng.latitude, latLng.longitude];
            },
          ),
          Positioned(
            left: 20.0,
            top: 50.0,
            right: 10.0,
            child: Column(
              children: [
                Row(
                  children: [
                    DrawerButton(scaffoldKey: scaffoldKey),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 6.0,
                            spreadRadius: 0.5,
                            offset: Offset(
                              0.7,
                              0.7,
                            ),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Search Radius:  ',
                            style: TextStyle(
                              fontFamily: "Ubuntu",
                              color: kDarkRedColor,
                              fontSize: 16.0,
                            ),
                          ),
                          DropdownButton(
                            underline: const SizedBox(),
                            style: const TextStyle(
                              fontFamily: "Ubuntu",
                              color: kDarkRedColor,
                              fontSize: 16.0,
                            ),
                            items: _getItems(),
                            value: _distanceValue,
                            onChanged: (String? newValue) {
                              setState(() {
                                _distanceValue = newValue;
                                _distanceValueNum =
                                    _distanceMap[_distanceValue];
                                setAmbulances();
                                print(_distanceValueNum);
                                // _circles.add('user');
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 20.0,
            bottom: 20.0,
            right: 20.0,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 6.0,
                        spreadRadius: 0.5,
                        offset: Offset(
                          0.7,
                          0.7,
                        ),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'Ambulance Type:  ',
                        style: TextStyle(
                          fontFamily: "Ubuntu",
                          color: kDarkRedColor,
                          fontSize: 16.0,
                        ),
                      ),
                      DropdownButton(
                        underline: const SizedBox(),
                        style: const TextStyle(
                          fontFamily: "Ubuntu",
                          color: kDarkRedColor,
                          fontSize: 16.0,
                        ),
                        items: _getAmbulanceTypes(),
                        value: _ambulanceType,
                        onChanged: (String? newValue) {
                          setState(() {
                            _ambulanceType = newValue;
                            setAmbulances();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerButton extends StatelessWidget {
  const DrawerButton({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 6.0,
              spreadRadius: 0.5,
              offset: Offset(
                0.7,
                0.7,
              ),
            ),
          ],
        ),
        child: const CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.white,
          child: Icon(
            EvaIcons.menu2Outline,
            color: kLightRedColor,
            size: 30.0,
          ),
        ),
      ),
      onTap: () {
        scaffoldKey.currentState!.openDrawer();
      },
    );
  }
}
