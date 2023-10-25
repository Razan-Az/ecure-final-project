import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cure_app/components/custom_button.dart';
import 'package:e_cure_app/components/custom_text_field.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'dart:math' as math;

class AccountVerification extends StatefulWidget {
  const AccountVerification({Key? key}) : super(key: key);

  @override
  State<AccountVerification> createState() => _AccountVerificationState();
}

class _AccountVerificationState extends State<AccountVerification> {

  final _emailController=TextEditingController();
  final _codeController=TextEditingController();
  var _code="";

  bool _isSending=false;
  bool _isError=false;
  String _error="";
  bool _isSent=false;
  var user_id;


  generateCode(){
    var c="";
    for(int i=5;i>=0;i--)
      {
        var r=math.Random().nextInt(9);
        c+=r.toString();
      }
  return c;
  }


  sendMail(toMail) async{
    String username = 'ecure6@gmail.com';
    String password = 'ranhnctwrzsjhcst';

    var smtpServer = gmail(username, password);


    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    _code=generateCode() ;

    // Create our message.
    final message = Message()
      ..from = Address(username, 'Ecure Project')
      ..recipients.add(toMail)
     // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
     // ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'Your verification code at ${DateTime.now()}'
      ..text = 'This is the plain text.your code  :${_code}.'
      ..html = "<h1>Your code  </h1>\n<p>${_code}</p>";

    try {
      setState(() {
        _isSending=true;
      });
      final sendReport = await send(message, smtpServer);
      setState(() {
        _isSending=false;
        _isSent=true;
      });
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
     setState(() {
       _isSending=false;
     });
      print('Message not sent.becuase of ${e.toString()}');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
    // DONE
  }


  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return SafeArea(child: Scaffold(
      body:
      Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(

          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(onPressed: (){
                  Navigator.of(context).pop();
                }, icon:const Icon(Icons.arrow_back_ios)),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset("assets/images/logo.png",width: size.width*0.5,),
                ),
              ],
            ),
          const  Text('Enter your email and press send then  system will send you code to verify your account '),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child:
              CustomTextField(
                  "Email",
                  "Enter email",
                  TextInputType.text,
                  _emailController,
                      (value){
                    print("validator");
                    if(value.isEmpty) {
                      return "Required Field";
                    }
                    return null;
                  },
                  null,
                  false
              )),
           _isSent? Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child:
                CustomTextField(
                    "Verification",
                    "Enter the code that you got from the mail please",
                    TextInputType.text,
                    _codeController,
                        (value){
                      print("validator");
                      if(value.isEmpty) {
                        return "Required Field";
                      }
                      return null;
                    },
                    null,
                    false
                )):SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 15),
              child:   CustomButton(text:_isSent?"Verify":"Send",color: primaryColor.shade900,
                onClick: ()async{
                if(!_isSent) {
                  setState(() {
                    _isSending=true;
                  });
                  print(_emailController.text);
                    FirebaseFirestore.instance
                        .collection("Users")
                      .where("email", isEqualTo: _emailController.text)
                        .get()
                        .then((value) {

                      setState(() {
                        _isSending=false;
                      if (value.docs.isEmpty) {
                          _isError = true;
                          _error = "Your email was not found in the system";
                      }
                      else{
                        var userDoc=value.docs.first;
                        user_id=userDoc.id;
                        print(user_id);
                       sendMail(_emailController.text);
                      }});
                    });
                  }
                else{
                  setState(() {
                    _isError = false;
                  });
                  if(_codeController.text.isEmpty) {
                      setState(() {
                        _isError = true;
                        _error = "Empty code";
                      });
                    }
                    if(_code==_codeController.text)
                    {
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(builder: (context) => ResetPassword(user_id:user_id ) ,));

                    }
                  else
                    {
                      setState(() {
                        _isError = true;
                        _error = "Invalid Code..";
                      });
                    }

                }
                },),

            ),
            _isSending?Center(child: CircularProgressIndicator()):SizedBox(),
            _isError==true?Center(
              child: Align(
                alignment: Alignment.center,
                  child: Text(_error,style: TextStyle(color:Colors.red,fontSize: 21,),)),
            ):SizedBox()
          ],
        ),
      ),
    ));
  }
  }

