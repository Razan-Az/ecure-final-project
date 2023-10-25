

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/components/custom_button.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/appointment_time_select.dart';
import 'package:e_cure_app/pages/patient_edit_appointment_details.dart';
import 'package:flutter/material.dart';

class AppointmentDetails extends StatefulWidget {
    AppointmentDetails({Key? key, this.appointment_id}) : super(key: key);
    final appointment_id;
  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {


  bool _isLoading=false;
  bool _isWorking=false;


  var appointmentData;
  DateTime? appoint_date;





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
      });
    });

  }

  cancelAppointment()async{
    setState(() {
      _isWorking=true;
    });
    FirebaseFirestore.instance
        .collection("appointments")
        .doc(widget.appointment_id)
        .update({
      "status":"Cancelled"
    })
        .then((value) {
      setState(() {
        _isWorking=false;
      });

      Navigator.of(context).pop();
      var snackBar=const SnackBar(content: Text('Appointment was cancelled successfully'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    })
        .catchError((e){
      setState(() {
        _isWorking=false;
      });
      var snackBar=const SnackBar(content: Text('An error occurred'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    })
    ;
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

                Expanded(
                  child: const Text('Appointment Details',style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,

                  )),
                ),
                IconButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                    PatientEditAppointment(appointment_id: widget.appointment_id),));
                }, icon: Icon(Icons.edit))
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Text("Doctor",style: TextStyle(
              fontSize: 21, color: Colors.grey
            ),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Text(appointmentData["doctor_name"],style: const TextStyle(
                fontSize: 22,fontWeight: FontWeight.bold
            ),),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Text("Where",style: TextStyle(
                fontSize: 21, color: Colors.grey
            ),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Text(appointmentData["hospital_name"],style: const TextStyle(
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
            child: Text("What's the problem",style: TextStyle(
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
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(onClick:  ()async{
              List time=await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) =>
                  AppointmentsTimeSelect(doctor_id:appointmentData['doctor_id'])
                ,));
              if(time.isNotEmpty) {
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: Text('Are you sure to change the time of this appointment?'),
                  actions: [
                    TextButton(onPressed: (){

                      DateTime date = time[0];
                      String time_slot = time[1];
                      var _selected_date = date;
                      var _selected_time = time_slot;
                      FirebaseFirestore.instance
                      .collection('appointments')
                      .doc(widget.appointment_id)
                      .update({
                        'appointment_date':_selected_date,
                        'appointment_time':_selected_time,
                      }).then((value) {
                        Navigator.of(context).pop();
                        var snackBar=const SnackBar(content: Text('Appointment has been rescheduled successfully'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                         getAppointmentDetails();

                      });



                    }, child: Text('Yes',style: TextStyle(color: Colors.grey),)),
                    TextButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, child: Text('No',style: TextStyle(color: Colors.grey),)),
                  ],
                );
              },);


              }

            },
            color: primaryColor.shade900,text:"Reschedule" ,),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(onClick: (){
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: const Text('Are you sure to cancel this appointment?'),
                  actions: [
                    ElevatedButton(onPressed: ()async{
                      Navigator.of(context).pop();
                      cancelAppointment();
                    }, child: const Text('Yes')),
                    ElevatedButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, child: const Text('No')),
                  ],
                );
              },);
            },
              color: greyColor.shade800,text:"Cancel Appointment" ,),
          ),
          _isWorking?const Center(child: CircularProgressIndicator())
              :const SizedBox()


          

        ],
      ),
    ));
  }
}
