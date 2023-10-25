import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/city_hospitals.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PatientBrowse extends StatefulWidget {
    PatientBrowse({Key? key, this.patient_id}) : super(key: key);
    final patient_id;

  @override
  State<PatientBrowse> createState() => _PatientBrowseState();
}

class _PatientBrowseState extends State<PatientBrowse> {

  getCities(){
    var _firestore=FirebaseFirestore.instance;
    return _firestore.collection("cities")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15,),
        Container(
          child:
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // InkWell(
                //   onTap: (){
                //     Navigator.of(context).pop();
                //   },
                //   child: Icon(Icons.arrow_back_ios,color: primaryColor.shade900,
                //     size: 25,),
                // ),
                const SizedBox(width: 15,),
                Text('Cities',style: TextStyle(
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
          stream: getCities(),
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
                children: snapshot.data!.docs.map((cityDoc) {

                  return InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CityHospitals(city_id: cityDoc.id,patient_id: widget.patient_id,),));

                    },
                    child: ListTile(
                      leading: Icon(FontAwesomeIcons.city,color: primaryColor.shade900,),
                      title: Text(cityDoc["name"],style: const TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
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
    ) ;
  }
}
