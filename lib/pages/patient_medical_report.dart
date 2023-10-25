import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/hospital_specialities.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PatientMedicalHistory extends StatefulWidget {
  PatientMedicalHistory({Key? key ,this.patient_id, this.privacy_level}) : super(key: key);
  final patient_id;
  final privacy_level;
  @override
  State<PatientMedicalHistory> createState() => _PatientMedicalHistoryState();
}

class _PatientMedicalHistoryState extends State<PatientMedicalHistory> {



  var prescription=[];


  getPrescriptions(){
    var _firestore=FirebaseFirestore.instance;
    return _firestore.collection("appointments")
        .where("patient_id",isEqualTo: widget.patient_id)
        .where('status',isEqualTo: 'Done')
        .orderBy("appointment_date",descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body:
      Column(
        children: [
          const SizedBox(height: 15,),
          Container(
            child:
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back_ios,color: primaryColor.shade900,
                      size: 25,),
                  ),
                  const SizedBox(width: 15,),
                  Text('Medical History',style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: primaryColor.shade900
                  ),),
                ],
              ),
            ),
          ),
          Expanded(child:
          StreamBuilder<QuerySnapshot>(
            stream: getPrescriptions(),
            builder: (context, snapshot) {
              if(snapshot.hasError)
              {
                return Center(child: Text("Error :${snapshot.error}"),);
              }

              if(snapshot.connectionState==ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: primaryColor.shade900,));
              }
              else

              if(snapshot.data!.docs.isEmpty)
              {
                return const Center(child: Text("No Records"),);
              }

              return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    Timestamp timestamp=doc.get('appointment_date');
                    var date=timestamp.toDate();
                    var dtstr='${date.year}-${date.month}-${date.day}';

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(

                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: primaryColor.shade900,width: 2)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                                child: const Icon(Icons.insert_page_break,color: Colors.red,size: 35,),alignment: Alignment.center),
                            Text(dtstr +" "+doc.get("appointment_time"),
                                style: const TextStyle(fontSize: 20)),
                            Text('Doctor :'+doc.get('doctor_name'),
                                style: const TextStyle(fontSize: 20)),
                            widget.privacy_level=="All" || widget.privacy_level=="Diagnosis"? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Diagnosis'),
                                Text(doc.get('diagnosis'),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                              ],
                            ):SizedBox(),
                            widget.privacy_level=="All" || widget.privacy_level=="Prescription"?Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Prescription'),
                                Text(doc.get('prescription'),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                              ],
                            ):SizedBox()

                          ],
                        ),
                      ),
                    );
                  }
                  )
                      .toList()
              );
            },
          )
          )
        ],
      ),


    ));
  }
}
