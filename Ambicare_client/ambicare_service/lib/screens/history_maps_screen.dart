import 'package:ambicare_service/components/ambulance_details.dart';
import 'package:ambicare_service/screens/signup_screen.dart';
import 'package:ambicare_service/screens/splash_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ambicare_service/secrets/secrets.dart';
import 'package:dio/dio.dart';

class HistoryMapsPage extends StatefulWidget {
  static const String id = "/historyMapsPage";
  final Map<String, dynamic>? args;
  const HistoryMapsPage({
    Key? key,
    this.args,
  }) : super(key: key);

  @override
  _HistoryMapsPageState createState() => _HistoryMapsPageState();
}

class _HistoryMapsPageState extends State<HistoryMapsPage> {
  List<Marker>? markers = [];
  GoogleMapController? _mapController;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> toUserPolylineCoordinates = [];
  List<LatLng> toDestinationPolylineCoordinates = [];
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _getPolylinetoUser();
    if (widget.args!["destination"]["latitude"] != null) {
      _getPolylinetoDestination();
    }
    // setState(() {});
  }

  @override
  void dispose() {
    _mapController!.dispose();
    // timer!.cancel();
    super.dispose();
  }

  setMarkers() {
    // for (final ambulance in allAmbulances!) {
    // final amb = Ambulance.fromData(data: ambulance);
    markers!.add(
      Marker(
        infoWindow: const InfoWindow(title: "Ambulance"),
        markerId: const MarkerId("Ambulance"),
        icon: mapMarkerAmbulanceAvailable,
        position: LatLng(
          widget.args!["ambulance"]["location"]["latitude"],
          widget.args!["ambulance"]["location"]["longitude"],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AmbulanceDetails(
              regNo: widget.args!["ambulance"]["registrationNumber"],
              type: widget.args!["ambulance"]["type"],
              farePerKm: widget.args!["ambulance"]["farePerKm"].toString(),
              driverName: widget.args!["requestedTo"]["driverName"],
              driverPhoneNumber:
                  widget.args!["requestedTo"]["driverPhoneNumber"].toString(),
            ),
          );
        },
      ),
    );
    markers!.add(Marker(
      infoWindow: const InfoWindow(title: "Pickup Location"),
      markerId: const MarkerId("Pickup Location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      position: LatLng(
        widget.args!["pickUpLocation"]["latitude"],
        widget.args!["pickUpLocation"]["longitude"],
      ),
    ));
    if (widget.args!["destination"]["latitude"] != null) {
      markers!.add(
        Marker(
          infoWindow: const InfoWindow(title: "Destination"),
          markerId: const MarkerId("Destination"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: LatLng(
            widget.args!["destination"]["latitude"],
            widget.args!["destination"]["longitude"],
          ),
        ),
      );
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

  @override
  void initState() {
    super.initState();
    setMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
                target: LatLng(
                  widget.args!["ambulance"]["location"]["latitude"],
                  widget.args!["ambulance"]["location"]["longitude"],
                ),
                zoom: 16),
            polylines: Set<Polyline>.of(polylines.values),
            mapType: MapType.normal,
            markers: Set.from(markers!),
            // circles: Set.from(_circles),
            onTap: (latLng) {},
            zoomControlsEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
        ],
      ),
    );
  }
}
