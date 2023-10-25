import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/components/custom_button.dart';
import 'package:e_cure_app/components/custom_text_field.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/models/helper.dart';
import 'package:flutter/material.dart';

class AddHospital extends StatefulWidget {
  const AddHospital({Key? key}) : super(key: key);

  @override
  State<AddHospital> createState() => _AddHospitalState();
}

class _AddHospitalState extends State<AddHospital> {
  GlobalKey<FormState> _key=GlobalKey<FormState>();

  final _nameController=TextEditingController();
  final _loginNameController=TextEditingController();
  final _passwordController=TextEditingController();
  String? selected_city_id=null;
  String selected_city_name="";

  List cities=[];
  getCities(){

     FirebaseFirestore.instance
        .collection("cities")
        .get().then((docs) {
          setState(() {
            _isLoadingCities=false;
            cities=docs.docs;
          });
     });
  }

  bool _isLoading=false;
  bool _isLoadingCities=false;


  String _error="";
  bool _isError=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCities();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Column(
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
                  Text('Add Hospital',style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: primaryColor.shade900
                  ),),
                ],
              ),
            ),
          ),
          Expanded(
            child: Form(
              key: _key,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                    child: CustomTextField(
                        "Hospital Name",
                        "Enter Hospital Name...",
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
                        "Hospital Login Name",
                        "Enter Hospital Login Name...",
                        TextInputType.text,
                        _loginNameController,
                            (value)  {
                          print("validator");
                          if(value.isEmpty) {
                            return "Required Field";
                          }
                          if(!RegExp(r"^[A-Za-z][A-Za-z0-9_]{6,30}$").hasMatch(value))
                          {return 'User name should be 6 to 30 characters \n'
                              'Not beginning with numbers\nNot containing whitespaces'
                          ;}


                          return null;
                        },
                        null,
                        false
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                    child: CustomTextField(
                        "Password",
                        "Enter Password",
                        TextInputType.text,
                        _passwordController ,
                            (value)  {
                          print("validator");
                          if(value.isEmpty) {
                            return "Required Field";
                          }
                          if(value.toString().length<6)
                            {
                              return "Password should be at least 6 characters";
                            }

                          return null;
                        },
                        null,
                        false
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("City",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: _isLoadingCities?
         const Center(child: CircularProgressIndicator())

                                : DropdownButton
                                  ( isExpanded:true,
                                  value:selected_city_id ,
                                    items:
                                    cities
                                    .map((e) => DropdownMenuItem(
                                        value: e.id,
                                        child: Text(e["name"]),) ).toList()
                                    , onChanged: (value){
                                    setState(() {
    selected_city_id=value.toString();
    var selected=cities.where((el) => el.id==value.toString()).first;
    selected_city_name= selected["name"];
    });})



                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 15),
                    child:   CustomButton(text: "Save",color: primaryColor.shade900,
                      onClick: ()async{
                        if(_key.currentState!.validate())
                        {
                          FocusScope.of(context).requestFocus(FocusNode());

                          if(selected_city_id==null)
                            {
                              setState(() {
                                _isError=true;
                                _error="Select City";
                              });
                              return;
                            }
                          
                          setState(() {
                            _isLoading=true;
                          });

                          var doc=await FirebaseFirestore.instance
                              .collection("Users")
                              .doc(_loginNameController.text.toLowerCase())
                              .get();
                          if(doc.exists) {
                            setState(() {
                              _isLoading=false;
                              _isError=true;
                              _error="Login name alrady taken...try another one ";
                            });
                            return;
                          }


                          var _firestore=FirebaseFirestore.instance;
                          _firestore.collection("Users")
                              .doc(_loginNameController.text.toLowerCase())
                              .set({
                            "name" : _nameController.text,
                            "login_name" :_loginNameController.text.toLowerCase(),
                            "password":Helper().hashPassword(_passwordController.text),
                            "city_name":selected_city_name,
                            "city_id":selected_city_id,
                            "type":"Hospital",
                            "doctors_count":0,
                            "complete_profile":false,
                            "specialities":{},
                            "status" :"Active"
                          })
                              .then((value){
                            Navigator.of(context).pop();
                            FirebaseFirestore.instance
                                .collection("cities")
                                .doc(selected_city_id)
                                .update({
                              "hospitals_count":FieldValue.increment(1)
                            });
                          }).catchError((){
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
          )
        ],
      ),));
  }
}
