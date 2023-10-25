import 'package:e_cure_app/components/custom_button.dart';
import 'package:e_cure_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({Key? key}) : super(key: key);

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  late GoogleMapController _controller;

  late LatLng user_location;

  //declare initial camera position
  late CameraPosition kCameraPosition;

  final initPosition=const LatLng(21.790135342239115, 39.14957107450347);

  final double zoomLevel = 17.64417266845703;
  final double bearing = 220.48236083984375;

  var _selected_location;

  var _markers=[];


  getUserLocation()async{
    Geolocator.getLastKnownPosition()
        .then((position) {
      setState(() {
        kCameraPosition=CameraPosition(target:
        LatLng(position!.latitude,position!.longitude,),zoom: zoomLevel,bearing: bearing);
      });
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    kCameraPosition=CameraPosition(target:
    initPosition,zoom: zoomLevel,bearing: bearing);
    getUserLocation();


  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();


  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: kCameraPosition,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            onTap: (position){
              setState(() {
                _markers.add(Marker(markerId: MarkerId('marker'),
                    position: position));
                _selected_location=position;
              });
            },
            onMapCreated: (controller) {
              setState(() {
                _controller=controller;
                _controller.animateCamera(CameraUpdate.newCameraPosition(kCameraPosition));
              });
            },
            markers:Set.from(_markers),
          ),
          Positioned(
            bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(text: "Select",
          color: primaryColor.shade800,
                onClick: (){
            Navigator.of(context).pop(_selected_location);
                },),
              ))
        ],
      ),
    ));
  }
}
