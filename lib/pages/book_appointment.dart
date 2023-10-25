import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/components/custom_area_text_field.dart';
import 'package:e_cure_app/components/custom_button.dart';
import 'package:e_cure_app/components/custom_text_field.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/appointment_time_select.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_cure_app/models/helper.dart';

class BookAppointment extends StatefulWidget {
   BookAppointment({Key? key, this.patient_id, this.doctor_id, this.doctor_name}) : super(key: key);
  final patient_id;
  final doctor_id;
  final doctor_name;


  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {


  final _nameController=TextEditingController();
  final _descriptionController=TextEditingController();






  var appointment_date;

  var _bookFor="Myself";

  var patient_name;
  var patient_email;

  var hospital_name;
  var hospital_id;


  var questions=[];
  var defaultQuestions=[
    "Do you have a night fever?",
    "Do you have a daily headache?",
    "Do you have a surgical history?",
    "Do you have allergies?",
    "Do you smoke?" ,
    "Do you take medicines?"
  ];
  var answers=[];

  bool _isLoading=false;

  int current_question=0;

  String date_time="";
  String _selectedPrivacy="None";

  DateTime? _selected_date;
  var _selected_time;


  GlobalKey<FormState> _key=GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _globalKey=GlobalKey<ScaffoldState>();


  loadDoctorInfo()async{
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.doctor_id)
        .get()
        .then((doc) {
      setState(() {
        hospital_name=doc.get('hospital_name');
        hospital_id=doc.get('hospital_id');
      });
    });
  }

  loadPatientInfo()async{

      FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.patient_id)
          .get()
          .then((doc) {
        setState(() {
          patient_email=doc.get('email');
          patient_name=doc.get('name');
        });
      })
      .catchError((e){
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Error while getting info..Try again") ;
      })
      ;

  }

  loadQuestionnaire()async{
setState(() {
  _isLoading=true;
});
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.doctor_id)
        .get()
        .then((doc){
          setState(() {
            print((questions));
            _isLoading=false;
            if(doc.data()!.containsKey("questions")) {
              print(doc.get("questions"));
         questions.addAll( doc.get("questions"));
         answers=List.filled(questions.length, 'No');
         print(answers);

        }
          });

    })
    .catchError((e){
      setState(() {
        _isLoading=false;
      });
    });
  }


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    try{
    questions.addAll(defaultQuestions);
    answers=List.filled(questions.length, 'No');
    loadPatientInfo();
    loadQuestionnaire();
    loadDoctorInfo();
    }
        catch(e){
      Navigator.of(context).pop();
      var snackBar=const SnackBar(content: Text('An error occurred while loading data...try again'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }


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
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23,vertical: 10),
                child: Row(
                  children: [
                    const Text('Booking For:',style: TextStyle(fontWeight: FontWeight.bold),),
                    const SizedBox(width: 10,),
                    DropdownButton(

                      value:_bookFor ,

                        items: const [
                      DropdownMenuItem(value: "Myself",child: Text('Myself'),),
                      DropdownMenuItem(value: 'Others',child: Text('Another One'),),
                    ], onChanged: (value){
                        setState(() {
                          _bookFor=value!;
                        });
                    })
                  ],
                ),
              ),
              _bookFor=='Others'?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23,vertical: 10),
                child: CustomTextField("Patient Name", "Enter name ...", TextInputType.emailAddress,
                    _nameController,
                        (value){
                      if(value.toString().isEmpty)
                      {
                        return "Required field";
                      }


                    }
                    , null, false),
              ):const SizedBox(),

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
                      const Text('Doctor can read ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                      Expanded(
                        child: DropdownButton(
                           isExpanded:true,
                            value:_selectedPrivacy ,
                            items: const [
                              DropdownMenuItem(value: "None",child: Text('None'),),
                              DropdownMenuItem(value: 'Prescription',child: Text('Prescription Only'),),
                              DropdownMenuItem(value: 'Diagnosis',child: Text('Diagnosis Only'),),
                              DropdownMenuItem(value: 'All',child: Text('All'),),
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
                      const Center(child: CircularProgressIndicator()):const SizedBox(),
                      ...questions.map((question) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(question,style: const TextStyle(
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
                         AppointmentsTimeSelect(doctor_id: widget.doctor_id)
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
                    CustomButton( onClick: ()async{


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
                          
                          //check if appointment booked or not
                          var check=await FirebaseFirestore
                          .instance.collection("appointments")
                              .where("appointment_date",isGreaterThanOrEqualTo: _selected_date!.getDateOnly())
                              .where("appointment_date",isLessThan: _selected_date!.add(Duration(days: 1)).getDateOnly())

                              .where('appointment_time',isEqualTo: _selected_time)
                          .where("doctor_id",isEqualTo:widget.doctor_id )
                          .get();
                          print(check.size);
                          if(check.size>0)
                            {
                              Fluttertoast.showToast(msg: ""
                                  "The date selected was being reserved during you booking process .. please try another date",
                              toastLength: Toast.LENGTH_LONG);
                              return;
                            }


                          await loadPatientInfo();

                          FirebaseFirestore.instance
                          .collection("appointments")
                          .add(
                            {
                              "doctor_id":widget.doctor_id,
                              "patient_id":widget.patient_id,
                              "doctor_name":widget.doctor_name,
                              "appointment_date":_selected_date,
                              "appointment_time":_selected_time,
                              "questions":questions,
                              "description":_descriptionController.text,
                              "answers":answers,
                              "email":patient_email,
                              "name":_bookFor=='Myself'?patient_name:_nameController.text,
                              "status":"Scheduled",
                              "hospital_id":hospital_id,
                              "hospital_name":hospital_name,
                              "privacy_level":_selectedPrivacy
                            }
                          ).then((value) {
                            var snackBar=const SnackBar(content: Text('Appointment was booked successfully'));
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

                    }, text: 'Book',
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






