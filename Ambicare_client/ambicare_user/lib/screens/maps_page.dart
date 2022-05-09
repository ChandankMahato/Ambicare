import 'dart:async';
import 'package:ambicare_user/components/ambulance_details.dart';
import 'package:ambicare_user/constants/constants.dart';
import 'package:ambicare_user/main.dart';
import 'package:ambicare_user/screens/signup_screen.dart';
import 'package:ambicare_user/screens/splash_screen.dart';
import 'package:ambicare_user/services/location.dart';
import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ambicare_user/secrets/secrets.dart';

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

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _getPolylinetoUser();
    if (widget.args!["destination"]["latitude"] != null) {
      _getPolylinetoDestination();
    }
    setState(() {});
  }

  @override
  void dispose() {
    if (myStreamSubscription != null) myStreamSubscription!.cancel();
    _mapController!.dispose();
    super.dispose();
  }

  setMarkers() {
    markers!.add(
      Marker(
        infoWindow: const InfoWindow(title: "Ambulance"),
        markerId: const MarkerId("Ambuance"),
        icon: mapMarker,
        position: LatLng(
          widget.args!["ambulance"]["location"]["latitude"],
          widget.args!["ambulance"]["location"]["longitude"],
        ),
        onTap: () => showDialog(
          context: context,
          builder: (context) => AmbulanceDetails(
            amb: widget.args!["ambulance"],
            otherDetails: widget.args!["requestedTo"],
          ),
        ),
      ),
    );
    markers!.add(Marker(
      infoWindow: const InfoWindow(title: "My Location"),
      markerId: const MarkerId("My Location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      position: LatLng(
        widget.args!["pickUpLocation"]["latitude"],
        widget.args!["pickUpLocation"]["longitude"],
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
      final response = await Dio().get(
          'https://api.mapbox.com/directions/v5/mapbox/driving/${widget.args!["pickUpLocation"]["longitude"]},${widget.args!["pickUpLocation"]["latitude"]};${widget.args!["ambulance"]["location"]["longitude"]},${widget.args!["ambulance"]["location"]["latitude"]}?geometries=geojson&access_token=${API.polylinesToken}');

      List<dynamic> result =
          response.data["routes"][0]["geometry"]["coordinates"];
      result.forEach((element) {
        toUserPolylineCoordinates.add(LatLng(element[1], element[0]));
      });
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
                target: LatLng(
                  widget.args!["my_location"]["latitude"],
                  widget.args!["my_location"]["longitude"],
                ),
                zoom: 16),
            polylines: Set<Polyline>.of(polylines.values),
            mapType: MapType.normal,
            markers: Set.from(markers!),
            onTap: (latLng) {},
            zoomControlsEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          DrawerButton(scaffoldKey: scaffoldKey)
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
    return Positioned(
      top: 60.0,
      left: 30.0,
      child: GestureDetector(
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
            backgroundColor: kWhite,
            child: Icon(
              EvaIcons.close,
              color: kLightRedColor,
              size: 30.0,
            ),
          ),
        ),
        onTap: () {
          navigatorKey.currentState!.pop();
        },
      ),
    );
  }
}
