

import 'package:firebase_database/firebase_database.dart';
class EmployeeModel {
  String id;
  String name;
  String job;

  EmployeeModel({this.id, this.name, this.job});

 toJson(){
   return{
   'name': name,
   'job': job,
 };
 }

  EmployeeModel.fromJson(Map parsedJson):
      id = parsedJson['id'],
      name = parsedJson['name'],
  job = parsedJson['job'];



}


