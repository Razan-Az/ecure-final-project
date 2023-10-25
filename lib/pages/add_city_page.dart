import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/components/custom_button.dart';
import 'package:e_cure_app/components/custom_text_field.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/cities_page.dart';
import 'package:flutter/material.dart';

class AddCity extends StatefulWidget {
  const AddCity({Key? key}) : super(key: key);

  @override
  State<AddCity> createState() => _AddCityState();
}

class _AddCityState extends State<AddCity> {

  var _cityController=TextEditingController();
  GlobalKey<FormState> _key=GlobalKey<FormState>();

  bool _isLoading=false;


  String _error="";
  bool _isError=false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
    body: Column(
      children: [
        SizedBox(height: 15,),
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
                SizedBox(width: 15,),
                Text('Add City',style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: primaryColor.shade900
                ),),
              ],
            ),
          ),
        ),
      Form(
        key: _key,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 25),
              child: CustomTextField(
                  "City Name",
                  "Enter City Name...",
                  TextInputType.text,
                  _cityController,
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
              padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 15),
              child:   CustomButton(text: "Save",color: primaryColor.shade900,
                onClick: (){
                  if(_key.currentState!.validate())
                  {
                    FocusScope.of(context).requestFocus(FocusNode());
                    setState(() {
                      _isLoading=true;
                    });


                    var _firestore=FirebaseFirestore.instance;
                       _firestore.collection("cities")
                    .add({
                         "name" : _cityController.text,
                         "hospitals_count" :0
                       })
                    .then((value){
                         Navigator.of(context).pop();
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
      )
      ],
    ),));
  }
}
