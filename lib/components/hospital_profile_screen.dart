import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/edit_hospital_profile.dart';
import 'package:e_cure_app/pages/edit_patient_profile.dart';
import 'package:e_cure_app/pages/login_page.dart';
import 'package:flutter/material.dart';

class HospitalProfileScreen extends StatefulWidget {
   HospitalProfileScreen({Key? key, this.hospital_id}) : super(key: key);
   final hospital_id;

  @override
  State<HospitalProfileScreen> createState() => _HospitalProfileScreenState();
}

class _HospitalProfileScreenState extends State<HospitalProfileScreen> {

 // String? image_url;
  var  hospital_doc;
 // String? age;
  //String? ailments;

  bool _isLoading=false;




loadUserInfo()async{
  setState(() {
    _isLoading=true;
  });
  print(widget.hospital_id);
  FirebaseFirestore.instance
      .collection("Users")
      .doc(widget.hospital_id)
      .get()
      .then((doc) {
    setState(() {
    //  image_url=doc.get("image_url");
      hospital_doc=doc;
   //  age=doc.get("age");
     // ailments=doc.get("ailments");
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
                          backgroundImage:hospital_doc['image_url']==null?null: NetworkImage(hospital_doc['image_url']),
                          child:hospital_doc['image_url']!=null?SizedBox():Icon(Icons.person,color: Colors.white,size: 40,)
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(child: SizedBox()),
                //Icon(Icons.edit,size: 30,color: primaryColor.shade900,),
                IconButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditHospitalProfile(profile_id: widget.hospital_id),))
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
            child: Text(hospital_doc["name"]!,
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text("Description",style: TextStyle(color: greyColor.shade900,fontSize: 17,fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(hospital_doc["description"],style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text("Phone",style: TextStyle(color: greyColor.shade900,fontSize: 17,fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(hospital_doc["phone"],style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
          ),





        ],
      ),
    ));
  }
}
