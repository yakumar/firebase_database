import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: new Container(
          color: Colors.pink,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              TextField(
                controller: _userNameController,
                onChanged: (val) {},
                decoration: InputDecoration(
                    labelText: 'username',
                    prefixIcon: Icon(Icons.verified_user)),
              ),
              TextField(
                controller: _passwordController,
                onChanged: (val) {},
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'password', prefixIcon: Icon(Icons.security)),

              ),
              Container(
                height: 25.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    onPressed: _login,
                    child: Text('Login'),
                    color: Colors.green,
                  ),
                  Container(
                    width: 10.0,
                  ),
                  RaisedButton(
                    onPressed: _signUp,
                    child: Text('Sign Up'),
                    color: Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _signUp() async {
    try {
      var resposnse = await firebaseAuth.createUserWithEmailAndPassword(
          email: _userNameController.text, password: _passwordController.text);
      setState(() {
        _userNameController.text = '';
        _passwordController.text = '';
      });
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) {
        return new MyHomePage();
      }), (Route route) => true);
      print(resposnse.email);
    } catch (err) {
      print(err);
    }
  }

  Future _login() async {
    try {
      var response = await firebaseAuth.signInWithEmailAndPassword(
          email: _userNameController.text, password: _passwordController.text);
      setState(() {
        _userNameController.text = '';
        _passwordController.text = '';
      });
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context){
        return new MyHomePage();
      }));

      print(response.email);
    } catch (err) {
      print(err);
    }
  }
}
