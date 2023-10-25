import 'package:e_cure_app/constants.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
   CustomButton({Key? key,
  required this.text,
  required this.color,
     required this.onClick
  }) : super(key: key);
  var text;
  var color;
  var onClick;


  @override
  Widget build(BuildContext context) {
    return MaterialButton(onPressed:onClick,
      padding:const EdgeInsets.symmetric( vertical: 15),
      child:  Text(text,style: TextStyle(color: Colors.white,fontSize: 18),),
    elevation: 5,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
    );
  }
}
