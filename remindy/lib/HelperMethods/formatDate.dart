import 'package:flutter/material.dart';

class FormatDate {
  static final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'SeptemberOctober',
    'November',
    'December'
  ];
  final List<String> weeks = [];

  static formatDate(DateTime date) {
    return (date.day.toString() +
        ' ' +
        FormatDate.months[date.month - 1] +
        ' ,' +
        date.year.toString());
  }

  static formatTime(TimeOfDay time) {
    String hr = time.hourOfPeriod < 10
        ? '0' + time.hourOfPeriod.toString()
        : time.hourOfPeriod.toString();
    String mi = time.minute < 10
        ? '0' + time.minute.toString()
        : time.minute.toString();

    String ampm = time.period == DayPeriod.am ? 'AM' : 'PM';
    return (hr + ':' + mi + ' ' + ampm);
  }
}
