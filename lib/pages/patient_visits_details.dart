import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/models/helper.dart';
import 'package:e_cure_app/pages/doctor_appointment_details.dart';
import 'package:e_cure_app/pages/patient_appointment_view.dart';
import 'package:flutter/material.dart';

class PatientVisitsDetails extends StatefulWidget {
  const PatientVisitsDetails({Key? key, this.patient_id}) : super(key: key);
  final patient_id;

  @override
  State<PatientVisitsDetails> createState() => _DoctorAppointmentsState();
}

class _DoctorAppointmentsState extends State<PatientVisitsDetails> {



  var statusList=[
    "Today",
    "Upcoming",
    "Missed",

    "Done"
  ];

  var _selectedStatus="Today";

  getDoctorAppointments() {

    var now=DateTime.now();

    if(_selectedStatus=="Today") {
      return FirebaseFirestore.instance
          .collection("appointments")
          .where("patient_id", isEqualTo: widget.patient_id)
          .where("appointment_date",isGreaterThanOrEqualTo: now.getDateOnly())
          .where("appointment_date",isLessThan: now.add(Duration(days: 1)).getDateOnly())
          .where("status", isEqualTo: "Scheduled")

          .snapshots();
    }
    if(_selectedStatus=="Upcoming") {

      return FirebaseFirestore.instance
          .collection("appointments")
          .where("patient_id", isEqualTo: widget.patient_id)
          .where("appointment_date",isGreaterThanOrEqualTo: now.add(Duration(days: 1)).getDateOnly())
       //   .where("appointment_date",isLessThan: now.add(Duration(days: 2)).getDateOnly())


          .snapshots();
    }
    if(_selectedStatus=="Missed") {
      return FirebaseFirestore.instance
          .collection("appointments")
          .where("patient_id", isEqualTo: widget.patient_id)
          .where("status",isEqualTo: "Scheduled")
          .where("appointment_date",isLessThan: now.getDateOnly())

          .snapshots();
    }

    if(_selectedStatus=="Done") {
      return FirebaseFirestore.instance
          .collection("appointments")
          .where("patient_id", isEqualTo: widget.patient_id)
          .where("status",isEqualTo:"Done" )
          .snapshots();
    }
  }



  getStatusText(status,DateTime date,String time_slot){
    TextStyle style=TextStyle() ;
    var time = time_slot.split(':');
    var h = int.parse(time[0]);
    var m = int.parse(time[1]);

    date=date.copyWith(hour: h,minute: m);
    bool isMissed=status=="Scheduled"?
    date.isBefore(DateTime.now())  :false;
    if(isMissed)
    {
      style= TextStyle(color:
      Colors.red,fontSize: 10);

      return Text("Missed",style:style ,);
    }

    switch(status){
      case 'Done':
        {
          style= TextStyle(color:
          Colors.green,fontSize: 10);
          break;
        }
      case 'Scheduled':
        {
          style= TextStyle(color:
          Colors.orange,fontSize: 10);
          break;
        }
      case 'Cancelled':
        {
          style= TextStyle(color:
          Colors.red,fontSize: 10);
          break;
        }
    }

    return Text(status,style:style ,);
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body:
      Column(
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
                  Text('Visits',style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: primaryColor.shade900
                  ),),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 5),
            child: SizedBox(
              height: 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      selectedColor: primaryColor.shade900,
                      label: Text(statusList[index],
                        style: TextStyle(color: _selectedStatus==statusList[index]?Colors.white:Colors.black,
                            fontWeight:_selectedStatus==statusList[index]? FontWeight.bold:FontWeight.normal),
                      ),
                      selected: _selectedStatus==statusList[index],
                      onSelected: (selected){
                        if(selected)
                        {
                          setState(() {
                            _selectedStatus=statusList[index];
                          });
                        }
                      },
                    ),
                  );
                },
                itemCount: statusList.length,
              ),
            ),
          ),

          Expanded(child:
          StreamBuilder<QuerySnapshot>(
            stream: getDoctorAppointments(),
            builder: (context, snapshot) {
              if(snapshot.hasError)
              {
                return Center(child: Text("Error :${snapshot.error}"),);
              }

              if(snapshot.connectionState==ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: primaryColor.shade900,));
              }
              else

              if(snapshot.data!.docs.isEmpty)
              {
                return const Center(child: Text("No Records"),);
              }

              List docs=snapshot.data!.docs;
              docs.sort(( a, b) {
                Timestamp t1=b['appointment_date'];
                Timestamp t2=a['appointment_date'];
                var btime = b['appointment_time'].split(':');
                var bh = int.parse(btime[0]);
                var bm = int.parse(btime[1]);

                var atime = a['appointment_time'].split(':');
                var ah = int.parse(atime[0]);
                var am = int.parse(atime[1]);

                if(t1!=t2) {
                  return t1.seconds-t2.seconds;
                }else if(ah!=bh){
                  return bh-ah;
                }
                else{
                  return bm-am;
                }

              });

              return ListView(
                  children: docs.map((appointment) {
                    Timestamp appTimestamp=appointment["appointment_date"];
                    DateTime dt=appTimestamp.toDate();

                    return InkWell(
                      onTap: (){
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => PatientAppointmentsView(appointment_id: appointment.id),));
                      },
                      child: ListTile(
                          leading: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.person,color: primaryColor.shade900,),
                              getStatusText(appointment["status"],appointment["appointment_date"].toDate(),appointment["appointment_time"])
                            ],
                          ),
                          title: Text(appointment["doctor_name"],style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          trailing: Text("${dt.year}-${dt.month}-${dt.day} ${appointment["appointment_time"]}")),
                    );

                  }
                  )
                      .toList()
              );
            },
          )
          )
        ],
      ),


    ));
  }
}


