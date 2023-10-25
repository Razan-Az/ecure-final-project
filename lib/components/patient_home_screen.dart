import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/components/grid_button.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/models/helper.dart';
import 'package:e_cure_app/pages/appointment_details.dart';
import 'package:e_cure_app/pages/book_appointment.dart';
import 'package:e_cure_app/pages/cities_page.dart';
import 'package:e_cure_app/pages/patient_dignosis_report.dart';
import 'package:e_cure_app/pages/patient_prescription_report.dart';
import 'package:e_cure_app/pages/patient_visits_details.dart';
import 'package:flutter/material.dart';

class PatientHomeScreen extends StatefulWidget {
    PatientHomeScreen({Key? key, this.patient_id, this.onClick}) : super(key: key);
  final patient_id;
  final onClick;
  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {


  String? image_url;
  var user_name="";


  getNextAppointment() {
    DateTime now=DateTime.now();

   return FirebaseFirestore.instance
    .collection("appointments")
    .where("patient_id",isEqualTo: widget.patient_id)
    .where("appointment_date",isGreaterThanOrEqualTo: now.getDateOnly())
    .where("status",isEqualTo: "Scheduled")
   .orderBy("appointment_date")
    .snapshots();
  }



  loadUserInfo()async{
    print(widget.patient_id);
    FirebaseFirestore.instance
    .collection("Users")
        .doc(widget.patient_id)
        .get()
        .then((doc) {
          setState(() {
            image_url=doc.get("image_url");
            user_name=doc.get("name");
            print(user_name);
            print(image_url);
          });

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserInfo();

  }

  @override
  Widget build(BuildContext context) {
    return ListView(
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
                          child: Text(user_name,style: const TextStyle(fontSize: 23,color: Colors.grey,fontWeight: FontWeight.bold),))
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
                        backgroundImage:image_url==null?null: NetworkImage(image_url!),
                        child:image_url==null? const Icon(Icons.person,color: Colors.white,size: 40,):const SizedBox(),
                      ),
                    ))],
            )

        ),
        const SizedBox(height: 20,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: GridButton(
                    text: "Book\nAppointment",
                    icon: Icons.description,
                    onClick:widget.onClick,
                  ),
                ),
                Expanded(
                  child: GridButton(
                    text: "Visit\nDetails",
                    icon: Icons.description,
                    onClick: (){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => PatientVisitsDetails(patient_id: widget.patient_id,),));
                    },
                  ),
                ),
              ],),
            Row(
              children: [
                Expanded(
                  child: GridButton(
                    text: "Prescription\nReport",
                    icon: Icons.description,
                    onClick: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => PatientPrescriptionReport(patient_id: widget.patient_id,),)
                      );

                    },
                  ),
                ),
                Expanded(
                  child: GridButton(
                    text: "Diagnosis\nReport",
                    icon: Icons.description,
                    onClick: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => PatientDiagnosisReport(patient_id: widget.patient_id,),)
                      );
                    },
                  ),
                ),
              ],),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: Text('Your next Appointment',
              style: TextStyle(color: primaryColor.shade900,
              fontWeight: FontWeight.bold,fontSize: 19),),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: getNextAppointment(),
              builder: (context, snapshot)
            {
              if(snapshot.connectionState==ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else
                if(snapshot.data!.docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                    child: Text('No Upcoming Appointments'),
                  );
                }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child :Row(
                 children:   snapshot.data!.docs
                .map((appointment) {
                   Timestamp timeStamp= appointment['appointment_date'];
                   DateTime date=timeStamp.toDate();
                return Card(
                  elevation: 12,
                  child:Padding(
                    padding: const EdgeInsets.all(25),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                children: [
                                  const Text('Hospital:'),

                                  Text(appointment["hospital_name"]),
                                ]),

                            Row(
                              children: [
                                const Text('Doctor:'),

                                Text(appointment["doctor_name"]),
                              ],

                            ),
                            Row(
                              children: [
                                const Text('Date and Time :'),
                                Text(  "${date.year}-${date.month}-${date.day} "+
                                    appointment['appointment_time'])
                              ],
                            )
                          ],
                        ),
                        IconButton(onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)
                            =>AppointmentDetails(appointment_id: appointment.id,),));
                        }, icon: const Icon(Icons.arrow_forward_ios))

                      ],
                    ) ,
                  ) ,
                );}).toList(),
              ));
            },)



          ],
        )
      ],
    );
  }
}
