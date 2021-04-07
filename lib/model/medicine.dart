import 'package:flutter/scheduler.dart';

class Medicine {
  int _id;
  String _title;
  int _quantityOfPackges;
  int _quantityOfPills;
  int _drugPerDay;
  int _numberOfDaysBeforeEndOfStockToNotify;
  String _dateOfAdd;
  String _dateOfNotification;

  Medicine(
      this._title,
      this._quantityOfPackges,
      this._quantityOfPills,
      this._drugPerDay,
      this._numberOfDaysBeforeEndOfStockToNotify,
      this._dateOfAdd,
      this._dateOfNotification);

  Medicine.withId(
      this._id,
      this._title,
      this._quantityOfPackges,
      this._quantityOfPills,
      this._drugPerDay,
      this._numberOfDaysBeforeEndOfStockToNotify,
      this._dateOfAdd,
      this._dateOfNotification);

  int get id => _id;
  String get title => _title;
  int get quantityOfPackges => _quantityOfPackges;
  int get quantityOfPills => _quantityOfPills;
  int get drugPerDay => _drugPerDay;
  int get numberOfDaysBeforeEndOfStockToNotify =>
      _numberOfDaysBeforeEndOfStockToNotify;
  String get dateOfAdd => _dateOfAdd;
  String get dateOfNotification => _dateOfNotification;

  set title(String newTilte) {
    if (newTilte.length <= 255) {
      _title = newTilte;
    }
  }

  set quantityOfPackges(int newQuantity) {
    _quantityOfPackges = newQuantity;
  }

  set quantityOfPills(int newQuantity) {
    _quantityOfPills = newQuantity;
  }

  set drugPerDay(int newDrugPerDay) {
    _drugPerDay = newDrugPerDay;
  }

  set dateOfAdd(String newDateOfAdd) {
    _dateOfAdd = newDateOfAdd;
  }

  set dateOfNotification(String newDateOfNotification) {
    _dateOfNotification = newDateOfNotification;
  }

  set numberOfDaysBeforeEndOfStockToNotify(int newNumberOfDays) {
    _numberOfDaysBeforeEndOfStockToNotify = newNumberOfDays;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["title"] = _title;
    map["quantityOfPackges"] = _quantityOfPackges;
    map["quantityOfPills"] = _quantityOfPills;
    map["drugPerDay"] = _drugPerDay;
    map["numberOfDaysBeforeEndOfStockToNotify"] =
        _numberOfDaysBeforeEndOfStockToNotify;
    map["dateOfAdd"] = _dateOfAdd;
    map["dateOfNotification"] = _dateOfNotification;
    if (_id != null) {
      map["id"] = _id;
    }

    return map;
  }

  Medicine.fromObject(dynamic o) {
    this._id = o["id"];
    this._title = o["title"];
    this._quantityOfPackges = o["quantityOfPackges"];
    this._quantityOfPills = o["quantityOfPills"];
    this._drugPerDay = o["drugPerDay"];
    this._numberOfDaysBeforeEndOfStockToNotify =
        o["numberOfDaysBeforeEndOfStockToNotify"];
    this._dateOfAdd = o["dateOfAdd"];
    this._dateOfNotification = o["dateOfNotification"];
  }
}
