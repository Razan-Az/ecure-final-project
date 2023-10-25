import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/components/custom_area_text_field.dart';
import 'package:e_cure_app/components/custom_button.dart';
import 'package:e_cure_app/components/custom_text_field.dart';
import 'package:e_cure_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PatientAppointmentsView extends StatefulWidget {
  PatientAppointmentsView({Key? key, this.appointment_id}) : super(key: key);
  final appointment_id;

  @override
  State<PatientAppointmentsView> createState() =>
      _PatientAppointmentsViewState();
}

class _PatientAppointmentsViewState extends State<PatientAppointmentsView> {
  bool _isLoading = false;
  bool _isWorking = false;

  final _reviewController = TextEditingController();

  bool _isDone = false;

  var appointmentData;
  DateTime? appoint_date;
  var questions = [];
  var answers = [];

  var diagnosis = "";
  var prescription = "";

  var _rating;

  getAppointmentDetails() async {
    setState(() {
      _isLoading = true;
    });

    FirebaseFirestore.instance
        .collection("appointments")
        .doc(widget.appointment_id)
        .get()
        .then((appointment) {
      setState(() {
        appointmentData = appointment.data();
        _isLoading = false;
        Timestamp timestamp = appointmentData["appointment_date"];
        appoint_date = timestamp.toDate();
        questions = appointment.get("questions");
        answers = appointment.get("answers");
        _isDone = appointmentData["status"] == "Done";
        if (_isDone) {
          diagnosis = appointment.get("diagnosis");
          prescription = appointment.get("prescription");
        }
      });
    });
  }

  getQuestionnaire() {
    List<Widget> questionnaire = [];
    for (int i = 0; i < questions.length; i++) {
      questionnaire.add(Text(
        questions[i],
        style: const TextStyle(fontSize: 21, color: Colors.grey),
      ));
      questionnaire.add(Text(answers[i],
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: questionnaire,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAppointmentDetails();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_back_ios)),
                      const Text('Appointment Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ))
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "Patient",
                    style: TextStyle(fontSize: 21, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    appointmentData["name"],
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "When",
                    style: TextStyle(fontSize: 21, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "${appoint_date!.year}-${appoint_date!.month}-${appoint_date!.day} " +
                        appointmentData["appointment_time"],
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "Problem",
                    style: TextStyle(fontSize: 21, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    appointmentData["description"],
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text('Questionnaire',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryColor.shade900)),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: getQuestionnaire()),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "Diagnosis",
                    style: TextStyle(fontSize: 21, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(diagnosis,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "Prescription",
                    style: TextStyle(fontSize: 21, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(prescription,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                _isWorking
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox(),
                !_isDone?SizedBox(): Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'You can leave a review for this doctor here',
                          style: TextStyle(fontSize: 17),
                        ),
                        RatingBar.builder(
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              _rating = rating;
                            });
                          },
                        ),
                        CustomTextArea(
                            'Review',
                            'Type Your Review here',
                            TextInputType.multiline,
                            _reviewController,
                            null,
                            null,
                            false),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: double.infinity,
                          child: CustomButton(
                              text: 'Send Review',
                              color: primaryColor.shade900,
                              onClick: () {
                                setState(() {
                                  _isWorking = true;
                                });
                                FirebaseFirestore.instance
                                    .collection("Users")
                                    .doc(appointmentData["doctor_id"])
                                    .collection("reviews")
                                    .add({
                                  'patient': appointmentData['name'],
                                  'review': _reviewController.text,
                                  'rating': _rating
                                }).then((value) {
                                  Navigator.of(context).pop();
                                  var snackBar = SnackBar(
                                      content: const Text(
                                          'Review was sent successfully'));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                });
                              }),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
    ));
  }
}
