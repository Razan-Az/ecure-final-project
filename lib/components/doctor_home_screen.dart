import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/components/grid_button.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/doctor_appointments.dart';
import 'package:e_cure_app/pages/doctor_questionnaire.dart';
import 'package:e_cure_app/pages/doctor_reviews.dart';
import 'package:e_cure_app/pages/login_page.dart';
import 'package:flutter/material.dart';

class DoctorHomeScreen extends StatefulWidget {
   DoctorHomeScreen({Key? key, this.doctor_id, this.doctor_name}) : super(key: key);
  final doctor_id;
  final doctor_name;

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
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
                      const Text("Welcome",
                        style: TextStyle(fontSize: 42,fontWeight: FontWeight.bold),),
                      SizedBox(
                          width: MediaQuery.of(context).size.width*0.8,
                          child: Flexible(child: Text(widget.doctor_name,style: const TextStyle(fontSize: 23,color: Colors.grey,fontWeight: FontWeight.bold),)))
                    ],
                  )),
                Positioned(
                    top: 10,
                    left: 10,
                    child:
                    InkWell(
                      onTap: (){

                      },
                      child: const CircleAvatar(
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
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage(),));

                    }, icon: const Icon(Icons.logout,size: 30,)) )],
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
                    text: "Questionnaire",
                    icon: Icons.description_outlined,
                    onClick: (){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => DoctorQuestionnaire(doctor_id: widget.doctor_id),));
                    },
                  ),
                ),
                Expanded(
                  child: GridButton(
                    text: "Appointments",
                    icon: Icons.date_range_rounded,
                    onClick: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => DoctorAppointments(doctor_id: widget.doctor_id,),)
                      );
                    },
                  ),
                ),
              ],),
            Row(
              children: [
                Expanded(
                  child: GridButton(
                    text: "Reviews",
                    icon: Icons.reviews,
                    onClick: (){
                      //
                      // FirebaseFirestore.instance
                      // .collection("appointments")
                      // .where("email",isEqualTo: null)
                      // .get()
                      // .then((value) {
                      //   for(var doc in value.docs) {
                      //     if(doc.get("name")==null)
                      //     {
                      //       FirebaseFirestore.instance
                      //           .collection("Users")
                      //           .doc(doc.get("patient_id").toString().toLowerCase())
                      //           .get().then((value) {
                      //             print(value.data());
                      //             doc.reference.update(
                      //               {
                      //                 "name":value.get('name'),
                      //                 'email':value.get('email'),
                      //               }
                      //             ).then((value) {
                      //               print("done");
                      //             });
                      //       });
                      //     }
                      //   }
                      // });
                      // return;
                      
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => DoctorReviews(doctor_id: widget.doctor_id),));
                    },
                  ),
                ),
                Expanded(
                  child: SizedBox(),
                ),
              ],),

          ],
        )
      ],
    );
  }
}
