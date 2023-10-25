import 'package:e_cure_app/components/custom_text_field.dart';
import 'package:e_cure_app/components/login_form.dart';
import 'package:e_cure_app/components/register_form.dart';
import 'package:e_cure_app/constants.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin{
  var _tabController;

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController=TabController(length: 2, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return SafeArea(child: Scaffold(
      body:
      Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset("assets/images/logo.png",width: size.width*0.5,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: TabBar(
              controller: _tabController,
              labelColor: highlightColor.shade900,
              indicatorColor:highlightColor.shade900,
              isScrollable: true,
              //indicatorColor: Colors.transparent,
              unselectedLabelColor: Colors.grey,
              unselectedLabelStyle:const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              labelStyle:const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              tabs: const <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Login'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Register'),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                LoginForm(),
                Registerform(),


              ],
            ),
          ),
        ],
      ),
    ));
  }
}
