import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/components/custom_button.dart';
import 'package:e_cure_app/constants.dart';
import 'package:flutter/material.dart';

class AppointmentsTimeSelect extends StatefulWidget {
   AppointmentsTimeSelect({Key? key, this.doctor_id}) : super(key: key);
  final doctor_id;

  @override
  State<AppointmentsTimeSelect> createState() => _AppointmentsTimeSelectState();
}

class _AppointmentsTimeSelectState extends State<AppointmentsTimeSelect> {


  bool _isLoadingDate=false;
  var _selectedTime;
  List book_times=[];
  late DateTime _selected_date;

  var timeSlots=[["08:00","08:30","09:00"],
    ["09:30","10:00","10:30"],
    ["11:00","11:30","12:00"],
    ["12:30","13:00","13:30"],
    ["14:00","14:30","15:00"],
    ["15:30","16:00","16:30"],
    ["17:00","17:30",""],
  ];

  List<Widget> tableSlots=[];
  generateTimeSlots(List book_times){

    var hour=DateTime.now().hour;
    var mins=DateTime.now().minute;
    print('${hour}--');


    List<Widget> widgets=[];
    for(List slots in timeSlots)
    {
      List<Widget> rowWidgets=[];
      for(String slot in slots)
      {
        bool disabled=false;
        if(slot.isNotEmpty) {
          var time = slot.split(':');
          var h = int.parse(time[0]);
          var m = int.parse(time[1]);
          disabled=_selected_date.isEqualToDate(DateTime.now()) && (h<hour || (h==hour && m<mins) );

          print('${h}--${m}');
        }
        rowWidgets.add(timeSlot(slot,
        disabled?Colors.grey:book_times.contains(slot)?Colors.red:Colors.green,disabled ||book_times.contains(slot)));
      }
      widgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowWidgets,
      ));
    }
    setState(() {
      tableSlots=widgets;
    });
  }

  Widget timeSlot(text,bcolor,bool booked){
    return text.toString().isEmpty?const SizedBox() :Expanded(
      flex: 1,
      child: TimeSlotWidget(
        onClick: (){
          setState(() {
            _selectedTime=text;

            generateTimeSlots(book_times);

            print(_selectedTime);
          });
        },
        text: text,
        bcolor: bcolor,
        selected: _selectedTime==text,
        booked: booked,
      )
    );
  }

  getDoctorAppointments(DateTime date)async{
    setState(() {
      _isLoadingDate=true;
      book_times=[];
    });

    DateTime start= DateTime(date.year,date.month,date.day);
    DateTime end=start.add(Duration(days:1 ));
    print(start);
    print(end);
    FirebaseFirestore.instance
        .collection("appointments")
        .where("doctor_id",isEqualTo: widget.doctor_id)
        .where("appointment_date",isGreaterThanOrEqualTo:start)
       .where("appointment_date",isLessThan: end)
        .get()
        .then((appointments) {

      print(appointments.size);
      for(var appointment in appointments.docs)
      {
        book_times.add(appointment.get("appointment_time"));
      }

      generateTimeSlots(book_times);


      setState(() {
        _isLoadingDate=false;
      });
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selected_date=DateTime.now();
    getDoctorAppointments(_selected_date);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      body: ListView(
        //  mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(onPressed: (){
                  Navigator.of(context).pop();
                }, icon: const Icon(Icons.arrow_back_ios)),

                const Text('Select Appointment Date and Time',style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,

                ))
              ],
            ),
          ),
          CalendarDatePicker(

            currentDate:DateTime.now(),
            initialDate: DateTime.now(),
            lastDate:DateTime.now().add(const Duration( days: 90))
            ,firstDate:DateTime.now() ,
            initialCalendarMode: DatePickerMode.day,
            onDateChanged: (date)async{
              setState(() {
                _selected_date=date;
              });
              getDoctorAppointments(date);

              print(date);
            },


          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 6,
                backgroundColor: Colors.green,
              ),
              Text('Available',style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(width: 5,),
              CircleAvatar(
                radius: 6,
                backgroundColor: Colors.orange,
              ),

              Text('Selected',style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(width: 5,),
              CircleAvatar(
                radius: 6,
                backgroundColor: Colors.red,
              ),
              Text('Booked',style: TextStyle(fontWeight: FontWeight.bold),),


            ],),
          _isLoadingDate?
          const Center(child:
          CircularProgressIndicator()):
          Column(
            children: tableSlots,
          ),
          CustomButton(text: 'Select',
          onClick: (){
            if(_selectedTime==null){
              var snack=SnackBar(content: Text('you should select time'));
            ScaffoldMessenger.of(context).showSnackBar(snack);
            return;
            }
            Navigator.of(context).pop([_selected_date,_selectedTime]);
          },color: primaryColor.shade900,),
          SizedBox(height: 15,)

        ],
      ),
    ));
  }
}

class TimeSlotWidget extends StatefulWidget {
   TimeSlotWidget({Key? key, this.booked, this.selected, this.bcolor, this.onClick, this.text}) : super(key: key);
   final booked;
   final selected;
   final bcolor;
   final onClick;
   final text;


  @override
  State<TimeSlotWidget> createState() => _TimeSlotWidgetState();
}

class _TimeSlotWidgetState extends State<TimeSlotWidget> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.booked?null:  widget.onClick,

      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color:widget.selected?Colors.orange:  widget.bcolor
          ),
          child: Center(child: Text(widget.text)),
        ),
      ),
    );
  }
}

extension DateEquality on DateTime{
  bool isEqualToDate(DateTime d){
    return year==d.year && month==d.month
        && day==d.day;
  }
}




