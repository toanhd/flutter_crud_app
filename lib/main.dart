import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class User {
  final String id;
  final String name;
  final String company;
  final String email;
  final int phone;

  User({this.id, this.name, this.company, this.email, this.phone});
}

List<User> createUserList(List data) {
  List<User> list = new List();
  for (int i = 0; i < data.length; i++) {
    String id = data[i]["_id"];
    String name = data[i]["name"];
    String company = data[i]["company"];
    String email = data[i]["email"];
    int phone = data[i]["phone"];

    User user = new User(
        id: id, name: name, company: company, email: email, phone: phone);
    list.add(user);
  }
  return list;
}

Future<List<User>> fetchPost() async {
  final response = await http.get('http://10.0.2.2:3000/read');
  print(response.body);
  List responseJson = json.decode(response.body.toString());
  List<User> userList = createUserList(responseJson);
  return userList;
}





class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter CRUD',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter CRUD'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Fetch Data Example',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Fetch Data Example'),
        ),
        body: new Center(
          child: new FutureBuilder<List<User>>(
            future: fetchPost(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return new Container(
                        padding: new EdgeInsets.all(10.0),
                        child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text("Name: "+
                                snapshot.data[index].name,
                                style: new TextStyle(
                                    fontWeight: FontWeight.normal),
                              ),
                              new Text("Email: "+
                                  snapshot.data[index].email,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.normal),
                              ),
                              new Divider(),

                            ]),
                      );
                    });
              } else if (snapshot.hasError) {
                return new Text("${snapshot.error}");
              }

              // By default, show a loading spinner
              return new CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
