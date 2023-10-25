import 'package:e_cure_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
    final title;
    final hint;
    final TextInputType keyBoardType;
    final TextEditingController control;
    final validator;
    final suffix;
  var isPassward;


  CustomTextField(
      this.title,
      this.hint,
      this.keyBoardType,
      this.control,
      this.validator,
      this.suffix,
      this.isPassward,

      );
  @override
  State<CustomTextField> createState() => _CustomTextFieldState(
    title,
    hint,
    control,
    keyBoardType,
    validator,
    suffix,
    isPassward,

  );
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final title;
  late final hint;
  late final control;
  late final TextInputType keyBoardType;
  late final validator;
  late final suffix;
  late var isPassward;


  //late final save;

  _CustomTextFieldState(this.title, this.hint, this.control, this.keyBoardType,
      this.validator, this.suffix, this.isPassward);
  @override
  Widget build(BuildContext context) {
    return TextFormField(

      controller: control,
      validator: validator,
      keyboardType: keyBoardType,
      obscureText: isPassward,
      inputFormatters:keyBoardType==TextInputType.number?
     [ FilteringTextInputFormatter.allow(RegExp(r"[0-9]{1,2}$"))]:
          keyBoardType==TextInputType.phone? [
            FilteringTextInputFormatter.allow(RegExp(r"[0-9]{1,10}$"))
      ]:null,
      decoration: InputDecoration(
        labelText: title,
        labelStyle: TextStyle(
            fontSize: 12 , color: greyColor.shade900),
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
