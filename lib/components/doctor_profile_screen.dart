import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/edit_doctor_profile.dart';
import 'package:e_cure_app/pages/edit_patient_profile.dart';
import 'package:e_cure_app/pages/login_page.dart';
import 'package:flutter/material.dart';

class DoctorProfileScreen extends StatefulWidget {
   DoctorProfileScreen({Key? key, this.patient_id}) : super(key: key);
   final patient_id;

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {


  bool _isLoading=false;
  var doctorDoc;




loadUserInfo()async{
  setState(() {
    _isLoading=true;
  });
  print(widget.patient_id);
  FirebaseFirestore.instance
      .collection("Users")
      .doc(widget.patient_id)
      .get()
      .then((doc) {
    setState(() {
      doctorDoc=doc;
      _isLoading=false;
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
    return SafeArea(child:
    Scaffold(
      body:_isLoading?
          Center(
            child: CircularProgressIndicator(color: primaryColor.shade900,),
          ):
      ListView(
        children: [
         const SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundColor: Colors.deepPurple,
                       ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 32,
                          backgroundImage:doctorDoc['image_url']==null?null: NetworkImage(doctorDoc['image_url']),
                          child:doctorDoc['image_url']==null? Icon(Icons.person,color: Colors.white,size: 40,):SizedBox(),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(child: SizedBox()),
                //Icon(Icons.edit,size: 30,color: primaryColor.shade900,),
                IconButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditDoctorProfile(profile_id: widget.patient_id),))
                  .then((value) {
                    loadUserInfo();
                  });
                }, icon: Icon(Icons.edit,size: 30,color: primaryColor.shade900,))
                ,SizedBox(width: 15,),
                IconButton(onPressed: (){
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage(),));

                }, icon: Icon(Icons.logout,size: 30,color: orangeColor,))

              ],
            ),

          ),
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(doctorDoc['name'],
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text("Phone",style: TextStyle(color: greyColor.shade900,fontSize: 17,fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(doctorDoc['phone'],style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
          ),
          



        ],
      ),
    ));
  }
}
