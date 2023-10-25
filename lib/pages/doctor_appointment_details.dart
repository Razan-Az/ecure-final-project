import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/components/custom_area_text_field.dart';
import 'package:e_cure_app/components/custom_button.dart';
import 'package:e_cure_app/components/custom_text_field.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/patient_medical_report.dart';
import 'package:flutter/material.dart';

class DoctorAppointmentsDetails extends StatefulWidget {
   DoctorAppointmentsDetails({Key? key, this.appointment_id, this.doctor_id}) : super(key: key);
  final appointment_id;
  final doctor_id;

  @override
  State<DoctorAppointmentsDetails> createState() => _DoctorAppointmentsDetailsState();
}

class _DoctorAppointmentsDetailsState extends State<DoctorAppointmentsDetails> {

  bool _isLoading=false;
  bool _isWorking=false;
  final _diagnosisController=TextEditingController();
  final _prescriptionController=TextEditingController();

  bool _sameDoctor=false;
  bool _isDone=false;
  bool _isMissed=false;

  var appointmentData;
  DateTime? appoint_date;
  var questions=[];
  var answers=[];

  var diagnosis="";
  var prescription="";
  var _privacy_level="None";





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
        questions=appointment.get("questions");
        answers=appointment.get("answers");
        _sameDoctor= widget.doctor_id==appointmentData["doctor_id"];

        _isDone=appointmentData["status"]=="Done";
        if(appointment.data()!.containsKey("privacy_level"))
          {
            _privacy_level=appointmentData['privacy_level'];
          }
        var date=timestamp.toDate();
        var time = appointmentData["appointment_time"].split(':');
        var h = int.parse(time[0]);
        var m = int.parse(time[1]);
        var hour=DateTime.now().hour;
        var mins=DateTime.now().minute;
        _isMissed=date.isBefore(DateTime.now()) && (h<hour || (h==hour && m<mins) );


        if(!_sameDoctor)
          {
            diagnosis=appointment.get("diagnosis");
            prescription=appointment.get("prescription");
          }

      });
    });

  }

  getQuestionnaire(){
    List<Widget> questionnaire=[];
     for(int i=0;i<questions.length;i++)
       {
         questionnaire.add(Text(questions[i],style: const TextStyle(
           fontSize: 21,color: Colors.grey
         ),));
         questionnaire.add(Text(answers[i],
             style: const TextStyle(
                 fontSize: 22,fontWeight: FontWeight.bold
             )
         ));
       }
     return Column(
       mainAxisAlignment: MainAxisAlignment.start,
       crossAxisAlignment: CrossAxisAlignment.start,
       children:questionnaire,
     ) ;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAppointmentDetails();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      body:_isLoading?
      const Center(child: CircularProgressIndicator()):
      ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(onPressed: (){
                  Navigator.of(context).pop();
                }, icon: const Icon(Icons.arrow_back_ios)),

                const Text('Appointment Details',style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,

                ))
              ],
            ),
          ),
          _isMissed?Center(
            child: Text('This is a missed Appointment'
            ,style: TextStyle(color: Colors.red,fontSize: 19),
            ),
          ):SizedBox(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Text("Patient",style: TextStyle(
                fontSize: 21, color: Colors.grey
            ),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Text(appointmentData["name"],style: const TextStyle(
                fontSize: 22,fontWeight: FontWeight.bold
            ),),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Text("When",style: TextStyle(
                fontSize: 21, color: Colors.grey
            ),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Text("${appoint_date!.year}-${appoint_date!.month}-${appoint_date!.day} "+appointmentData["appointment_time"],style: const TextStyle(
                fontSize: 22,fontWeight: FontWeight.bold
            ),),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Text("Problem",style: TextStyle(
                fontSize: 21, color: Colors.grey
            ),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Text(appointmentData["description"],style: const TextStyle(
                fontSize: 22,fontWeight: FontWeight.bold
            ),),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Text('Questionnaire',style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor.shade900
          )),
        ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: getQuestionnaire()

          ),



          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Text("Diagnosis",style: TextStyle(
                fontSize: 21, color: Colors.grey
            ),),
          ),



           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child:_sameDoctor && !_isMissed && !_isDone ? CustomTextArea(
             "Diagnosis" ,
              "Type your Diagnosis here",
              TextInputType.multiline,
              _diagnosisController,
              null,
              null,false
            ):Text(diagnosis,style: const TextStyle(
                fontSize: 22,fontWeight: FontWeight.bold)),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Text("Prescription",style: TextStyle(
                fontSize: 21, color: Colors.grey
            ),),
          ),

           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: _sameDoctor && !_isMissed && !_isDone ? CustomTextArea(
                "Prescription" ,
                "Type Prescription here",
                TextInputType.multiline,
                _prescriptionController,
                null,
                null,false
            ):Text(prescription,style: const TextStyle(
                fontSize: 22,fontWeight: FontWeight.bold)),
          ),

          _privacy_level!="None"? Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(text: 'View Medical History', color:
            greyColor.shade800, onClick: (){
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>PatientMedicalHistory(patient_id: appointmentData["patient_id"],
                    privacy_level:_privacy_level  ) ,));
            }),
          ):SizedBox(),

          _sameDoctor && !_isMissed ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(text: "Finish Appointment", color: primaryColor.shade900,
                onClick: (){
              if(_diagnosisController.text.isEmpty || _prescriptionController.text.isEmpty)
                {
                  var snackBar=const SnackBar(content: Text('Diagnosis and prescription should not be empty'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }

              setState(() {
                _isWorking=true;
              });


              FirebaseFirestore.instance
                  .collection("appointments")
                  .doc(widget.appointment_id)
                  .update({
                "diagnosis":_diagnosisController.text,
                "prescription":_prescriptionController.text,
                "status":"Done"
              }).then((value) {
                setState(() {
                  _isWorking=false;
                });
                Navigator.of(context).pop();
                var snackBar=const SnackBar(content: Text('Appointment was done successfully'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);



              }).catchError((e){
                setState(() {
                  _isWorking=false;
                  var snackBar=const SnackBar(content: Text('An error occurred!'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                });
              });
                }),
          ):const SizedBox(),


          _sameDoctor && !_isMissed?Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(onClick: (){
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: const Text('Are you sure to cancel this appointment?'),
                  actions: [
                    ElevatedButton(onPressed: ()async{
                      Navigator.of(context).pop();

                    }, child: const Text('Yes')),
                    ElevatedButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, child: const Text('No')),
                  ],
                );
              },);
            },
              color: Colors.red,text:"Cancel Appointment" ,),
          ):SizedBox(),
          _isWorking?const Center(child: CircularProgressIndicator())
              :const SizedBox()




        ],
      ),
    ));
  }
}
