import 'package:calendar_view/calendar_view.dart';
import 'package:doctor/constanst/strings.dart';
import 'package:doctor/providers/calendar_controller.dart';
import 'package:doctor/providers/page_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar({Key? key}) : super(key: key);

  @override
  State<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    var controller = context.read<CalendarController>();
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
                height: 89.0,
                color: BLUECOLOR,
                child: Column(children: [
                  const SizedBox(
                    height: 50.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            size: 20.0,
                          )),
                      Text(counter == 0 ? 'My Calender' : 'Create Event',
                          style:
                              getCustomFont(size: 18.0, color: Colors.white)),
                      Icon(
                        null,
                        color: Colors.white,
                      )
                    ],
                  )
                ]),
              ),
              Expanded(
                  child: counter == 0
                      ? WeekView(
                          controller: controller.eventController,
                          eventTileBuilder: (date, events, boundry, start, end) {
                              return Container();
                          },
                          showLiveTimeLineInAllDays: true,
                          width: MediaQuery.of(context).size.width, // width of week view.
                          minDay: DateTime(1990),
                          maxDay: DateTime(2950),
                          initialDay: DateTime(2021),
                          heightPerMinute: 1, // height occupied by 1 minute time span.
                          eventArranger: SideEventArranger(), // To define how simultaneous events will be arranged.
                          onEventTap: (events, date) => print(events),
                          onDateLongPress: (date) => print(date),
                          startDay: WeekDays.sunday, // To change the first day of the week.
                      )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           
                          ],
                        ))
            ])),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: FloatingActionButton(
              tooltip: 'Add note',
              child: Icon(
                Icons.event,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  counter = 1;
                });
              },
              backgroundColor: BLUECOLOR,
            ),
          ),
        ),
      ],
    );
  }
}
