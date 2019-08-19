import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();

}


class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {





  // ----------------------------- start of msg code -------------------------
  var mymap = {};

  var title = '';

  var body = '';

  var mytoken = '';



  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =

  new FlutterLocalNotificationsPlugin();

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    FirebaseDatabase database = new FirebaseDatabase();
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);

    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);
    firebaseMessaging.configure(
        onLaunch: (Map<String , dynamic> msg){
          print("onLaunch called ${(msg)}");
        },
        onResume: (Map<String , dynamic> msg){
          print("onResume called ${(msg)}");
        },
        onMessage:  (Map<String , dynamic> msg){
          print("onResume called ${(msg)}");
          mymap = msg;
          showNotification(msg);
        }
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true , alert: true ,badge: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting){
      print("onIosSettingsRegistered");
    });
    firebaseMessaging.getToken().then((token){
      update(token);
    });


  }

  showNotification(Map<String , dynamic> msg) async{
    var android = new AndroidNotificationDetails(
        "1", "channelName", "channelDescription");
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android,iOS);
    int ind=0;
    msg.values.first.forEach((k,v)async{
      title = k;
      body = v;
      await flutterLocalNotificationsPlugin.show(ind, msg.values.first['title'], msg.values.first['body'], platform);
      ind++;
      setState(() {
      });
    });

  }

  update(String token )async{

    print(token);

    try{
      DatabaseReference databaseReference = new FirebaseDatabase().reference();
      await FirebaseAuth.instance.currentUser().then((user){
        databaseReference.child('fcm-token/$token').set({
          "token":token,
          "userId":user.uid,
          "PerentNumber": user.phoneNumber,
        });
        mytoken = token;
        setState(() {
        });
      });



    }catch(e){

      print(e.toString());
    }

  }


  // ----------------------------- msg end -------------------------

  @override

  Widget build(BuildContext context) {



    return Scaffold(



      body: Center(


      ),



    );

  }

// to send notifications 
  Future sendNotification() async {

    final response = await Messaging.sendToAll(

      title: "title ",

      body: " body text ",

      topic: token ID of user ,

    );







}
