import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});
  static const String routeName = 'home';

  @override
  State<homeScreen> createState() => _homeScreenState();
}

//AIzaSyBT_g_3BRoVm40LVY-I_XtVMq5iduNGyJE
class _homeScreenState extends State<homeScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Set<Marker> markers = {};
  int count=0;

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(30.1563904, 31.2639488),
      tilt: 59.440717697143555,
      zoom: 10.151926040649414);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription!.cancel();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPS'),
      ),
      body: locationData == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              markers: markers,
              onTap:(argument){
                markers.add(Marker(markerId: MarkerId('new$count'),
                position: argument));
                count++;
                setState(() {

                });

              } ,
              mapType: MapType.hybrid,
              initialCameraPosition: currentLocation,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),

    );
  }

  Future<void> updateMyLocation() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(zoom: 18,
        target: LatLng(locationData!.latitude!, locationData!.longitude!))));
  }

  PermissionStatus? permissionStatus;
  Location location = Location();
  bool isServiceEnable = false;
  LocationData? locationData;

  StreamSubscription<LocationData>? subscription;
  CameraPosition currentLocation = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  void getCurrentLocation() async {
    bool permission = await isPermissionGranted();
    if (!permission) {
      return;
    }
    bool service = await isServiceEnabled();
    if (!service) {
      return;
    }
    locationData = await location.getLocation();
    markers.add(Marker(
        markerId: MarkerId('myLocation'),
        position: LatLng(locationData!.latitude!, locationData!.longitude!)));
    currentLocation = CameraPosition(
      target: LatLng(locationData!.latitude!, locationData!.longitude!),
      zoom: 14.4746,
    );
    subscription = location.onLocationChanged.listen((event) {
      locationData = event;
      markers.add(Marker(
          markerId: MarkerId('myLocation'),
          position: LatLng(event.latitude!, event.longitude!)));
      setState(() {

      });
      updateMyLocation();
      print(
          'altitude: ${locationData?.altitude},longtitude: ${locationData?.longitude}');
    });
    location.changeSettings(accuracy: LocationAccuracy.high);
    setState(() {});
  }

  Future<bool> isServiceEnabled() async {
    isServiceEnable = await location.serviceEnabled();
    if (!isServiceEnable) {
      isServiceEnable = await location.requestService();
    }
    return isServiceEnable;
  }

  Future<bool> isPermissionGranted() async {
    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      return permissionStatus == PermissionStatus.granted;
    }
    return permissionStatus == PermissionStatus.granted;
  }
}
