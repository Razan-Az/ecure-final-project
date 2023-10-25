import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/models/helper.dart';
import 'package:e_cure_app/pages/add_city_page.dart';
import 'package:e_cure_app/pages/add_doctor_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Doctors extends StatefulWidget {
    Doctors({Key? key, this.hospital_id, this.hospital_name}) : super(key: key);
  final hospital_id;
  final hospital_name;

  @override
  State<Doctors> createState() => _CitiesState();
}

class _CitiesState extends State<Doctors> {



  getDoctors(){
    var _firestore=FirebaseFirestore.instance;
    return _firestore.collection("Users")
        .where("type",isEqualTo: "Doctor")
    .where("hospital_id",isEqualTo: widget.hospital_id)
        .snapshots();
  }

  resetPassword(id)
  {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(id)
        .update({
      "password":Helper().hashPassword("123456"),

    }).then((value) {
      var snackBar=SnackBar(content: Text('Password has been reset to default'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  updateAccountStatus(id,status){
    FirebaseFirestore.instance
        .collection('Users')
        .doc(id)
        .update({
      "status":status
    }).then((value) {
      var snackBar=SnackBar(content: Text('Status has been updated'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
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
                  Text('Doctors',style: TextStyle(
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
                stream: getDoctors(),
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
                    children: snapshot.data!.docs.map((doctor) {

                      return ListTile(leading: Icon(Icons.person,color: doctor['status']=='Active'? primaryColor.shade900:Colors.red,),
                        title: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doctor["name"],style: const TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
                            Text(doctor["speciality"].toString())
                          ],
                        ),
                        trailing: InkWell(
                          onTap: (){
                            showDialog(context: context, builder:
                                (context) {
                              return AlertDialog(
                                title: Text('Options'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap:(){
                                        Navigator.of(context).pop();
                                        resetPassword(doctor.id);
                                      },
                                      child: Text('Reset Password'),
                                    ),
                                    Divider(),
                                    InkWell(
                                      onTap:(){
                                        Navigator.of(context).pop();
                                        updateAccountStatus(doctor.id, doctor['status']=='Active'?'Rejected':'Active');
                                      },
                                      child: Text(doctor['status']=='Active'?'Deactivate Account':'Activate Account'),
                                    ),
                                  ],
                                ),
                              );
                            },);
                          },
                            child: Icon(Icons.menu)),
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
      floatingActionButton: InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>  AddDoctorPage(hospital_id: widget.hospital_id,hospital_name: widget.hospital_name,)));
        },
        child: CircleAvatar(
          radius: 30,
          backgroundColor: primaryColor.shade900,
          child: const Icon(Icons.add,color: Colors.white,),
        ),
      ),

    ));
  }
}
