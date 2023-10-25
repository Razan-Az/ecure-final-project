import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/doctor_appointments.dart';
import 'package:e_cure_app/pages/edit_patient_profile.dart';
import 'package:e_cure_app/pages/login_page.dart';
import 'package:flutter/material.dart';

class PatientProfileScreen extends StatefulWidget {
   PatientProfileScreen({Key? key, this.patient_id}) : super(key: key);
   final patient_id;

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {

  String? image_url;
  String? user_name;
  String? age;
  String? ailments;
  String? email;
  String? phone;

  bool _isLoading=false;



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
      image_url=doc.get("image_url");
      user_name=doc.get("name");
     age=doc.get("age");
      ailments=doc.get("ailments");
      email=doc.get("email");
      phone=doc.get("phone");
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
                          backgroundImage:image_url==null?null: NetworkImage(image_url!),
                          child:image_url==null? Icon(Icons.person,color: Colors.white,size: 40,):SizedBox(),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(child: SizedBox()),
                //Icon(Icons.edit,size: 30,color: primaryColor.shade900,),
                IconButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditPatientProfile(profile_id: widget.patient_id),))
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
            child: Text("Name",style: TextStyle(color: greyColor.shade900,fontSize: 17,fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(user_name!,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
          ),
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text("Age",style: TextStyle(color: greyColor.shade900,fontSize: 17,fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(age!,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Text("Email",style: TextStyle(color: greyColor.shade900,fontSize: 17,fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(email!,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text("Phone",style: TextStyle(color: greyColor.shade900,fontSize: 17,fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(phone!,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text("Ailments",style: TextStyle(color: greyColor.shade900,fontSize: 17,fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(ailments!,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
          ),




        ],
      ),
    ));
  }
}
