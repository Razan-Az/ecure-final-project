import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/components/custom_button.dart';
import 'package:e_cure_app/components/custom_text_field.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/add_city_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Cities extends StatefulWidget {
  const Cities({Key? key}) : super(key: key);

  @override
  State<Cities> createState() => _CitiesState();
}

class _CitiesState extends State<Cities> {
  getCities() {
    var _firestore = FirebaseFirestore.instance;
    return _firestore.collection("cities").snapshots();
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
                    'Cities',
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
            stream: getCities(),
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
                  children: snapshot.data!.docs.map((cityDoc) {
                return ListTile(
                  leading: Icon(
                    FontAwesomeIcons.city,
                    color: primaryColor.shade900,
                  ),
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cityDoc["name"],
                        style: const TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          "Hospitals:" + cityDoc["hospitals_count"].toString()),

                    ],
                  ),
                  trailing:  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          final _cityController = TextEditingController();
                          _cityController.text = cityDoc["name"];
                          return AlertDialog(
                            title: const Text('Update city name'),
                            content: CustomTextField(
                                'City',
                                '',
                                TextInputType.text,
                                _cityController,
                                null,
                                null,
                                false),

                            actions: [
                              TextButton(
                                  onPressed: () async{
                                    if(cityDoc['hospitals_count']>0)
                                    {
                                      var snackBar=const SnackBar(content: Text('The city could not be deleted because it has many hospitals'));
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      return;
                                    }
                                    Navigator.of(context).pop();
                                    FirebaseFirestore.instance
                                        .collection('cities')
                                        .doc(cityDoc.id)
                                        .delete()
                                        .then((value) {

                                      var snackBar=const SnackBar(content: Text('City name was deleted successfully'));
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    });

                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.red),
                                  )),
                              TextButton(
                                  onPressed: () async {
                                    if(_cityController.text.isEmpty) {
                                      return;
                                    }
                                    Navigator.of(context).pop();
                                    FirebaseFirestore.instance
                                        .collection('cities')
                                        .doc(cityDoc.id)
                                        .update({
                                      'name':_cityController.text
                                    }).then((value) {
                                      var snackBar=const SnackBar(content: Text('City name was updated successfully'));
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    });
                                  },
                                  child: const Text(
                                    'Update',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.green),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  )),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(Icons.edit),
                  )     );
              }).toList());
            },
          ))
        ],
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const AddCity()));
        },
        child: CircleAvatar(
          radius: 30,
          backgroundColor: primaryColor.shade900,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    ));
  }
}
