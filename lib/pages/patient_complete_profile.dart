import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/components/custom_button.dart';
import 'package:e_cure_app/components/custom_text_field.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/patient_home_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class PatientCompleteProfilePage extends StatefulWidget {
    PatientCompleteProfilePage({Key? key, this.user_name}) : super(key: key);
  final user_name;

  @override
  State<PatientCompleteProfilePage> createState() => _PatientCompleteProfilePageState();
}

class _PatientCompleteProfilePageState extends State<PatientCompleteProfilePage> {
  TextEditingController _nameController=TextEditingController();
  TextEditingController _ageController=TextEditingController();
  TextEditingController _ailmentsController=TextEditingController();
  TextEditingController _phoneController=TextEditingController();
  TextEditingController _emailController=TextEditingController();

  GlobalKey<FormState> _key=GlobalKey<FormState>();


  bool _isLoading=false;

  String selected_gender="Male";
  File? imageFile;
  String image_url="";


  String _error="";
  bool _isError=false;

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

            InkWell(
              onTap: (){
              showImageDialog(context);
              },
              child: Center(
                child:
                CircleAvatar(
                  radius: 50,
                  backgroundImage: imageFile==null?null:FileImage(imageFile!),
                  child:imageFile==null? const Icon(Icons.person,size: 50,):
                  const SizedBox(),
                ),
              ),
            ),
            const SizedBox(height: 5,),
            const Center(
              child: Text("Upload a photo for us to easily identify you"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
              child: CustomTextField(
                  "Your name",
                  "Enter your name...",
                  TextInputType.text,
                  _nameController,
                      (value){
                    print("validator");
                    if(value.isEmpty) {
                      return "Required Field";
                    }
                    return null;
                  },
                  null,
                  false
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
              child: CustomTextField(
                  "Your email",
                  "Enter your email...",
                  TextInputType.emailAddress,
                  _emailController,
                      (value){
                    print("validator");
                    if(value.isEmpty) {
                      return "Required Field";
                    }

                    final bool emailValid =
                    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value);
                    if(!emailValid)
                    {
                      return "Bad email format";
                    }
                    return null;
                  },
                  null,
                  false
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
              child: CustomTextField(
                  "Age",
                  "Enter your Age ...",
                  TextInputType.number,
                  _ageController,
                      (value){
                    print("validator");
                    if(value.isEmpty) {
                      return "Required Field";
                    }
                    num age=num.parse(value);

                    if(age <10 || age >100) {
                      return "Enter valid age";
                    }

                  },
                  null,
                  false
              ),
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
              child: CustomTextField(
                  "Ailments",
                  "List your ailments here...",
                  TextInputType.text,
                  _ailmentsController,
                      (value){
                    print("validator");
                    if(value.isEmpty) {
                      return "Required Field";
                    }
                    return null;
                  },
                  null,
                  false
              ),
            ),
            const SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("Gender",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child:  DropdownButton
                            (
                              value:selected_gender ,
                              items:const [DropdownMenuItem(
                                value:"Male",
                                child: Text("Male"),),
                              DropdownMenuItem(
                              value:"Female",
                              child: Text("Female"),)]
                              , onChanged: (value){
                            setState(() {
                              selected_gender=value.toString();
                            });


                          })
                        ,
                      ),

                  )
                ],
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

                    var docs=await FirebaseFirestore.instance
                        .collection("Users")
                        .where("email",isEqualTo: _emailController.text)
                        .get()
                    ;

                    if(docs.size>0) {
                      setState(() {
                        _isLoading=false;
                        _isError=true;
                        _error="Email is already existed in the system..";
                      });
                      return;
                    }

                    if(imageFile!=null) {
                      var uuid = Uuid();
                      var ref = FirebaseStorage.instance.ref();
                      var imagePath = ref.child("images/${uuid.v1()}");
                     await imagePath.putFile(imageFile!);
                     image_url= await imagePath.getDownloadURL();

                    }







                    var _firestore=FirebaseFirestore.instance;
                    _firestore.collection("Users")
                        .doc(widget.user_name)
                        .update({
                      "name" :_nameController.text,
                      "ailments":_ailmentsController.text,
                      "age":_ageController.text,
                      "gender":selected_gender,
                      "image_url":image_url,
                      "phone":_phoneController.text,
                      "email":_emailController.text,
                      "complete_profile":true
                    })
                        .then((value){
                          Navigator.of(context).pop();
                       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PatienthomePage(user_name: widget.user_name.toLowerCase(), full_name: _nameController.text,)));
                    }).catchError((e){
                      setState(() {
                        _isLoading=false;
                        _isError=true;
                        _error="An error occurred";
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
