import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mappi.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'HomePageImage.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePageImage(),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var userScore;

  String EventScore;

  var userid;

  bool isload = false;

  getuserdata() async{

  }
   signin() async{

    AuthResult auth = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: controller.text, password: "123456").whenComplete(() {print("User Created");}).catchError((e){print(e);}).catchError((e){

    });
    mappi maps = await mappi(controller.text, auth.user.uid);

    await Firestore.instance.collection("user").document(namecontrol.text).setData(maps.toMap()).whenComplete((){print("FIRESTORE");});
    await Firestore.instance.collection("Events").document(auth.user.uid).setData({
      "Score": scorecontrol.text,
      "email": controller.text,
    }).whenComplete((){
      print("Data Inserted in Events");
    });
    print("HeyMan");
    print("HeyMan");

    await Firestore.instance.collection("user").document(namecontrol.text).get().then((doc){
      print(doc["userid"]);
      userid = doc["userid"];
      print(userid);

    });
//    var userm = await Firestore.instance.collection("User");
//    var nm = await Firestore.instance;
//    var mng = userm.where("Email == ${controller.text}");
//     var mng = nm.collection("roles").where()
//    print(mng);


    await Firestore.instance.collection("Events").document(userid).get().then((doc){
      userScore = doc["Score"];
      print(userScore);
    });

    final StorageReference storageref = FirebaseStorage.instance.ref().child(filename);

    final String filename = auth.user.uid;

    return userScore;

//    return StreamBuilder(
//      stream: Firestore.instance.collection("user").document(controller.text).snapshots(),
//      builder: (context, snapshot){
//        if(!snapshot.hasData){
//          return Text("Notavailable");
//        }
//        else{
//          print("here");
//          var userid = snapshot.data["userid"];
//          return StreamBuilder(
//            stream: Firestore.instance.collection("Events").document(userid).snapshots(),
//            builder: (context, snapshot){
//              var score = snapshot.data["Score"];
//              print(score);
//
//              return score;
//            },
//
//          );
//        }
//      },
//    );
  }



  login() async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: controller.text, password: "123456").whenComplete((){
      print("User LOGGED IN");
    });
  }
  final controller = TextEditingController();
  final namecontrol = TextEditingController();
  final scorecontrol = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Email",
              ),

            ),
            TextFormField(
              controller: namecontrol,
              decoration: InputDecoration(
                labelText: "Enter Name",
              ),
            ),
            TextFormField(
              controller: scorecontrol,
              decoration: InputDecoration(
                labelText: "Enter Score",
              ),
            ),
            RaisedButton(
              child: Text("User Score"),
              onPressed: getuserdata,
            ),
            RaisedButton(
              child: Text("SIGNUP"),
              onPressed: () {
                userScore = signin();
                print(userScore);
              },
            ),
            RaisedButton(
              child: Text("SIGNIN"),
              onPressed: login,
            ),
            RaisedButton(
              onPressed: () {
                signin();
                setState(() {
//                  isload = true;
                EventScore = userScore.toString();
                });

              },
              child: Text(EventScore ?? "Get Score"),
            ),
          ],
        ),
      ),
    );
  }
}

