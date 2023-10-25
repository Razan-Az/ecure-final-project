import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/components/custom_button.dart';
import 'package:e_cure_app/components/custom_text_field.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/models/helper.dart';
import 'package:flutter/material.dart';

class UpdatePassword extends StatefulWidget {
   UpdatePassword({Key? key, this.user_id}) : super(key: key);
  final user_id;

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {

  final _passwordController=TextEditingController();
  final _currentPasswordController=TextEditingController();
  final _confirmPasswordController=TextEditingController();

  final GlobalKey<FormState> _key=GlobalKey<FormState>();

  var _isLoading=false;
  var _isError=false;
  var _error="";




  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Form(
        key: _key,
        child: ListView(
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
                  Text('Update Password',style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: primaryColor.shade900
                  ),)])))
            ,

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                    child: CustomTextField(
                        "Current Password",
                        "Enter current Password....",
                        TextInputType.text,
                        _currentPasswordController,
                            (value){
                          if(value.isEmpty) {
                            return "Required Field";
                          }

                        },
                        true,
                        true
                    ),
                  ),
            const SizedBox(height: 15,),
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
                        _confirmPasswordController,
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
                    child:   CustomButton(text: "Update",color: primaryColor.shade900,
                      onClick: ()async{
                        if(_key.currentState!.validate())
                        {
                          FocusScope.of(context).requestFocus(FocusNode());


                          setState(() {
                            _isLoading=true;
                          });

                          var doc=await FirebaseFirestore.instance
                              .collection("Users")
                              .doc(widget.user_id)
                              .get();
                          if(doc.get('password')!=Helper().hashPassword(_currentPasswordController.text)) {
                            setState(() {
                              _isLoading=false;
                              _isError=true;
                              _error="Wrong current Password";
                            });
                            return;
                          }

                          var _firestore=FirebaseFirestore.instance;
                          _firestore.collection("Users")
                              .doc(widget.user_id)
                              .update({
                            "password":Helper().hashPassword(_passwordController.text),

                          })
                              .then((value){
                            setState(() {
                              _isLoading=false;
                            });
                            Navigator.of(context).pop();
                            var snackBar=const SnackBar(content: Text('Password was updated successfully'));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
          ),
        );

  }
}
