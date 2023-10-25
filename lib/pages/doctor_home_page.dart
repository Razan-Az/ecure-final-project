import 'package:e_cure_app/components/doctor_home_screen.dart';
import 'package:e_cure_app/components/doctor_profile_screen.dart';
import 'package:e_cure_app/components/grid_button.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/doctor_appointments.dart';
import 'package:e_cure_app/pages/doctor_questionnaire.dart';
import 'package:e_cure_app/pages/login_page.dart';
import 'package:flutter/material.dart';

class DoctorHomePage extends StatefulWidget {
   DoctorHomePage({Key? key,required this.doctor_id,required this.doctor_name}) : super(key: key);
  final String doctor_id;
  final String doctor_name;

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  int _selected_index=0;

  List screens=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    screens=[
      DoctorHomeScreen(doctor_id: widget.doctor_id,doctor_name: widget.doctor_name,),
      DoctorProfileScreen(patient_id: widget.doctor_id),
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
