import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/hospital_specialities.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CityHospitals extends StatefulWidget {
  CityHospitals({Key? key, this.city_id, this.patient_id}) : super(key: key);
  final city_id;
 final patient_id;
  @override
  State<CityHospitals> createState() => _CityHospitalsState();
}

class _CityHospitalsState extends State<CityHospitals> {

  getHospitals(){
    var _firestore=FirebaseFirestore.instance;
    return _firestore.collection("Users")
        .where("type",isEqualTo: "Hospital")
        .where("city_id",isEqualTo: widget.city_id)
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
                  Text('Hospitals',style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: primaryColor.shade900
                  ),),
                ],
              ),
            ),
          ),
          Expanded(child:
          StreamBuilder<QuerySnapshot>(
            stream: getHospitals(),
            builder: (context, snapshot) {
              if(snapshot.hasError)
              {
                return Center(child: Text("Error :"+snapshot.error.toString()),);
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
                  children: snapshot.data!.docs.map((hospital) {

                    return InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HospitalSpecialities(hospital_id: hospital.id,
                            patient_id: widget.patient_id),));

                      },
                      child: ListTile(leading: Icon(FontAwesomeIcons.hospital,color: primaryColor.shade900,),
                        title: Text(hospital["name"],style: const TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
                         trailing:  Icon(Icons.arrow_forward_ios),

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
