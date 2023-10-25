import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/speciality_doctors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HospitalSpecialities extends StatefulWidget {
   HospitalSpecialities({Key? key, this.patient_id, this.hospital_id}) : super(key: key);
   final patient_id;
   final hospital_id;

  @override
  State<HospitalSpecialities> createState() => _HospitalSpecialitiesState();
}

class _HospitalSpecialitiesState extends State<HospitalSpecialities> {

  var _specialities=[];

  bool _isLoading=false;


  getHospitalSpecialities(){
    setState(() {
      _isLoading=true;
    });
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.hospital_id)
        .get()
        .then((doc)  {
         Map<String,dynamic>  specialities=doc.get("specialities");
         setState(() {
         _specialities=  specialities.entries.map((e) => {
           "speciality":e.key,
           "count":e.value
         }).toList();
         print(_specialities);
         _isLoading=false;
         });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHospitalSpecialities();
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
                  Text('Specialities',style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: primaryColor.shade900
                  ),),
                ],
              ),
            ),
          ),
          Expanded(child:
          _isLoading?const Center(child: CircularProgressIndicator(),):
          _specialities.isEmpty?
           const Center(child: Text('No Records')): ListView(
                  children:
                  _specialities.map((sp) {

                    return InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SpecialityDoctors(hospital_id:widget.hospital_id ,
                          patient_id: widget.patient_id,speciality: sp['speciality'],),));

                      },
                      child: ListTile(leading: Icon(FontAwesomeIcons.userDoctor,color: primaryColor.shade900,),
                        title: Text(sp['speciality'],style: const TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
                        trailing:  Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(sp['count'].toString(),style:const TextStyle(fontSize: 17),),
                            const Icon(Icons.arrow_forward_ios),

                          ],
                        ),
                      ),
                    );
                  }
                  )
                      .toList()
              )

          )
        ],
      ),


    )) ;
  }
}
