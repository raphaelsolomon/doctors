import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';

class CalendarController with ChangeNotifier {
  static final EventController eventController = EventController();

  void add(CalendarEventData event) {
    eventController.add(event);
    notifyListeners();
  }

   get controller => eventController;
}