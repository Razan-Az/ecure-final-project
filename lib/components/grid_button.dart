import 'package:e_cure_app/constants.dart';
import 'package:flutter/material.dart';

class GridButton extends StatelessWidget {
    GridButton({Key? key,
  required this.text,
    required this.onClick,
    required this.icon
  }) : super(key: key);
  var text;
  var icon;
  var onClick;


  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return  InkWell(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 8,
          child:
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 17,bottom: 17,left: 5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    Icon(icon,color: primaryColor.shade900,size: 25,),
                    const SizedBox(width: 5,),
                    Text(text,style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: greyColor.shade900,

                    ),softWrap: true,)
                  ]

              ),
            ),
          ),
        ),
      ),
    );
  }
}
