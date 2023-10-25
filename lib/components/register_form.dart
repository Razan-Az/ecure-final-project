import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/components/custom_button.dart';
import 'package:e_cure_app/components/custom_text_field.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/models/helper.dart';
import 'package:e_cure_app/pages/patient_complete_profile.dart';
import 'package:flutter/material.dart';

class Registerform extends StatefulWidget {
  const Registerform({Key? key}) : super(key: key);

  @override
  State<Registerform> createState() => _RegisterformState();
}

class _RegisterformState extends State<Registerform> {

  TextEditingController _usernameController=TextEditingController();
  TextEditingController _passwordController=TextEditingController();
  TextEditingController _passwordConfirmController=TextEditingController();

  GlobalKey<FormState> _key=GlobalKey<FormState>();


  bool _isLoading=false;


  String _error="";
  bool _isError=false;



  @override
  Widget build(BuildContext context) {
    return  Form(
      key: _key,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 25),
            child: CustomTextField(
                "Username",
                "Enter UserName ...",
                TextInputType.text,
                _usernameController,
                    (value){
                  print("validator");
                  if(value.isEmpty) {
                    return "Required Field";
                  }
                  if(!RegExp(r"^[A-Za-z][a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^@_`{|}~]{6,30}$").hasMatch(value))
                  {return 'User name should be 6 to 30 characters \n'
                      'Not beginning with numbers\nNot containing whitespaces'
                      ;}
                },
                null,
                false
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
            child: CustomTextField(
                "Password",
                "Enter Password....",
                TextInputType.text,
                _passwordController,
                    (value){
                  if(value.isEmpty) {
                    return "Required Field";
                  }
                  if(value.toString().length<6)
                    {
                      return "Password should be at least 6 characters";
                    }
                },
                true,
                true
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 25),
            child: CustomTextField(
                "Confirm Password ",
                "Confirm Password....",
                TextInputType.text,
                _passwordConfirmController,
                    (value){
                  if(value.isEmpty) {
                    return "Required Field";
                  }
                  if(value.toString()!=_passwordController.text)
                    {
                      return "Passwords don't match";
                    }
                },
                true,
                true
            ),
          ),

          const SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 15),
            child:   CustomButton(text: "Create Account",color: primaryColor.shade900,
              onClick: ()async{
                if(_key.currentState!.validate())
                {
                  FocusScope.of(context).requestFocus(FocusNode());


                  setState(() {
                    _isLoading=true;
                  });

                  var doc=await FirebaseFirestore.instance
                      .collection("Users")
                      .doc(_usernameController.text.toLowerCase())
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
                      .doc(_usernameController.text.toLowerCase())
                      .set({
                    "login_name" :_usernameController.text.toLowerCase(),
                    "password":Helper().hashPassword(_passwordController.text),
                    "type":"Patient",
                    "complete_profile":false,
                    "status":'Active'

                  })
                      .then((value){
                    setState(() {
                      _isLoading=false;
                    });
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PatientCompleteProfilePage(user_name: _usernameController.text.toLowerCase(),)));
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
    );
  }
}
