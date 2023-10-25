
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/components/custom_area_text_field.dart';
import 'package:e_cure_app/components/custom_button.dart';
import 'package:e_cure_app/components/custom_text_field.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/location_picker.dart';
import 'package:e_cure_app/pages/patient_home_page.dart';
import 'package:e_cure_app/pages/update_password.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class EditHospitalProfile extends StatefulWidget {
  EditHospitalProfile({Key? key, this.profile_id}) : super(key: key);
  final profile_id;

  @override
  State<EditHospitalProfile> createState() => _EditHospitalProfileState();
}

class _EditHospitalProfileState extends State<EditHospitalProfile> {
  TextEditingController _nameController=TextEditingController();
  TextEditingController _phoneController=TextEditingController();
  TextEditingController _descriptionController=TextEditingController();

  GlobalKey<FormState> _key=GlobalKey<FormState>();


  bool _isLoading=false;
  bool _isSaving=false;


  File? imageFile;



  String _error="";
  bool _isError=false;

  late GeoPoint location;

  var hospitalDoc;
  String? image_url;





  getImage(){
    if(image_url!=null)
      {

        return NetworkImage(image_url!);
      }
    else if(
    imageFile!=null
    ) {
      return FileImage(imageFile!);
    }
    else {
      return null;
    }

  }

  loadUserInfo()async{
    setState(() {
      _isLoading=true;
    });

    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.profile_id)
        .get()
        .then((doc) {
      setState(() {
        hospitalDoc=doc;
        image_url=doc.get("image_url");
        _nameController.text=doc.get('name');
        _descriptionController.text=doc.get('description');
        _phoneController.text=doc.get("phone");
        location=doc.get('location');

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




  void pickImageCamera() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxWidth: 1000, maxHeight: 1000);
    setState(() {
      imageFile = File(pickedFile!.path);
      image_url=null;
    });
    Navigator.of(context).pop();
  }

  //--------------upload image from gallery------------------------------------
  void pickImageGallery() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 1000, maxHeight: 1000);
    setState(() {
      imageFile = File(pickedFile!.path);
      image_url=null;

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
      body:_isLoading?
      Center(child: CircularProgressIndicator()): Form(
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
                  Text('Edit Profile',style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: primaryColor.shade900
                  ),),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: InkWell(
                onTap:()=>  showImageDialog(context),

                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: softColor,
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          image:getImage(),
                          fit: BoxFit.cover

                        //   backgroundImage: imageFile==null?null:FileImage(imageFile!),
                        // child:imageFile==null? const Icon(Icons.person,size: 50,):
                        // const SizedBox(),
                      )

                  ),
                  child:  Center(
                    child:imageFile!=null|| image_url!=null?SizedBox() :Icon(Icons.add_photo_alternate,size: 40,),
                  ),
                ),
              ),
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
              child: CustomTextArea(
                  "Description",
                  "Type description here",
                  TextInputType.text,
                  _descriptionController,
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

            Center(
              child: TextButton(
                onPressed: ()async{
                  var result=await  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => const LocationPicker(),));
                  if(result==null) {
                    return;
                  }
                  setState(() {
                    location=GeoPoint(result.latitude, result.longitude) ;
                  });

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on_outlined,color: primaryColor.shade800,)
                    ,
                    Text('Update Hospital Location',style: TextStyle(
                        color: primaryColor.shade800,fontSize: 16
                    ),)
                  ],),
              ),
            ),

            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 15),
                child:CustomButton(
                  text: 'Update Password',
                  color: Colors.orange,
                  onClick: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => UpdatePassword(user_id: widget.profile_id),)
                    );

                  },
                )
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 15),
              child:   CustomButton(text: "Save Changes",color: primaryColor.shade900,
                onClick: ()async{
                  if(_key.currentState!.validate())
                  {
                    FocusScope.of(context).requestFocus(FocusNode());



                    setState(() {
                      _isSaving=true;
                    });

                    if(imageFile!=null) {
                      var uuid = Uuid();
                      var ref = FirebaseStorage.instance.ref();
                      var imagePath = ref.child("images/${uuid.v1()}");
                      await imagePath.putFile(imageFile!);
                      image_url= await imagePath.getDownloadURL();

                    }







                    var _firestore=FirebaseFirestore.instance;
                    _firestore.collection("Users")
                        .doc(widget.profile_id)
                        .update({
                      "name" :_nameController.text,
                      "image_url":image_url,
                      "phone":_phoneController.text,
                      "description":_descriptionController.text,
                      "location" :location,
                      "complete_profile":true
                    })
                        .then((value){
                      Navigator.of(context).pop();
                      }).catchError((e){
                      setState(() {
                        _isSaving=false;
                        _isError=true;
                        _error="An error occurred";
                      });

                    });



                  }

                },),
            ),
            _isSaving?
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
