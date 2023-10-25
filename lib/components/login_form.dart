import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/components/custom_button.dart';
import 'package:e_cure_app/components/custom_text_field.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/models/helper.dart';
import 'package:e_cure_app/pages/doctor_complete_profile.dart';
import 'package:e_cure_app/pages/hospital_complete_profile.dart';
import 'package:e_cure_app/pages/patient_complete_profile.dart';
import 'package:e_cure_app/pages/doctor_home_page.dart';
import 'package:e_cure_app/pages/hospital_home_page.dart';
import 'package:e_cure_app/pages/ministry_home_page.dart';
import 'package:e_cure_app/pages/patient_home_page.dart';
import 'package:e_cure_app/pages/account_verification.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool _isLoading = false;

  String _error = "";
  bool _isError = false;

  checkLogin() async {
    var _firestore = FirebaseFirestore.instance;
    setState(() {
      _isLoading = true;
    });
    _firestore
        .collection("Users")
        .doc(_usernameController.text.toLowerCase())
        .get()
        .then((doc) {
      setState(() {
        _isLoading = false;
      });
      if (!doc.exists) {
        setState(() {
          _isError = true;
          _error = "Username doesn't exist!";
        });
      } else {
        var data = doc.data();
        var password = data!['password'];
        if (password != Helper().hashPassword(_passwordController.text)) {
          setState(() {
            _isError = true;
            _error = "Wrong Password!";
          });
        } else {
          var isActive = data['status'] == 'Active';
          if (!isActive) {
            setState(() {
              _isError = true;
              _error = "Your Account has been deactivated";
            });
            return;
          }

          var type = data!["type"];
          switch (type) {
            case 'Ministry':
              {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => MinistryHomePage(),
                ));
                break;
              }
            case 'Hospital':
              {
                var isComplete = data['complete_profile'];
                if (!isComplete) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HospitalCompleteProfile(
                            user_name: _usernameController.text.toString(),
                            hospital_name: data!['name'],
                          )));
                } else {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HospitalHomePage(
                        hospital_id: doc.id, hospital_name: data!['name']),
                  ));
                }
                break;
              }
            case 'Doctor':
              {
                var isComplete = data['complete_profile'];
                if (!isComplete) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DoctorCompleteProfile(
                            user_id: _usernameController.text.toString(),
                            user_name: data['name'],
                          )));
                } else {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => DoctorHomePage(
                        doctor_id: doc.id, doctor_name: data!['name']),
                  ));
                }

                break;
              }
            case 'Patient':
              {
                var isComplete = data['complete_profile'];
                if (!isComplete) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PatientCompleteProfilePage(
                            user_name: _usernameController.text.toString(),
                          )));
                } else {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => PatienthomePage(
                            user_name: _usernameController.text.toString(),
                            full_name: data['name'],
                          )));
                }

                break;
              }
            default:
              {
                setState(() {
                  _isError = true;
                  _error = "Wrong user type";
                });
              }
          }
        }
      }
    }).catchError((e) {
      setState(() {
        _isLoading = false;
        _isError = true;
        _error = "Connection Error";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: CustomTextField("Username", "Enter UserName...",
                TextInputType.text, _usernameController, (value) {
              print("validator");
              if (value.isEmpty) {
                return "Required Field";
              }
              return null;
            }, null, false),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: CustomTextField("Password", "Enter Password....",
                TextInputType.text, _passwordController, (value) {
              if (value.isEmpty) {
                return "Required Field";
              }
            }, true, true),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
            child: CustomButton(
              text: "Login",
              color: primaryColor.shade900,
              onClick: () {
                if (_key.currentState!.validate()) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  checkLogin();
                }
              },
            ),
          ),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: primaryColor,
                ))
              : const SizedBox(),
          _isError
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      _error,
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : const SizedBox(),
          const SizedBox(
            height: 24,
          ),
          Center(
            child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AccountVerification(),
                  ));
                },
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(fontSize: 20),
                )),
          )
        ],
      ),
    );
  }
}
