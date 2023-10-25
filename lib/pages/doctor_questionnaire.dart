

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/components/custom_text_field.dart';
import 'package:e_cure_app/constants.dart';
import 'package:flutter/material.dart';

class DoctorQuestionnaire extends StatefulWidget {
    DoctorQuestionnaire({Key? key, this.doctor_id}) : super(key: key);
  final doctor_id;




  @override
  State<DoctorQuestionnaire> createState() => _DoctorQuestionnaireState();
}

class _DoctorQuestionnaireState extends State<DoctorQuestionnaire> {
  List questions=[

  ];
  final _questionController=TextEditingController();
  loadQuestions()async{
    FirebaseFirestore.instance.collection("Users")
        .doc(widget.doctor_id)
        .get()
        .then((doc) {
          if(doc.data()!.containsKey("questions")) {
            setState(() {
              questions=doc.get("questions");
            });

          }
    });
  }

  updateQuestions(){
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.doctor_id)
        .update({
      "questions":questions
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:Scaffold(
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
                Text('Questions',style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: primaryColor.shade900
                ),),
              ],
            ),
          ),
        ),
          Expanded(child: ListView(
            children:questions.map((e) =>
            ListTile(title: Text(e),
             trailing: IconButton(onPressed: (){
               setState(() {
                 questions.remove(e);
                 updateQuestions();
               });
             },icon: Icon(Icons.delete),),)).toList(),
          ))
          ,]),

      floatingActionButton:  InkWell(
        onTap: (){
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              content: CustomTextField("Question",
                  "Add Question",
                  TextInputType.text,
                 _questionController , null, null, false),
              actions: [
                ElevatedButton(onPressed: (){
                  if(_questionController.text.isNotEmpty)
                    {
                      setState(() {
                        questions.add(_questionController.text);
                      });
                     updateQuestions();
                    }
                  _questionController.text="";

                  Navigator.of(context).pop();
                }, child:
                const Text("Save")),
                ElevatedButton(onPressed: (){
                  Navigator.of(context).pop();
                }, child:
                const Text("Cancel")),
              ],
            );
          },);
            },
        child: CircleAvatar(
          radius: 30,
          backgroundColor: primaryColor.shade900,
          child: const Icon(Icons.add,color: Colors.white,),
        ),
      ),
    ) );
  }
}
