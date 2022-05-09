import 'dart:async';
import 'package:ambicare_driver/components/continue_dialog.dart';
import 'package:ambicare_driver/components/custom_button.dart';
import 'package:ambicare_driver/components/waiting_dialog.dart';
import 'package:ambicare_driver/constants/constants.dart';
import 'package:ambicare_driver/main.dart';
import 'package:ambicare_driver/screens/requests_page.dart';
import 'package:ambicare_driver/screens/signin_screen.dart';
import 'package:ambicare_driver/screens/splash_screen.dart';
import 'package:ambicare_driver/services/database.dart';
import 'package:ambicare_driver/services/location.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ambicare_driver/secrets/secrets.dart';

class MapsPage extends StatefulWidget {
  static const String id = "/mapsPage";
  final Map<String, dynamic>? args;
  const MapsPage({
    Key? key,
    this.args,
  }) : super(key: key);

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  List<Marker>? markers = [];
  GoogleMapController? _mapController;
  Timer? timer;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> toUserPolylineCoordinates = [];
  List<LatLng> toDestinationPolylineCoordinates = [];
  StreamSubscription? myStreamSubscription;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool? isHistoryMode;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _getPolylinetoUser();
    if (widget.args!["destination"]["latitude"] != null) {
      _getPolylinetoDestination();
    }
    if (widget.args!["my_location"] != null) {
      startJourney();
    }
  }

  @override
  void dispose() {
    if (myStreamSubscription != null) myStreamSubscription!.cancel();
    _mapController!.dispose();
    // timer!.cancel();
    super.dispose();
  }

  setMarkers() {
    // for (final ambulance in allAmbulances!) {
    // final amb = Ambulance.fromData(data: ambulance);
    markers!.add(Marker(
      infoWindow: const InfoWindow(title: "User Location"),
      markerId: const MarkerId("User Location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: LatLng(
        widget.args!["pickUpLocation"]["latitude"],
        widget.args!["pickUpLocation"]["longitude"],
      ),
    ));
    markers!.add(Marker(
      infoWindow: const InfoWindow(title: "My Location"),
      markerId: const MarkerId("My Location"),
      icon: ambulanceMarker,
      position: widget.args!["my_location"] == null
          ? LatLng(
              widget.args!["ambulance"]["location"]["latitude"],
              widget.args!["ambulance"]["location"]["longitude"],
            )
          : LatLng(
              widget.args!["my_location"]["latitude"],
              widget.args!["my_location"]["longitude"],
            ),
    ));
    if (widget.args!["destination"]["latitude"] != null) {
      markers!.add(Marker(
        infoWindow: const InfoWindow(title: "Destination"),
        markerId: const MarkerId("Destination"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: LatLng(
          widget.args!["destination"]["latitude"],
          widget.args!["destination"]["longitude"],
        ),
      ));
    }

    // }
  }

  void _addPolyLine(String polylineId, bool forUser) {
    if (!mounted) return;
    setState(() {
      PolylineId id = PolylineId(polylineId);
      Polyline polyline = Polyline(
          polylineId: id,
          color: forUser ? Colors.blue : Colors.green,
          points: forUser
              ? toUserPolylineCoordinates
              : toDestinationPolylineCoordinates,
          width: 4);
      polylines[id] = polyline;
    });
  }

  void _getPolylinetoUser() async {
    try {
      if (isHistoryMode!) {
        final response = await Dio().get(
            'https://api.mapbox.com/directions/v5/mapbox/driving/${widget.args!["ambulance"]["location"]["longitude"]},${widget.args!["ambulance"]["location"]["latitude"]};${widget.args!["pickUpLocation"]["longitude"]},${widget.args!["pickUpLocation"]["latitude"]}?geometries=geojson&access_token=${API.polylinesToken}');

        List<dynamic> result =
            response.data["routes"][0]["geometry"]["coordinates"];
        result.forEach((element) {
          toUserPolylineCoordinates.add(LatLng(element[1], element[0]));
        });
      } else {
        final response = await Dio().get(
            'https://api.mapbox.com/directions/v5/mapbox/driving/${widget.args!["my_location"]["longitude"]},${widget.args!["my_location"]["latitude"]};${widget.args!["pickUpLocation"]["longitude"]},${widget.args!["pickUpLocation"]["latitude"]}?geometries=geojson&access_token=${API.polylinesToken}');

        List<dynamic> result =
            response.data["routes"][0]["geometry"]["coordinates"];
        result.forEach((element) {
          toUserPolylineCoordinates.add(LatLng(element[1], element[0]));
        });
      }
    } catch (e) {
      showSnackBar(
          context, "Network Error, please reload the page again", Colors.red);
    }

    _addPolyLine("toUser", true);
  }

  void _getPolylinetoDestination() async {
    try {
      final response = await Dio().get(
          'https://api.mapbox.com/directions/v5/mapbox/driving/${widget.args!["pickUpLocation"]["longitude"]},${widget.args!["pickUpLocation"]["latitude"]};${widget.args!["destination"]["longitude"]},${widget.args!["destination"]["latitude"]}?geometries=geojson&access_token=${API.polylinesToken}');
      List<dynamic> result =
          response.data["routes"][0]["geometry"]["coordinates"];
      result.forEach((element) {
        toDestinationPolylineCoordinates.add(LatLng(element[1], element[0]));
      });
    } catch (e) {
      showSnackBar(
          context, "Network Error, please reload the page again", Colors.red);
    }

    _addPolyLine("toDestination", false);
  }

  void startJourney() {
    myStreamSubscription =
        Location.getPositionStream().listen((Position position) {
      LatLng latLng = LatLng(position.latitude, position.longitude);
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: 19),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    isHistoryMode = widget.args!["my_location"] == null;
    setMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
                target: widget.args!["my_location"] == null
                    ? LatLng(
                        widget.args!["ambulance"]["location"]["latitude"],
                        widget.args!["ambulance"]["location"]["longitude"],
                      )
                    : LatLng(
                        widget.args!["my_location"]["latitude"],
                        widget.args!["my_location"]["longitude"],
                      ),
                zoom: 16),
            polylines: Set<Polyline>.of(polylines.values),
            mapType: MapType.normal,
            markers: Set.from(markers!),
            // circles: Set.from(_circles),
            onTap: (latLng) {},
            zoomControlsEnabled: true,
            myLocationEnabled: widget.args!["my_location"] != null,
            myLocationButtonEnabled: widget.args!["my_location"] != null,
          ),
          widget.args!["my_location"] == null
              ? Container()
              : Positioned(
                  bottom: 20.0,
                  left: 15.0,
                  right: 60.0,
                  child: CustomButton(
                    onPressed: () async {
                      await showDialog(
                          context: navigatorKey.currentState!.overlay!.context,
                          builder: (context) => continueDialog(
                                title: "Finish Ride",
                                message: "Are you sure you wish to continue?",
                                yesContent: "Finish",
                                noContent: "Cancel",
                                onYes: () async {
                                  navigatorKey.currentState!.pop();
                                  showDialog(
                                    context: context,
                                    builder: (context) => const WaitingDialog(
                                        title: "Finishing Ride"),
                                  );
                                  Map<String, dynamic> data = {
                                    "longitude": widget.args!["destination"]
                                        ["longitude"],
                                    "latitude": widget.args!["destination"]
                                        ["latitude"],
                                    "ambulanceRegistration":
                                        widget.args!["ambulance"]
                                            ["registrationNumber"]
                                  };
                                  final result = await Database.completeRequest(
                                      widget.args!["id"], data);
                                  if (result! ~/ 100 == 2) {
                                    navigatorKey.currentState!.pop();
                                    navigatorKey.currentState!.pop();
                                  } else {
                                    navigatorKey.currentState!.pop();
                                    showSnackBar(
                                      context,
                                      "Ride couldnot be finished",
                                      kLightRedColor,
                                    );
                                  }
                                },
                                onNo: () {
                                  navigatorKey.currentState!.pop();
                                },
                              ));
                    },
                    width: double.infinity,
                    buttonContent: const Text(
                      "Finish Ride",
                      style: kButtonContentTextStye,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
