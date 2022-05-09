import 'dart:async';
import 'package:ambicare_service/components/ambulance_details.dart';
import 'package:ambicare_service/constants/constants.dart';
import 'package:ambicare_service/models/ambulance.dart';
import 'package:ambicare_service/screens/splash_screen.dart';
import 'package:ambicare_service/services/database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapsPage extends StatefulWidget {
  static const String id = "/mapsPage";
  const MapsPage({
    Key? key,
  }) : super(key: key);

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  List<Marker>? markers = [];
  GoogleMapController? _mapController;
  Timer? timer;
  String? _ambulanceType;

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
      "All",
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

  setMarkers() async {
    // await setCustomMarker();
    for (final ambulance in allAmbulances!) {
      final amb = Ambulance.fromData(data: ambulance);
      markers!.add(Marker(
        infoWindow: InfoWindow(title: amb.registrationNumber),
        markerId: MarkerId(amb.id),
        onTap: () async {
          showDialog(
            context: context,
            builder: (context) => AmbulanceDetails(
              regNo: ambulance["registrationNumber"],
              type: ambulance["type"],
              farePerKm: ambulance["farePerKm"].toString(),
              driverName: ambulance["driver"] == null
                  ? null
                  : ambulance["driver"]["name"],
              driverPhoneNumber: ambulance["driver"] == null
                  ? null
                  : ambulance["driver"]["phoneNumber"].toString(),
            ),
          );
        },
        icon: ambulance["isAvailable"]
            ? mapMarkerAmbulanceAvailable
            : mapMarkerAmbulanceNotAvailable,
        position: LatLng(
          amb.location["latitude"],
          amb.location["longitude"],
        ),
      ));
    }
  }

  setAmbulances() async {
    List ambulances = [];
    ambulances = await Database.getAllAmbulances();
    allAmbulances = ambulances;
    markers = [];
    if (mounted) {
      setState(() {
        for (final ambulance in allAmbulances!) {
          final amb = Ambulance.fromData(data: ambulance);
          if (amb.type == _ambulanceType || _ambulanceType == "All") {
            markers!.add(Marker(
              infoWindow: InfoWindow(title: amb.registrationNumber),
              markerId: MarkerId(amb.id),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) => AmbulanceDetails(
                    regNo: ambulance["registrationNumber"],
                    type: ambulance["type"],
                    farePerKm: ambulance["farePerKm"].toString(),
                    driverName: ambulance["driver"] == null
                        ? null
                        : ambulance["driver"]["name"],
                    driverPhoneNumber: ambulance["driver"] == null
                        ? null
                        : ambulance["driver"]["phoneNumber"].toString(),
                  ),
                );
              },
              icon: ambulance["isAvailable"]
                  ? mapMarkerAmbulanceAvailable
                  : mapMarkerAmbulanceNotAvailable,
              position: LatLng(
                amb.location["latitude"],
                amb.location["longitude"],
              ),
            ));
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _ambulanceType = "All";
    setMarkers();
    timer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      setAmbulances();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
                target: allAmbulances!.isEmpty
                    ? const LatLng(27.6915, 85.3420)
                    : LatLng(
                        allAmbulances![0]["location"]["latitude"],
                        allAmbulances![0]["location"]["longitude"],
                      ),
                zoom: 16),
            mapType: MapType.normal,
            markers: Set.from(markers!),
            // circles: Set.from(_circles),
            zoomControlsEnabled: true,
            // myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            left: 20.0,
            top: 50.0,
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
