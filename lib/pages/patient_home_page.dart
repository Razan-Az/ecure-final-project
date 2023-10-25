import 'package:e_cure_app/components/grid_button.dart';
import 'package:e_cure_app/components/patient_browse.dart';
import 'package:e_cure_app/components/patient_browse_map.dart';
import 'package:e_cure_app/components/patient_home_screen.dart';
import 'package:e_cure_app/components/patient_profile_screen.dart';
import 'package:e_cure_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class PatienthomePage extends StatefulWidget {
   PatienthomePage({Key? key,required this.user_name,required this.full_name}) : super(key: key);
  final String user_name;
  final String full_name;

  @override
  State<PatienthomePage> createState() => _PatienthomePageState();
}

class _PatienthomePageState extends State<PatienthomePage> {




  int _selected_index=2;

  List screens=[];



  onBook(){
    setState(() {
      _selected_index=1;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    screens=[
      PatientBrowseMap(patient_id: widget.user_name,),
      PatientBrowse(patient_id: widget.user_name,),
      PatientHomeScreen(patient_id: widget.user_name,onClick: onBook),
      PatientProfileScreen(patient_id: widget.user_name,),
    ];
  }





  @override
  Widget build(BuildContext context) {

    return SafeArea(child:
    Scaffold(
      backgroundColor: softGreyColor,
      body:screens[_selected_index] ,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selected_index,
        selectedItemColor: primaryColor.shade900,
        unselectedItemColor: greyColor.shade500,
        onTap: (index)async{
          if(index==0)
          {
            var status=await Permission.location.isDenied;
            if(status)
            {
             var st= await Permission.location.request();
             if(st==PermissionStatus.denied) {
               return;
             }
            }
          }
          setState(() {
            _selected_index=index;
          });
        },
        items:const [
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined),label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.location_city),label: "Browse"),
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined),label: "Profile"),
        ],
      ),
    ));
  }
}
