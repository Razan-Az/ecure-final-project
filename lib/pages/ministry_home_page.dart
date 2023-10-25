import 'package:e_cure_app/components/grid_button.dart';
import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/cities_page.dart';
import 'package:e_cure_app/pages/hospitals_page.dart';
import 'package:e_cure_app/pages/login_page.dart';
import 'package:e_cure_app/pages/update_password.dart';
import 'package:flutter/material.dart';

class MinistryHomePage extends StatefulWidget {
  const MinistryHomePage({Key? key}) : super(key: key);

  @override
  State<MinistryHomePage> createState() => _MinistryHomePageState();
}

class _MinistryHomePageState extends State<MinistryHomePage> {
  @override
  Widget build(BuildContext context) {

    return SafeArea(child:
    Scaffold(
      backgroundColor: softGreyColor,
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: softColor,
            elevation: 10,
            child:
                    Stack(
                      children: [Opacity(opacity: 0.4,
                          child: Image.asset("assets/images/logo.png",),),
                      const Positioned(
                        bottom: 43,
                          left: 20,
                          child: Column(
                            children: [
                              Text("Welcome",
                              style: TextStyle(fontSize: 42,fontWeight: FontWeight.bold),),
                              Text('Ministry',style: TextStyle(fontSize: 23,color: Colors.grey,fontWeight: FontWeight.bold),)
                            ],
                          )),
                        Positioned(
                        top: 10,
                          left: 10,
                          child:
                      InkWell(
                        onTap: (){

                        },
                        child: CircleAvatar(
                          minRadius: 40,
                          backgroundColor:  Colors.teal,
                          child: Icon(Icons.person,color: Colors.white,size: 40,),
                        ),
                      )),
                        Positioned(
                            right: 15,
                            top: 15,
                            child:  IconButton(onPressed: (){
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage(),));

                            }, icon: Icon(Icons.logout,size: 30,)) )],
                    )

          ),
         const SizedBox(height: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                Expanded(
                  child: GridButton(
                    text: "Cities",
                    icon: Icons.location_city,
                    onClick: (){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context)=>  Cities()));
                    },
                  ),
                ),
                Expanded(
                  child: GridButton(
                    text: "Hospitals",
                    icon: Icons.local_hospital,
                    onClick: (){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context)=>  Hospitals()));

                    },
                  ),
                )
              ],),
              Row(
                children: [
                  Expanded(
                    child: GridButton(
                      text: "Update Password",
                      icon: Icons.location_city,
                      onClick: (){
                       Navigator.of(context)
                           .push(MaterialPageRoute(builder: (context) => UpdatePassword(user_id: 'admin',),));
                           },
                    ),
                  ),
                  const Expanded(
                    child:SizedBox()
                  )
                ],),

            ],
          )
        ],
      ),
    ));
  }
}
