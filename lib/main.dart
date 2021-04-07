import 'package:flutter/material.dart';
// import 'package:todo_app/util/dbhelper.dart';
// import 'package:todo_app/model/todo.dart';
// import 'package:todo_app/screens/todolist.dart';
import 'package:medicine_stock/util/dbhelper.dart';
import 'package:medicine_stock/model/medicine.dart';
import 'package:medicine_stock/screens/medicalList.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as notifs;
import 'package:rxdart/subjects.dart' as rxSub;
import 'package:medicine_stock/util/NotificationsHelper.dart';

notifs.NotificationAppLaunchDetails notifLaunch;
final notifs.FlutterLocalNotificationsPlugin notifsPlugin =
    notifs.FlutterLocalNotificationsPlugin();
void main() async {
  runApp(MyApp());
  notifLaunch = await notifsPlugin.getNotificationAppLaunchDetails();
  initNotifications(notifsPlugin);
  initNotifications(notifsPlugin);
  requestIOSPermissions(notifsPlugin);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medicine Stock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Medicine Stock'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: MedicalList(),
    );
  }
}

final rxSub.BehaviorSubject<NotificationClass>
      didReceiveLocalNotificationSubject =
      rxSub.BehaviorSubject<NotificationClass>();
  final rxSub.BehaviorSubject<String> selectNotificationSubject =
      rxSub.BehaviorSubject<String>();


Future<void> initNotifications(
      notifs.FlutterLocalNotificationsPlugin notifsPlugin) async {
    var initializationSettingsAndroid =
        notifs.AndroidInitializationSettings('icon');
    var initializationSettingsIOS = notifs.IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
          didReceiveLocalNotificationSubject.add(NotificationClass(
              id: id, title: title, body: body, payload: payload));
        });
    var initializationSettings = notifs.InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notifsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        print('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload);
    });
    print("Notifications initialised successfully");
  }

  void requestIOSPermissions(
      notifs.FlutterLocalNotificationsPlugin notifsPlugin) {
    notifsPlugin
        .resolvePlatformSpecificImplementation<
            notifs.IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
