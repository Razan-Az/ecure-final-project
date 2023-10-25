import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/components/custom_area_text_field.dart';
import 'package:e_cure_app/components/custom_button.dart';
import 'package:e_cure_app/components/custom_text_field.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/appointment_time_select.dart';
import 'package:flutter/material.dart';

class PatientEditAppointment extends StatefulWidget {
  PatientEditAppointment({Key? key, this.appointment_id, }) : super(key: key);
  final appointment_id;



  @override
  State<PatientEditAppointment> createState() => _PatientEditAppointmentState();
}

class _PatientEditAppointmentState extends State<PatientEditAppointment> {


  final _nameController=TextEditingController();
  final _descriptionController=TextEditingController();






  var appointment_date;

  var _bookFor="Myself";

  var patient_name;
  var patient_email;

  var hospital_name;
  var hospital_id;


  var questions=[];

  var answers=[];

  bool _isLoading=false;

  int current_question=0;

  String date_time="";
  String _selectedPrivacy="None";

  var _selected_date;
  var _selected_time;


  GlobalKey<FormState> _key=GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _globalKey=GlobalKey<ScaffoldState>();

  var appointmentData;
  var appoint_date;


  getAppointmentDetails()async{

    setState(() {
      _isLoading=true;
    });

    FirebaseFirestore.instance
        .collection("appointments")
        .doc(widget.appointment_id)
        .get()
        .then((appointment) {
      setState(() {
        appointmentData=appointment.data();
        _isLoading=false;
        Timestamp timestamp=appointmentData["appointment_date"];
        appoint_date=timestamp.toDate();
        questions=appointment["questions"];
        answers=appointment["answers"];
        _descriptionController.text=appointment["description"];
        _selectedPrivacy=appointment["privacy_level"];
        _selected_time=appointment["appointment_time"];
         _selected_date=appoint_date;
        date_time =
        "${_selected_date.day}-${_selected_date.month}-${_selected_date.year}  ${_selected_time}";
      });
    });

  }





  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getAppointmentDetails();




  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      key: _globalKey,
      body: Form(
        key: _key,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, icon: const Icon(Icons.arrow_back_ios)),

                  const Text('Book Appointment',style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,

                  ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23,vertical: 10),
              child: Text('Fill out the information below in order to book your appointment',
                style: TextStyle(color: greyColor.shade900),),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 23,vertical: 10),
            //   child: Row(
            //     children: [
            //       Text('Booking For:',style: TextStyle(fontWeight: FontWeight.bold),),
            //       SizedBox(width: 10,),
            //       DropdownButton(
            //           value:_bookFor ,
            //           items: [
            //             DropdownMenuItem(child: Text('Myself'),value: "Myself",),
            //             DropdownMenuItem(child: Text('Another One'),value: 'Others',),
            //           ], onChanged: (value){
            //         setState(() {
            //           _bookFor=value!;
            //         });
            //       })
            //     ],
            //   ),
            // ),
            // _bookFor=='Others'?
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 23,vertical: 10),
            //   child: CustomTextField("Patient Name", "Enter name ...", TextInputType.emailAddress,
            //       _nameController,
            //           (value){
            //         if(value.toString().isEmpty)
            //         {
            //           return "Required field";
            //         }
            //
            //
            //       }
            //       , null, false),
            // ):SizedBox(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23,vertical: 10),
              child: CustomTextArea("Description", "What's the problem?(Optional)"
                  , TextInputType.multiline,
                  _descriptionController,
                  null
                  , null, false),
            ),

            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23,vertical: 10),
                child:Row(
                  children: [
                    Text('Doctor can read ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                    Expanded(
                      child: DropdownButton(
                          value:_selectedPrivacy ,
                          items: [
                            DropdownMenuItem(child: Text('None'),value: "None",),
                            DropdownMenuItem(child: Text('Prescription Only'),value: 'Prescription',),
                            DropdownMenuItem(child: Text('Diagnosis Only'),value: 'Diagnosis',),
                            DropdownMenuItem(child: Text('All'),value: 'All',),
                          ], onChanged: (value){
                        setState(() {
                          _selectedPrivacy=value!;
                        });
                      }),
                    )
                  ],
                )
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23,vertical: 10),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    color: greyColor.shade50,
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Please Answer the questionnaire' ,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor.shade900
                      ),),_isLoading?
                    const Center(child: CircularProgressIndicator()):SizedBox(),
                    ...questions.map((question) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(question,style: TextStyle(
                            fontSize: 18
                        ),),
                        Row(
                          children: [
                            ChoiceChip(label: Text('Yes',style: TextStyle(
                                color: answers[questions.indexOf(question)]=='Yes'?Colors.white:Colors.black
                            )), selected: answers[questions.indexOf(question)]=='Yes',
                              selectedColor: primaryColor.shade800,
                              onSelected: (value){
                                setState(() {
                                  if(value)
                                  {
                                    answers[questions.indexOf(question)]='Yes';
                                  }
                                });
                              },),
                            ChoiceChip(label: Text('No',style: TextStyle(
                                color: answers[questions.indexOf(question)]=='No'?Colors.white:Colors.black
                            ),), selected: answers[questions.indexOf(question)]=='No',
                              selectedColor: primaryColor.shade800,

                              onSelected: (value){
                                setState(() {
                                  if(value)
                                  {
                                    answers[questions.indexOf(question)]='No';
                                  }
                                });
                              },)
                          ],
                        )
                      ],
                    )).toList(),

                  ],
                ),
              ),


            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23,vertical: 10),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    color: greyColor.shade50,
                    borderRadius: BorderRadius.circular(12)
                ),
                child: InkWell(
                  onTap: ()async{
                    List time=await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) =>
                        AppointmentsTimeSelect(doctor_id: appointmentData["doctor_id"])
                      ,));
                    if(time.isNotEmpty) {
                      setState(() {
                        DateTime date = time[0];
                        String time_slot = time[1];
                        _selected_date = date;
                        _selected_time = time_slot;

                        date_time =
                        "${date.day}-${date.month}-${date.year}  ${time_slot}";
                      });
                    }

                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Choose Date & Time'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(date_time,style: TextStyle(
                              color: primaryColor.shade800
                          ),),
                          Icon(Icons.today,color: greyColor.shade900,)
                        ],
                      )
                    ],
                  ),
                ),
              ),


            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23,vertical: 10),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton( onClick: (){
                    Navigator.of(context).pop();
                  }, text: 'Cancel',
                    color: greyColor.shade600,),
                  CustomButton( onClick: (){


                    if(_key.currentState!.validate())
                    {

                      if(_selected_date==null)
                      {

                        var snackBar=const SnackBar(content: Text('You should select date and time'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        return;
                      }



                      setState(() {
                        _isLoading=true;
                      });

                      FirebaseFirestore.instance
                          .collection("appointments")
                          .doc(widget.appointment_id)
                          .update(
                          {

                            "appointment_date":_selected_date,
                            "appointment_time":_selected_time,
                            "questions":questions,
                            "description":_descriptionController.text,
                            "answers":answers,
                            "status":"Scheduled",
                            "privacy_level":_selectedPrivacy
                          }
                      ).then((value) {
                        var snackBar=const SnackBar(content: Text('Appointment was updated successfully'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        setState(() {
                          _isLoading=false;
                        });
                        Navigator.of(context).pop();
                      }).catchError((e){
                        var snackBar=const SnackBar(content: Text('An error occurred'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        setState(() {
                          _isLoading=false;
                        });
                      });
                    }

                  }, text: 'Update',
                    color: primaryColor.shade900,)
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}


