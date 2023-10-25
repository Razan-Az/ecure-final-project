import 'package:e_cure_app/constants.dart';
import 'package:flutter/material.dart';

class CustomTextArea extends StatefulWidget {
    final title;
    final hint;
    final TextInputType keyBoardType;
    final TextEditingController control;
    final validator;
    final suffix;
  var isPassward;


  CustomTextArea(
      this.title,
      this.hint,
      this.keyBoardType,
      this.control,
      this.validator,
      this.suffix,
      this.isPassward,

      );
  @override
  State<CustomTextArea> createState() => _CustomTextAreaState(
    title,
    hint,
    control,
    keyBoardType,
    validator,
    suffix,
    isPassward,

  );
}

class _CustomTextAreaState extends State<CustomTextArea> {
  late final title;
  late final hint;
  late final control;
  late final TextInputType keyBoardType;
  late final validator;
  late final suffix;
  late var isPassward;


  //late final save;

  _CustomTextAreaState(this.title, this.hint, this.control, this.keyBoardType,
      this.validator, this.suffix, this.isPassward);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: control,
      validator: validator,
      keyboardType: keyBoardType,
      obscureText: isPassward,
      minLines: 7,
      maxLines: null,
      decoration: InputDecoration(

        // prefixIcon: Icon(
        //   icon,
        //   color: Style.brown,
        // ),
        hintText: hint,
        suffixIcon: suffix == null
            ? null
            : IconButton(
          onPressed: () {
            setState(() {
              isPassward = !isPassward;
            });
          },
          icon: Icon(
            isPassward ? Icons.visibility : Icons.visibility_off,
          //  color: Style.brown,
          ),
        ),
        fillColor: softGreyColor,
        filled: true,
        enabledBorder:const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            color: Colors.transparent
          ),
        ),
      ),
    );
  }
}
