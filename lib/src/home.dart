import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'employeeModel.dart';
import 'login.dart';

final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class MyHomePage extends StatefulWidget {
  MyHomePage();


  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _nameController = new TextEditingController();
  final _jobController = new TextEditingController();
  String _name = '';
  String _job = '';
  String _email = '';

//firebaseDatabase.reference().child('employees').update(value)
  @override
  void initState() {
    super.initState();
    firebaseAuth.currentUser().then((curUser){
      print(curUser.email);

      _email = curUser.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Firebase list'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.all_out), onPressed: _logout),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10.0),
        child: new Center(
          child: new ListView(
            children: <Widget>[
              new Text(
                'Welcome $_email',
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Type Name'),
                onChanged: (val) {
                  setState(() {
                    _name = val;
                  });
                },
              ),
              TextField(
                controller: _jobController,
                decoration: InputDecoration(labelText: 'Type Job'),
                onChanged: (val) {
                  setState(() {
                    _job = val;
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: RaisedButton(
                  onPressed: () {
                    return postData();
                  },
                  child: new Text('Submit'),
                ),
              ),
              Padding(padding: EdgeInsets.all(20.0)),
              StreamBuilder(
                stream: firebaseDatabase
                    .reference()
                    .child('employees')
                    .onValue,
                builder: (context, AsyncSnapshot<Event> event) {
                  if (event.hasData) {
//                    print(snapshot.data.snapshot.value['-LIZDwjV0SigEQJyLAcx']);
                    final Map<dynamic, dynamic> fetchedMap = event.data.snapshot
                        .value;
                    List<EmployeeModel> fetchedEmployees = [];
                    if (fetchedMap == null) {
                      return Container(
                        child: Text('No data'),
                      );
                    } else {
                      fetchedMap.forEach((id, data) {
                        final EmployeeModel employee = EmployeeModel(

                          id: id,
                          name: data['name'],
                          job: data['job'],
                        );
                        fetchedEmployees.add(employee);
                      });
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: fetchedEmployees.length,
                          itemBuilder: (context, int index) {
                            return Card(

                              elevation: 10.0,
                              color: index % 2 == 0 ? Colors.red : Colors.green,
                              child: ListTile(
                                title: Text('${fetchedEmployees[index].name}'),
                                subtitle: Text(
                                    '${fetchedEmployees[index].job }'),
                                trailing: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _showDialog(
                                        context, fetchedEmployees[index]);
                                  },
                                ),
                              ),
                            );
                          });
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

//  Stream getData()async* {
//    var newD = await firebaseDatabase.reference().child('employees').onValue;
//
//    yield* newD;
//  }

  Future postData() async {
    var employee = new EmployeeModel(name: _name, job: _job);

    firebaseDatabase.reference().child('employees').push().set(
        employee.toJson());

    _nameController.text = '';
    _jobController.text = '';
    return;
  }


  void _showDialog(BuildContext context, EmployeeModel fetchedEmployee) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          var _editNameController = TextEditingController(
              text: fetchedEmployee.name);
          var _editJobController = TextEditingController(
              text: fetchedEmployee.job);

          print('inside showDialog: {fetchedEmployee.id}');


          return SimpleDialog(


            title: Text('Edit User'),
            children: <Widget>[
              TextField(controller: _editNameController,
                onChanged: (val) {},
                textAlign: TextAlign.center,),
              TextField(controller: _editJobController,
                onChanged: (val) {

                },
                textAlign: TextAlign.center,),

              Padding(padding: EdgeInsets.all(10.0),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      RaisedButton(onPressed: () {
                        print(fetchedEmployee.job);
                        final editedEmployee = new EmployeeModel(name: _editNameController.text, job: _editJobController.text);
                        firebaseDatabase.reference()
                            .child('/employees/'+fetchedEmployee.id).update({'name':_editNameController.text, 'job': _editJobController.text});


                        Navigator.of(context).pop();
                      }, child: Text('Submit'),),
                      Container(width: 7.0,),
                      RaisedButton(onPressed: (){firebaseDatabase.reference()
                          .child('/employees/'+fetchedEmployee.id).remove();
                      Navigator.of(context).pop();
                      }, child: Text('Delete'), color: Colors.red,),
                    ],

                  ),
                ),
              ),

            ],
          );
        });
  }



  Future _logout() async{
    try{
      await firebaseAuth.signOut();

      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context){
        return new LoginPage();
      }));
    } catch (e){
      print(e);
    }
  }
}
