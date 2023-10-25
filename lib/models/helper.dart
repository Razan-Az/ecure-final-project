import 'dart:convert';
import 'package:crypto/crypto.dart';

class Helper {

  hashPassword(pass){
    var appleInBytes = utf8.encode(pass);
    return sha256.convert(appleInBytes).toString();
  }

}


extension DateEquality on DateTime{
  bool isEqualToDate(DateTime d){
    return (year==d.year && month==d.month
        && day==d.day);
  }

  DateTime getDateOnly(){
    return DateTime(year,month,day);
  }
}