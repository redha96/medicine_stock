import 'package:flutter/material.dart';
import 'package:medicine_stock/model/medicine.dart';
import 'package:medicine_stock/util/dbhelper.dart';
import 'package:intl/intl.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as notifs;
import 'package:rxdart/subjects.dart' as rxSub;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:medicine_stock/main.dart';



class MedicalDetail extends StatefulWidget {
  final Medicine medicine;
  MedicalDetail(this.medicine);

  @override
  State<StatefulWidget> createState() => MedicalDetailState(medicine);
}

DbHelper helper = DbHelper();
final List<String> choices = const <String>[
  'Save Todo & back',
  'Delete Todo',
  'Back to List'
];

const mnuSave = 'Save Todo & back';
const mnuDelete = "Delete Todo";
const mnuBack = "Back to List";

class MedicalDetailState extends State {
  Medicine medicine;
  MedicalDetailState(this.medicine);
  TextEditingController titleController = TextEditingController();
  TextEditingController quantityOfPackgesController = TextEditingController();
  TextEditingController quantityOfPillsController = TextEditingController();
  TextEditingController drugPerDayController = TextEditingController();
  TextEditingController noOfDaysBeforeEndStockController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    titleController.text = medicine.title;
    if (medicine.quantityOfPackges != null) {
      quantityOfPackgesController.text = medicine.quantityOfPackges.toString();
    }
    if (medicine.quantityOfPills != null) {
      quantityOfPillsController.text = medicine.quantityOfPills.toString();
    }
    if (medicine.drugPerDay != null) {
      drugPerDayController.text = medicine.drugPerDay.toString();
    }
    if (medicine.numberOfDaysBeforeEndOfStockToNotify != null) {
      noOfDaysBeforeEndStockController.text =
          medicine.numberOfDaysBeforeEndOfStockToNotify.toString();
    }

    
    TextStyle textStyle = Theme.of(context).textTheme.subtitle2;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(medicine.title),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: select,
              itemBuilder: (BuildContext context) {
                return choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              })
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                TextField(
                  controller: titleController,
                  style: textStyle,
                  onChanged: (value) => this.updateTitle(),
                  decoration: InputDecoration(
                    labelText: "Title",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: quantityOfPackgesController,
                    style: textStyle,
                    onChanged: (value) => this.updateQuantityOfPackges(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "quantity of packges",
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: quantityOfPillsController,
                    style: textStyle,
                    onChanged: (value) => this.updateQuantityOfPills(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "pills per package",
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: drugPerDayController,
                    style: textStyle,
                    onChanged: (value) => this.updateDrugPerDay(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Drugs per day",
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: noOfDaysBeforeEndStockController,
                    style: textStyle,
                    onChanged: (value) =>
                        this.updateNumberOfDaysBeforeEndStack(),
                        keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Days Before the stock end",
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void select(String value) async {
    int result;
    switch (value) {
      case mnuBack:
        Navigator.pop(context);
        break;
      case mnuSave:
        save();
        break;
      case mnuDelete:
        Navigator.pop(context, true);
        if (medicine.id == null) {
          return;
        }
        result = await helper.deleteTodo(medicine.id);
        if (result != 0) {
          AlertDialog alertDialog = AlertDialog(
            title: Text("Delelte Todo"),
            content: Text("The Todo has been Deleted"),
          );
          showDialog(context: context, builder: (_) => alertDialog);
        }
        break;
    }
  }

  void calculateDates() {
    medicine.dateOfAdd = DateFormat.yMd().format(DateTime.now());

    //  this operator ~/ will give an intger result
    int numberOfDaysToNotify = medicine.quantityOfPackges *
        medicine.quantityOfPills ~/ medicine.drugPerDay -
        medicine.numberOfDaysBeforeEndOfStockToNotify;

    medicine.dateOfNotification = DateFormat.yMd()
        .format(DateTime.now().add(new Duration(days: numberOfDaysToNotify)));
    print('the date is ' + DateTime.now().toString());
  }

  void save() {
    // medicine.dateOfAdd = new DateFormat.yMd().format(DateTime.now());
    calculateDates();
    if (medicine.id != null) {
      helper.updateMedicine(medicine);
    } else {
      helper.insertMidicine(medicine);
    }
    Navigator.pop(context, true);
  }

  void updateTitle() {
    medicine.title = titleController.text;
  }

  void updateQuantityOfPackges() {
    medicine.quantityOfPackges = int.parse(quantityOfPackgesController.text);
  }

  void updateQuantityOfPills() {
    medicine.quantityOfPills = int.parse(quantityOfPillsController.text);
  }

  void updateDrugPerDay() {
    medicine.drugPerDay = int.parse(drugPerDayController.text);
  }

  void updateNumberOfDaysBeforeEndStack() {
    medicine.numberOfDaysBeforeEndOfStockToNotify =
        int.parse(noOfDaysBeforeEndStockController.text);
  }

   Future<void> setTime() async {
    await tz.initializeTimeZones();
    
    tz.setLocalLocation(tz.getLocation('Asia/Baghdad'));

    print(tz.local.currentTimeZone.toString());

    var time = DateTime.now().add(const Duration(seconds: 10));
    // time = time.add(const Duration(hours: 3));
    scheduleNotification(
      notifsPlugin: notifsPlugin, //Or whatever you've named it in main.dart
      id: medicine.title,
      body: "your drug stock about to end",
      scheduledTime: tz.TZDateTime.from(
        time,
        //tz.getLocation('Asia/Baghdad')
        tz.local,
      ),
    ); //Or whenever you actually want to trigger it
  }

  Future<void> scheduleNotification(
      {notifs.FlutterLocalNotificationsPlugin notifsPlugin,
      String id,
      String title,
      String body,
      DateTime scheduledTime}) async {
    var androidSpecifics = notifs.AndroidNotificationDetails(
      id, // This specifies the ID of the Notification
      'Scheduled notification', // This specifies the name of the notification channel
      'A scheduled notification', //This specifies the description of the channel
      icon: 'icon',
    );
    var iOSSpecifics = notifs.IOSNotificationDetails();
    var platformChannelSpecifics = notifs.NotificationDetails(
        android: androidSpecifics, iOS: iOSSpecifics);
    await notifsPlugin.zonedSchedule(0, title, "Scheduled notification",
        scheduledTime, platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: notifs
            .UILocalNotificationDateInterpretation
            .absoluteTime); // This literally schedules the notification
  }
}
