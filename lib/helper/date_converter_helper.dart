import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DateConverterHelper {

  static bool isAvailable(String start, String end, {DateTime? time}) {
    DateTime currentTime;

    if(time != null) {
      currentTime = time;
    } else {
      currentTime = Provider.of<SplashProvider>(Get.context!, listen: false).currentTime;
    }

    DateTime start0 = DateFormat('hh:mm:ss').parse(start);
    DateTime end0 = DateFormat('hh:mm:ss').parse(end);
    DateTime startTime = DateTime(currentTime.year, currentTime.month, currentTime.day, start0.hour, start0.minute, start0.second);
    DateTime endTime = DateTime(currentTime.year, currentTime.month, currentTime.day, end0.hour, end0.minute, end0.second);

    if(endTime.isBefore(startTime)) {
      if(currentTime.isBefore(startTime) && currentTime.isBefore(endTime)) {
        startTime = startTime.add(const Duration(days: -1));
      } else {
        endTime = endTime.add(const Duration(days: 1));
      }
    }

    return currentTime.isAfter(startTime) && currentTime.isBefore(endTime);
  }

  static String convertTimeToTime(String time, BuildContext context) {
    return DateFormat("HH:mm").format(DateFormat("HH:mm").parse(time));
  }

  static DateTime convertStringTimeToDate(String time) => DateFormat('HH:mm').parse(time);

  static String dateToTimeOnly(DateTime dateTime, BuildContext context) {
    return DateFormat("HH:mm").format(dateTime);
  }

  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd MM yyyy').format(dateTime);
  }

  static String formatDate(DateTime? dateTime, BuildContext context, {bool isSecond = true}) {
      return isSecond ? DateFormat('yyyy-MM-dd ${'HH:mm:ss'}').format(dateTime!)
          : DateFormat('yyyy-MM-dd ${'HH:mm'}').format(dateTime!);
  }

  static DateTime isoStringToLocalDate(String dateTime, {String? format}) {
    return DateFormat(format ?? 'yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime, true).toLocal();
  }
}