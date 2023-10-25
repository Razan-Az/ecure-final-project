import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/components/custom_button.dart';
import 'package:e_cure_app/components/custom_text_field.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/models/helper.dart';
import 'package:flutter/material.dart';

class AddDoctorPage extends StatefulWidget {
   AddDoctorPage({Key? key,required this.hospital_id, this.hospital_name}) : super(key: key);
   final hospital_id;
   final hospital_name;

  @override
  State<AddDoctorPage> createState() => _AddDoctorPageState();
}

class _AddDoctorPageState extends State<AddDoctorPage> {
  GlobalKey<FormState> _key=GlobalKey<FormState>();

  List specialities=['Allergy and immunology',
    'Anesthesiology',
    'Dermatology',
 'Diagnostic radiology',
    'Emergency medicine',
   'Family medicine',
  'Internal medicine',
   'Medical genetics',
    'Neurology',
 'Nuclear medicine',
 'Obstetrics and gynecology',
    'Ophthalmology',
    'Pathology',
    'Pediatrics',
    'Physical medicine and rehabilitation',
    'Preventive medicine',
    'Psychiatry',
    'Radiation oncology',
    'Surgery',
    'Urology'];

  final _nameController=TextEditingController();
  final _loginNameController=TextEditingController();
  final _passwordController=TextEditingController();

  var _speciality;


  bool _isLoading=false;


  String _error="";
  bool _isError=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speciality=specialities.first;
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
                  Text('Add Doctor',style: TextStyle(
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
                        "Doctor Name",
                        "Enter Doctor Name...",
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
                        "Doctor Login Name",
                        "Enter Doctor Login Name...",
                        TextInputType.text,
                        _loginNameController,
                            (value)  {
                          print("validator");
                          if(value.isEmpty) {
                            return "Required Field";
                          }
                          if(!RegExp(r"^[A-Za-z][a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^@_`{|}~]{6,30}$").hasMatch(value))
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
              child:const Text("Speciality",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
            ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Expanded(
                       child: Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
                           child:  DropdownButton
                             (

                               value:_speciality ,
                               isExpanded: true,
                               items:
                               specialities
                                   .map((e) => DropdownMenuItem(
                                 value:e,
                                 child: Text(e),) ).toList()
                               , onChanged: (value){
                             setState(() {
                               _speciality=value.toString();

                             });})



                       ),
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
                              _error="Login name already taken...try another one ";
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
                            "hospital_id":widget.hospital_id,
                            "speciality":_speciality,
                            "type":"Doctor",
                            "questions":[],
                            "hospital_name":widget.hospital_name,
                            'status':'Active',
                            "complete_profile":false


                          })
                              .then((value){
                            Navigator.of(context).pop();
                            FirebaseFirestore.instance
                            .collection("Users")
                            .doc(widget.hospital_id)
                            .update({
                              "doctors_count":FieldValue.increment(1),
                              "specialities."+_speciality:FieldValue.increment(1)
                            });
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
          )
        ],
      ),));
  }
}
