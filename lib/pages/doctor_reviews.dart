import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/models/helper.dart';
import 'package:e_cure_app/pages/add_hospital_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DoctorReviews extends StatefulWidget {
  DoctorReviews({Key? key, this.doctor_id}) : super(key: key);
  final doctor_id;

  @override
  State<DoctorReviews> createState() => _DoctorReviewsState();
}

class _DoctorReviewsState extends State<DoctorReviews> {


  getHospitals(){
    var _firestore=FirebaseFirestore.instance;
    return _firestore.collection("Users")
        .doc(widget.doctor_id)
        .collection("reviews")
        .snapshots();
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
                  Text('Reviews',style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: primaryColor.shade900
                  ),),
                ],
              ),
            ),
          ),
          Expanded(child:
          StreamBuilder<QuerySnapshot>(
            stream: getHospitals(),
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

              return ListView(
                  children: snapshot.data!.docs.map((reviewDoc) {
                    return  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: greyColor.shade100,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('From :'+reviewDoc['patient'],style: TextStyle(fontSize: 18),),
                        RatingBar.builder(
                          ignoreGestures: true,
                          initialRating: reviewDoc['rating'],
                          minRating: 1,
                          itemSize: 20,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 5,
                          ),
                          onRatingUpdate: (rating) {

                          },
                        ),
                            Text(reviewDoc['review'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
                          ],
                        ),
                      ),
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
