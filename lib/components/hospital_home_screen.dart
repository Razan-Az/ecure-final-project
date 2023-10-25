import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/components/grid_button.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/doctors_page.dart';
import 'package:e_cure_app/pages/login_page.dart';
import 'package:flutter/material.dart';

class HospitalHomeScreen extends StatelessWidget {
   HospitalHomeScreen({Key? key, this.hospital_name, this.hospital_id}) : super(key: key);
   final hospital_name;
   final hospital_id;

  @override
  Widget build(BuildContext context) {
    return  ListView(
      children: [
        Card(
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: softColor,
            elevation: 10,
            child:
            Stack(
              children: [Opacity(opacity: 0.4,
                child: Image.asset("assets/images/logo.png",),), Positioned(
                  bottom: 43,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome",
                        style: TextStyle(fontSize: 42,fontWeight: FontWeight.bold),),
                      SizedBox(
                          width: MediaQuery.of(context).size.width*0.8,
                          child: Text(hospital_name,style: TextStyle(fontSize: 23,color: Colors.grey,fontWeight: FontWeight.bold),))
                    ],
                  )),
                Positioned(
                    top: 10,
                    left: 10,
                    child:
                    InkWell(
                      onTap: (){

                      },
                      child: CircleAvatar(
                        minRadius: 40,
                        backgroundColor:  Colors.teal,
                        child: Icon(Icons.person,color: Colors.white,size: 40,),
                      ),
                    )),
                Positioned(
                    right: 15,
                    top: 15,
                    child:  IconButton(onPressed: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage(),));

                    }, icon: Icon(Icons.logout,size: 30,)) )],
            )

        ),
        const SizedBox(height: 20,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: GridButton(
                    text: "Doctors",
                    icon: Icons.people,
                    onClick: (){

                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context)=>  Doctors(hospital_id: hospital_id,hospital_name: hospital_name,)));
                    },
                  ),
                ),
                Expanded(child: SizedBox())
              ],),

          ],
        )
      ],
    );
  }
}
