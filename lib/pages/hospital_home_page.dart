import 'package:e_cure_app/components/grid_button.dart';
import 'package:e_cure_app/components/hospital_home_screen.dart';
import 'package:e_cure_app/components/hospital_profile_screen.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/doctors_page.dart';
import 'package:e_cure_app/pages/login_page.dart';
import 'package:flutter/material.dart';

class HospitalHomePage extends StatefulWidget {
   HospitalHomePage({Key? key,required this.hospital_id,required this.hospital_name}) : super(key: key);
  final String hospital_id;
  final String hospital_name;

  @override
  State<HospitalHomePage> createState() => _HospitalHomePageState();
}

class _HospitalHomePageState extends State<HospitalHomePage> {
  int _selected_index=0;

  List screens=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    screens=[
      HospitalHomeScreen( hospital_id: widget.hospital_id,hospital_name: widget.hospital_name,),
      HospitalProfileScreen( hospital_id: widget.hospital_id),
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

          setState(() {
            _selected_index=index;
          });
        },
        items:const [
         BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined),label: "Profile"),
        ],
      ),
    ));
  }
}
