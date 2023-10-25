import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/models/helper.dart';
import 'package:e_cure_app/pages/add_hospital_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Hospitals extends StatefulWidget {
  const Hospitals({Key? key}) : super(key: key);

  @override
  State<Hospitals> createState() => _HospitalsState();
}

class _HospitalsState extends State<Hospitals> {


  getHospitals(){
    var _firestore=FirebaseFirestore.instance;
    return _firestore.collection("Users")
        .where("type",isEqualTo: "Hospital")
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
      var snackBar=const SnackBar(content: Text('Password has been reset to default'));
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
      var snackBar=const SnackBar(content: Text('Status has been updated'));
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
                  children: snapshot.data!.docs.map((hospitalDoc) {
                    print(hospitalDoc.id);

                    return ListTile(

                      leading: Icon(FontAwesomeIcons.hospital,color:hospitalDoc['status']=="Active"? primaryColor.shade900:Colors.red,),
                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(hospitalDoc["name"],style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),
                        Text( "Doctors:" + hospitalDoc["doctors_count"].toString()),
                        ],
                      ),
                      trailing:InkWell(
                        onTap: (){
                          showDialog(context: context, builder:
                              (context) {
                            return AlertDialog(
                              title: const Text('Options'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap:(){
                                      Navigator.of(context).pop();
                                      resetPassword(hospitalDoc.id);
                                    },
                                    child: const Text('Reset Password'),
                                  ),
                                  const Divider(),
                                  InkWell(
                                    onTap:(){
                                      Navigator.of(context).pop();
                                      updateAccountStatus(hospitalDoc.id, hospitalDoc['status']=='Active'?'Rejected':'Active');
                                    },
                                    child: Text(hospitalDoc['status']=='Active'?'Deactivate Account':'Activate Account'),
                                  ),
                                ],
                              ),
                            );
                          },);
                        } ,
                          child: Icon(Icons.menu))
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
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AddHospital()));
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
