import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/hospital_specialities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientBrowseMap extends StatefulWidget {
  PatientBrowseMap({Key? key, this.patient_id}) : super(key: key);
  final patient_id;

  @override
  State<PatientBrowseMap> createState() => _PatientBrowseMapState();
}

class _PatientBrowseMapState extends State<PatientBrowseMap> {
  
  late GoogleMapController _controller;

  late LatLng user_location;

  late PersistentBottomSheetController? _sheetController=null;

  //declare initial camera position
  late CameraPosition kCameraPosition;

  final initPosition=const LatLng(21.790135342239115, 39.14957107450347);

  final double zoomLevel = 17.64417266845703;
  final double bearing = 220.48236083984375;
  
  var markers=[];


  getProvider(Map<String,dynamic> data){
    return data.containsKey("image_url")==false?AssetImage('assets/images/logo.png'): NetworkImage(data['image_url'],
    );

  }





  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec =
    await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }


  getUserLocation()async{


    Geolocator.getLastKnownPosition()
        .then((position) {
        print("catchhghdfhdfgh");
        setState(() {
          kCameraPosition=CameraPosition(target:
          LatLng(position!.latitude,position!.longitude,),zoom: zoomLevel,bearing: bearing);
        });

    });
  }
  
  loadHospitalsOnMap()async{
    FirebaseFirestore.instance
        .collection("Users")
        .where("type",isEqualTo: "Hospital")
        .orderBy("location")
        .get()
        .then((value)async {
          print(value.size);
          var m=[];
          final Uint8List markerIcon = await getBytesFromAsset('assets/images/hospital.png', 130);
          for(var doc in value.docs)
            {
              GeoPoint location=doc.get('location');
              m.add(Marker(markerId: MarkerId(doc.id),
              icon: BitmapDescriptor.fromBytes(markerIcon),
              position: LatLng(location.latitude,location.longitude),
              infoWindow: InfoWindow(title: doc.get('name'),
              onTap: (){
              _sheetController= showBottomSheet(context: context,  builder: (context) {
                 return Container(
                    padding: EdgeInsets.only(bottom: 10),
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children:  [
                     Container(
                       height: 200,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(16),
                         color: softColor,
                         image: DecorationImage(
                           fit: BoxFit.cover,
                           image:getProvider(doc.data()),


                         )

                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text( doc.get('name'),style: TextStyle(fontSize: 23),),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text( doc.get('description',),style: TextStyle(fontSize: 18)),
                     ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         OutlinedButton.icon(onPressed: (){
                           _makePhoneCall(doc.get('phone'));

                         }, icon: Icon(Icons.call,color:  primaryColor.shade900,),
                             label: Text('Call',style: TextStyle(color: primaryColor.shade900))),

                         OutlinedButton.icon(onPressed: (){
                           Navigator.of(context)
                               .push(MaterialPageRoute(builder: (context) => HospitalSpecialities(hospital_id: doc.id,patient_id: widget.patient_id,),));
                         }, icon: Icon(Icons.date_range_rounded,color:  primaryColor.shade900,),
                             label: Text('Book Appointment',style: TextStyle(color: primaryColor.shade900),),


                         ),

                       ],
                     )

                     ]
                   ),
                 );
                },);
                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (context) => HospitalSpecialities(hospital_id: doc.id,patient_id: widget.patient_id,),));
              })));
            }
          setState(() {
            markers=m;
          });
          
    })
        .catchError((e){
          
    });
  }
  
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    kCameraPosition=CameraPosition(target:
    initPosition,zoom: zoomLevel,bearing: bearing);
   // makeCustomMarker();
    getUserLocation();
    loadHospitalsOnMap();




    }

  @override
  void dispose() {
    // TODO: implement dispose
    _closeSheet();
    _controller.dispose();
    super.dispose();


  }



  _closeSheet(){
    if(_sheetController!=null)
    {
      _sheetController!.close();
      _sheetController=null;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: 
    Scaffold(
      body:GoogleMap(
        initialCameraPosition: kCameraPosition,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        markers: Set.from(markers),
        onTap: (location){
          _closeSheet();
        },
        onMapCreated: (controller) {
          setState(() {
            _controller=controller;
            _controller.animateCamera(CameraUpdate.newCameraPosition(kCameraPosition));

          });
        },
      ) ,
    ));
  }
}
