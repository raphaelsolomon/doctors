import 'package:doctor/constanst/strings.dart';
import 'package:doctor/dialog/schedule.dart';
import 'package:doctor/dialog/subscribe.dart';
import 'package:doctor/model/event_model.dart';
import 'package:doctor/providers/page_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar({Key? key}) : super(key: key);

  @override
  State<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  int counter = 0;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDate = new DateTime.now();
  DateTime focusDate = new DateTime.now();

  Map<DateTime, List<Event>> selectedEvent = {};

  @override
  void initState() {
    selectedEvent = {};
    super.initState();
  }

  List<Event> getEventFromDay(date) {
    return selectedEvent[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color(0xFFf6f6f6),
            child: Column(children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
                width: MediaQuery.of(context).size.width,
                color: BLUECOLOR,
                child: Column(children: [
                  const SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                if (counter <= 0) {
                                  context.read<HomeController>().onBackPress();
                                } else {
                                  setState(() {
                                    counter = counter - 1;
                                  });
                                }
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 18.0,
                              )),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Text(counter == 0 ? 'My Calender' : 'Create Event',
                              style: getCustomFont(
                                  size: 18.0, color: Colors.white)),
                        ],
                      ),
                      Icon(
                        null,
                        color: Colors.white,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  // DatePicker(
                  //   DateTime.now(),
                  //   initialSelectedDate: DateTime.now(),
                  //   selectionColor: Colors.white,
                  //   selectedTextColor: Colors.black,
                  //   dayTextStyle: getCustomFont(color: Colors.white, size: 10.0),
                  //   dateTextStyle: getCustomFont(color: Colors.white, size: 19.0),
                  //   monthTextStyle: getCustomFont(color: Colors.white, size: 10.0),
                  //   onDateChange: (date) {
                  //     // New date selected
                  //     setState(() {});
                  //   },
                  // ),
                  //  const SizedBox(
                  //   height: 10.0,
                  // ),
                ]),
              ),
              Expanded(
                  child: counter == 0
                      ? Column(
                          children: [
                            TableCalendar(
                                focusedDay: focusDate,
                                firstDay: DateTime(1998),
                                lastDay: DateTime(2200),
                                startingDayOfWeek: StartingDayOfWeek.sunday,
                                daysOfWeekVisible: true,
                                calendarFormat: format,
                                eventLoader: getEventFromDay,
                                selectedDayPredicate: (day) =>
                                    isSameDay(selectedDate, day),
                                calendarStyle: CalendarStyle(
                                    isTodayHighlighted: true,
                                    todayDecoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: BLUECOLOR.withOpacity(.5)),
                                    selectedTextStyle: getCustomFont(
                                        color: Colors.white,
                                        weight: FontWeight.w500),
                                    selectedDecoration: BoxDecoration(
                                        color: BLUECOLOR,
                                        shape: BoxShape.circle),
                                    defaultDecoration:
                                        BoxDecoration(shape: BoxShape.circle),
                                    weekendDecoration:
                                        BoxDecoration(shape: BoxShape.circle)),
                                onDaySelected: ((selectedDay, focusedDay) =>
                                    setState(() {
                                      selectedDate = selectedDay;
                                      focusDate = focusedDay;
                                    })),
                                headerStyle: HeaderStyle(
                                    formatButtonVisible: true,
                                    formatButtonShowsNext: true,
                                    titleCentered: false),
                                onFormatChanged: (format) => setState(() {
                                      this.format = format;
                                    })),
                            Expanded(
                              child: Column(
                                children: getEventFromDay(selectedDate)
                                    .map((e) => Text(e.title))
                                    .toList(),
                              ),
                            )
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [],
                        ))
            ])),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: FloatingActionButton.extended(
              label: Text('Add Schedule'),
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                showRequestSheet(context,
                    ScheduleCalender(callBack: (title, desc) {
                  setState(() {
                    if (selectedEvent[selectedDate] != null) {
                      selectedEvent[selectedDate]!
                          .add(Event(title: title, description: desc));
                    } else {
                      selectedEvent[selectedDate] = [
                        Event(title: title, description: desc)
                      ];
                    }
                  });
                }));
              },
              backgroundColor: BLUECOLOR,
            ),
          ),
        ),
      ],
    );
  }
}
