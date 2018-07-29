
class EmployeeModel {
  String id;
  String name;
  String job;

  EmployeeModel({this.id, this.name, this.job});

  EmployeeModel.toJson(Map newEmployee):

      name = newEmployee['name'],
  job = newEmployee['job'];

  EmployeeModel.fromJson(Map parsedJson):
      id = parsedJson['id'],
      name = parsedJson['name'],
  job = parsedJson['job'];

}


