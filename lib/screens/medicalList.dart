import 'package:flutter/material.dart';
import 'package:medicine_stock/model/medicine.dart';
import 'package:medicine_stock/util/dbhelper.dart';
import 'package:medicine_stock/screens/medicalDetails.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as notifs;
import 'package:medicine_stock/main.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MedicalList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MedicalListState();
}

class MedicalListState extends State {
  DbHelper helper = DbHelper();
  List<Medicine> medicines;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (medicines == null) {
      medicines = <Medicine>[];
      getData();
    }

    return Scaffold(
      body: todoListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: 
        () {
          Medicine newMedicine = Medicine("", null, null, null, null, "", "");
          navigateToDetailPage(newMedicine);
        },
        tooltip: "Add new drug",
        child: new Icon(Icons.add),
      ),
    );
  }

  // Future<void> setTime() async {
  //   await tz.initializeTimeZones();
    
  //   tz.setLocalLocation(tz.getLocation('Asia/Baghdad'));

  //   print(tz.local.currentTimeZone.toString());

  //   var time = DateTime.now().add(const Duration(seconds: 10));
  //   // time = time.add(const Duration(hours: 3));
  //   scheduleNotification(
  //     notifsPlugin: notifsPlugin, //Or whatever you've named it in main.dart
  //     id: DateTime.now().toString(),
  //     body: "A scheduled Notification",
  //     scheduledTime: tz.TZDateTime.from(
  //       time,
  //       //tz.getLocation('Asia/Baghdad')
  //       tz.local,
  //     ),
  //   ); //Or whenever you actually want to trigger it
  // }

  // Future<void> scheduleNotification(
  //     {notifs.FlutterLocalNotificationsPlugin notifsPlugin,
  //     String id,
  //     String title,
  //     String body,
  //     DateTime scheduledTime}) async {
  //   var androidSpecifics = notifs.AndroidNotificationDetails(
  //     id, // This specifies the ID of the Notification
  //     'Scheduled notification', // This specifies the name of the notification channel
  //     'A scheduled notification', //This specifies the description of the channel
  //     icon: 'icon',
  //   );
  //   var iOSSpecifics = notifs.IOSNotificationDetails();
  //   var platformChannelSpecifics = notifs.NotificationDetails(
  //       android: androidSpecifics, iOS: iOSSpecifics);
  //   await notifsPlugin.zonedSchedule(0, title, "Scheduled notification",
  //       scheduledTime, platformChannelSpecifics,
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation: notifs
  //           .UILocalNotificationDateInterpretation
  //           .absoluteTime); // This literally schedules the notification
  // }

  ListView todoListItems() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int postion) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  this.medicines[postion].id.toString(),
                ),
              ),
              title: Text(this.medicines[postion].title),
              subtitle: Text("date of notification : " +
                      this.medicines[postion].dateOfNotification.toString(),)
               ,
              onTap: () {
                debugPrint(
                    "Tapped on " + this.medicines[postion].numberOfDaysBeforeEndOfStockToNotify.toString());
                navigateToDetailPage(this.medicines[postion]);
              },
            ),
          );
        });
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final todoFuture = helper.getMidicines();
      todoFuture.then((result) {
        List<Medicine> medicineList = <Medicine>[];
        count = result.length;
        for (int i = 0; i < count; i++) {
          medicineList.add(Medicine.fromObject(result[i]));
          debugPrint(medicineList[i].title);
        }
        setState(() {
          medicines = medicineList;
          count = count;
        });
        debugPrint("Items " + count.toString());
      });
    });
  }

  // Color getPriorityColor(int priority) {
  //   Color color = Colors.green;
  //   switch (priority) {
  //     case 1:
  //       color = Colors.red;
  //       break;

  //     case 2:
  //       color = Colors.orange;
  //       break;
  //   }
  //   return color;
  // }

  void navigateToDetailPage(Medicine medicine) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MedicalDetail(medicine)),
    );
    if (result == true) {
      getData();
    } else
      debugPrint("the value of result is" + result.toString());
  }
}
