//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:cloud_firestore_web/cloud_firestore_web.dart';
//import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value){
    runApp(const MyApp());
    
  });
  
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myControllerName = TextEditingController();
  final myControllerJob = TextEditingController();
  final List <String> usuarios=[];
  int _counter=0;
  final fibinstance = FirebaseFirestore.instance;
  void _incrementCounter() {
    fibinstance.collection("users").add({
      "name": "cruz",
      "job": "programador"
    });
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
  @override
  void initState() {
    super.initState();
  //  getUsers();
    
  }
  void getUsers() async {
    CollectionReference collectionRef =FirebaseFirestore.instance.collection("users");
    QuerySnapshot users = await collectionRef.get();

    if(users.docs.isNotEmpty)
    {
      for( var doc in users.docs)
      {
        // ignore: avoid_print
        print(doc.data());
        usuarios.add(doc.data.toString());
      }

    }
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: const Text('Retrieve Text Input'),
      ),
      body: ListView( 
        padding: EdgeInsets.all(16),
        children: <Widget>[
          TextField(
            controller: myControllerName,
            decoration: decoration('Name'),
          ),
            const SizedBox(height: 24),
            TextField(
              controller: myControllerJob,
              decoration: decoration('Job'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(child: Text('Create'),
            onPressed: (){
              final user = User(
                name: myControllerName.text,
                job: myControllerJob.text
              );
              createUser(user);
             // Navigator.pop(context);
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondRoute()),
            );
            },)
        ],
      ),
      
    );
  }
}
InputDecoration decoration(String label) => InputDecoration(
  labelText: label,
  border: OutlineInputBorder(),
);
Future createUser(User user) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc();
  user.id=docUser.id;
  final json = user.toJson();
  await docUser.set(json);
}

class User{
  String id;
  final String name;
  final String job;
  User({
    this.id='',
    required this.name,
    required this.job,
  });
  Map<String,dynamic> toJson() => {
    'id': id,
    'name': name,
    'job': job,
  };
  static User fromJson (Map<String, dynamic>json)=> User(name: json['name'], job: json['job'],);
}
class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: StreamBuilder<List<User>>(
          stream: readUsers(),
          builder: (context,snapshot) {
            if(snapshot.hasError){
              return Text('Something Wronf! ${snapshot.error}');
            }else if(snapshot.hasData){
              final users = snapshot.data!;
            
            return ListView(
                children: users.map(buildUser).toList(),
              );
            }else {return Center(child: CircularProgressIndicator());}
          }
          ),
          floatingActionButton: FloatingActionButton(onPressed: (){
              final docUser = FirebaseFirestore.instance
                .collection('users')
                .doc('XwmSgFR61HpLpziqYVWg');
                //update specific fields
                docUser.update(
                  { 'name': 'Emma',}
                );
                //delete
                //.set
              //  docUser.update({
              //    'job':FieldValue.delete(),
              //  });
          },),
          
      );
    
    
  }
  Widget buildUser(User user) => ListTile(
    title: Text(user.name),
    subtitle: Text(user.job),
  );
  Stream <List<User>> readUsers() => FirebaseFirestore.instance
    .collection('users')
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
}


