import 'dart:async';
import 'package:flutter/material.dart';

import 'employeeModel.dart';


import 'package:firebase_database/firebase_database.dart';

final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;


  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _nameController = new TextEditingController();
  final _jobController = new TextEditingController();
  String _name = '';
  String _job = '';


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10.0),
        child: new Center(
          child: new ListView(
            children: <Widget>[
              new Text(
                'You have pushed the button this many times:',
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
              Padding(padding: EdgeInsets.all(10.0),
                child: RaisedButton(onPressed: () {
                  return postData();
                }, child: new Text('Submit'),),),

              Padding(padding: EdgeInsets.all(20.0)),
              StreamBuilder(
                  stream: firebaseDatabase
                      .reference()
                      .child('employees')
                      .onValue,
                  builder: fbStreamBuilder,
              ),


            ],
          ),
        ),
      ),
    );
  }






  Future postData() async {


    firebaseDatabase.reference().child('employees').push().set({
      'name': _name,
      'job': _job,
    });


    _nameController.text = '';
    _jobController.text = '';
    return;
  }



  Widget fbStreamBuilder(BuildContext context, AsyncSnapshot<Event> snapshot) {
    if (snapshot.hasData) {
//                      print(snapshot.data.snapshot.value);
      Map<dynamic, dynamic> fetchedMap = snapshot.data
          .snapshot.value;
      List<EmployeeModel> fetchedEmployees = [];
      if (fetchedMap == null) {
        return Container(child: Text('No data'),);
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
                color: index % 2 == 0 ? Colors.red : Colors
                    .green,
                child: ListTile(
                    title: Text(fetchedEmployees[index].name),
                    subtitle: Text(fetchedEmployees[index].job)),
              );
            }
        );
      }
    } else {
      return CircularProgressIndicator();
    }
  }
}
