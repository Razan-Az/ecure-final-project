import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/book_appointment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SpecialityDoctors extends StatefulWidget {
  SpecialityDoctors(
      {Key? key, this.patient_id, this.hospital_id, this.speciality})
      : super(key: key);
  final patient_id;
  final hospital_id;
  final speciality;

  @override
  State<SpecialityDoctors> createState() => _SpecialityDoctorsState();
}

class _SpecialityDoctorsState extends State<SpecialityDoctors> {
  var _sheetController;

  getProvider(Map<String, dynamic> data) {
    return data.containsKey("image_url") == false
        ? const AssetImage('assets/images/logo.png')
        : NetworkImage(
            data['image_url'],
          );
  }

  getReviews(id) {
    var _firestore = FirebaseFirestore.instance;
    return _firestore
        .collection("Users")
        .doc(id)
        .collection('reviews')
        .snapshots();
  }

  getDoctors() {
    var _firestore = FirebaseFirestore.instance;
    return _firestore
        .collection("Users")
        .where("type", isEqualTo: "Doctor")
        .where("hospital_id", isEqualTo: widget.hospital_id)
        .where("speciality", isEqualTo: widget.speciality)
        .snapshots();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  whatsapp(contact) async {
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";

    try {
      await launchUrl(Uri.parse(androidUrl));
    } on Exception {
      var snackBar =
          const SnackBar(content: Text('WhatsApp is not installed.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: primaryColor.shade900,
                      size: 25,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Doctors',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: primaryColor.shade900),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: getDoctors(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error :" + snapshot.error.toString()),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: primaryColor.shade900,
                ));
              } else if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("No Records"),
                );
              }

              return ListView(
                  children: snapshot.data!.docs.map((doctor) {
                return ListTile(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => BookAppointment(patient_id: widget.patient_id,
                    // doctor_id: doctor.id,doctor_name:doctor["name"] ,),));

                    _sheetController = showBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ListView(

                              // mainAxisSize: MainAxisSize.min,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: softColor,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: getProvider(doctor.data()
                                            as Map<String, dynamic>),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    doctor.get('name'),
                                    style: const TextStyle(fontSize: 23),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Reviews",
                                      style: TextStyle(fontSize: 18)),
                                ),
                                StreamBuilder<QuerySnapshot>(
                                  stream: getReviews(doctor.id),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting)
                                      return const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Loading reviews .....'),
                                      );
                                    if (snapshot.data!.docs.isEmpty) {
                                      return const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('No reviews'),
                                      );
                                    }
                                    return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: snapshot.data!.docs
                                            .map((reviewDoc) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: greyColor.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'From :' +
                                                        reviewDoc['patient'],
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                  RatingBar.builder(
                                                    ignoreGestures: true,
                                                    initialRating:
                                                        reviewDoc['rating'],
                                                    minRating: 1,
                                                    itemSize: 20,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    itemPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 4.0),
                                                    itemBuilder: (context, _) =>
                                                        const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                      size: 5,
                                                    ),
                                                    onRatingUpdate: (rating) {},
                                                  ),
                                                  Text(
                                                    reviewDoc['review'],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList());
                                  },
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    OutlinedButton.icon(
                                        onPressed: () {
                                          try {
                                            //   _makePhoneCall(doctor.get('phone'));
                                            whatsapp(doctor.get('phone'));
                                          } catch (e) {
                                            var snackBar = const SnackBar(
                                                content: Text(
                                                    'No phone number is associate with this account'));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                        },
                                        icon: Icon(
                                          FontAwesomeIcons.whatsapp,
                                          color: primaryColor.shade900,
                                        ),
                                        label: Text('Whatsapp',
                                            style: TextStyle(
                                              fontSize: 12,
                                                color: primaryColor.shade900))),
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => BookAppointment(
                                            patient_id: widget.patient_id,
                                            doctor_id: doctor.id,
                                            doctor_name: doctor["name"],
                                          ),
                                        ));
                                      },
                                      icon: Icon(
                                        Icons.date_range_rounded,
                                        color: primaryColor.shade900,
                                      ),
                                      label: Text(
                                        'Book Appointment',
                                        style: TextStyle(
                                          fontSize: 18,
                                            color: primaryColor.shade900),
                                      ),

                                    )
                                  ],
                                )
                              ]),
                        );
                      },
                    );
                    // Navigator.of(context)
                  },
                  leading: Icon(
                    Icons.person,
                    color: primaryColor.shade900,
                  ),
                  title: Text(
                    doctor["name"],
                    style: const TextStyle(
                        fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(doctor["speciality"].toString()),
                );
              }).toList());
            },
          ))
        ],
      ),
    ));
  }
}
