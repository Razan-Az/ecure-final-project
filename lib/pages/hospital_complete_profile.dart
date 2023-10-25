import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/components/custom_area_text_field.dart';
import 'package:e_cure_app/components/custom_button.dart';
import 'package:e_cure_app/components/custom_text_field.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/hospital_home_page.dart';
import 'package:e_cure_app/pages/location_picker.dart';
import 'package:e_cure_app/pages/patient_home_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class HospitalCompleteProfile extends StatefulWidget {
    HospitalCompleteProfile({Key? key, this.user_name, this.hospital_name}) : super(key: key);
  final user_name;
  final hospital_name;

  @override
  State<HospitalCompleteProfile> createState() => _HospitalCompleteProfileState();
}

class _HospitalCompleteProfileState extends State<HospitalCompleteProfile> {

  final TextEditingController _phoneController=TextEditingController();
  final TextEditingController _descController=TextEditingController();


  var  location;

  GlobalKey<FormState> _key=GlobalKey<FormState>();


  bool _isLoading=false;





  String _error="";
  bool _isError=false;
  File? imageFile;


  void pickImageCamera() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxWidth: 1000, maxHeight: 1000);
    setState(() {
      imageFile = File(pickedFile!.path);
    });
    Navigator.of(context).pop();
  }

  //--------------upload image from gallery------------------------------------
  void pickImageGallery() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 1000, maxHeight: 1000);
    setState(() {
      imageFile = File(pickedFile!.path);

    });
    Navigator.of(context).pop();
  }

  //--------------show dialog------------------------------------
  showImageDialog(context) {
    showDialog(
        context: context,
        builder: (contex) {
          return AlertDialog(
            title: Text(
              "Pick Image from ",
              style: TextStyle(color:primaryColor.shade900),
            ),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              InkWell(
                onTap: pickImageCamera,
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        //  color: Style.purpole,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Camera",
                        //  style: TextStyle(color: Style.purpole),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: pickImageGallery,
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.image,
                        // color: Style.purpole,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Gallery",
                        //   style: TextStyle(color: Style.purpole),
                      )
                    ],
                  ),
                ),
              )
            ]),
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      body: Form(
        key: _key,
        child: ListView(
          children: [
            const SizedBox(height: 15,),
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
                  Text('Complete Profile',style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: primaryColor.shade900
                  ),),
                ],
              ),
            ),


            const SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.all(20),
              child: InkWell(
                onTap:()=>  showImageDialog(context),

                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: softColor,
                    borderRadius: BorderRadius.circular(15),
                    image:imageFile==null?null: DecorationImage(
                      image:FileImage(imageFile!,),
                    fit: BoxFit.cover

                    //   backgroundImage: imageFile==null?null:FileImage(imageFile!),
                    // child:imageFile==null? const Icon(Icons.person,size: 50,):
                    // const SizedBox(),
                    )

                  ),
                  child:  Center(
                    child:imageFile!=null?SizedBox() :Icon(Icons.add_photo_alternate,size: 40,),
                  ),
                ),
              ),
            ),
            const Center(
              child: Text("Upload a photo for hospital profile"),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
              child: CustomTextField(
                  "Phone",
                  "Enter your phone ...",
                  TextInputType.phone,
                  _phoneController,
                      (value){
                    print("validator");
                    if(value.isEmpty) {
                      return "Required Field";
                    }
                    final bool phoneValid =
                    RegExp(r"^(5|05)(5|0|3|6|4|9|1|8|7)([0-9]{7})$")
                        .hasMatch(value);
                    if(!phoneValid)
                    {
                      return "Bad phone format";
                    }

                  },
                  null,
                  false
              ),
            ),

            const SizedBox(height: 15,),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
               child: CustomTextArea(
               'Description'
               , 'Write description about the hospital',
                   TextInputType.multiline
                   , _descController,
                   (value)
                   {
                     if(value.toString().isEmpty)
                       return "Required Field";

                   }
                   , null, false),
             ),
             Center(
               child: TextButton(
                 onPressed: ()async{
                   var result=await  Navigator.of(context)
                       .push(MaterialPageRoute(builder: (context) => const LocationPicker(),));
                   setState(() {
                     location=GeoPoint(result.latitude, result.longitude) ;
                   });

                 },
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                   Icon(Icons.location_on_outlined,color: primaryColor.shade800,)
                   ,
                   Text('Set Hospital Location',style: TextStyle(
                     color: primaryColor.shade800,fontSize: 16
                   ),)
                 ],),
               ),
             ),




            const SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 15),
              child:   CustomButton(text: "Complete",color: primaryColor.shade900,
                onClick: ()async{
                  if(_key.currentState!.validate())
                  {
                    FocusScope.of(context).requestFocus(FocusNode());
                    setState(() {
                      _isLoading=true;
                    });
                    if(location==null)
                      {
                        var snackBar=const SnackBar(content: Text('you should select hospital location on the map'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }
                    String? image_url;

                    if(imageFile!=null) {
                      var uuid = Uuid();
                      var ref = FirebaseStorage.instance.ref();
                      var imagePath = ref.child("images/${uuid.v1()}");
                      await imagePath.putFile(imageFile!);
                      image_url= await imagePath.getDownloadURL();

                    }

                    //print(widget.user_name);

                    var _firestore=FirebaseFirestore.instance;
                    _firestore.collection("Users")
                        .doc(widget.user_name)
                        .update({
                      "location":location,
                      "phone":_phoneController.text,
                      "image_url":image_url,
                      "description":_descController.text,
                      "complete_profile":true
                    })
                        .then((value){
                          Navigator.of(context).pop();
                       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HospitalHomePage(hospital_id: widget.user_name.toLowerCase(), hospital_name: widget.hospital_name)));
                    }).catchError((e){
                      setState(() {
                        _isLoading=false;
                        _isError=true;
                        _error="An error occurred";
                        print(e);
                      });

                    });



                  }

                },),
            ),
            _isLoading?
            const Center(child:  CircularProgressIndicator(color: primaryColor,)):
            const SizedBox(),

            _isError? Center(
              child: Padding(padding: const EdgeInsets.all(8),
                child: Text(_error,style: const TextStyle(color: Colors.red,fontSize: 18,fontWeight: FontWeight.bold),),),
            )
                : const SizedBox(),

          ],
        ),
      ),
    ));
  }
}
