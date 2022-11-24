import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:doctor/constant/strings.dart';
import 'package:doctor/model/scheduleModel.dart';
import 'package:doctor/providers/page_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class ScheduleTiming extends StatefulWidget {
  const ScheduleTiming({super.key});

  @override
  State<ScheduleTiming> createState() => _ScheduleTimingState();
}

class _ScheduleTimingState extends State<ScheduleTiming> {
  List<ScheduleModel> scheduleModel = [];
  int index = 0;
  final controller = DatePickerController();
  DateTime current = new DateTime.now();

  @override
  void initState() {
    scheduleModel.add(ScheduleModel({
      DateFormat('yyyy-MM-dd').format(current): ScheduleTimingModel(
          earlyMorningShift: [],
          morningShift: [],
          afternoonShift: [],
          eveningShift: [],
          midNightShift: [])
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                height: 45.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        context.read<HomeController>().onBackPress();
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 18.0,
                      )),
                  Text('Schedule Timinig',
                      style: getCustomFont(size: 16.0, color: Colors.white)),
                  Icon(
                    Icons.notifications,
                    color: Colors.white,
                  )
                ],
              ),
              const SizedBox(
                height: 15.0,
              ),
              DatePicker(
                DateTime.now(),
                controller: controller,
                initialSelectedDate: DateTime.now(),
                selectionColor: Colors.white,
                selectedTextColor: Colors.black,
                dayTextStyle: getCustomFont(color: Colors.white, size: 10.0),
                dateTextStyle: getCustomFont(color: Colors.white, size: 19.0),
                monthTextStyle: getCustomFont(color: Colors.white, size: 10.0),
                onDateChange: (date) {
                  setState(() {
                    current = date;
                    int i = scheduleModel.indexWhere((e) => e.scheduleData
                        .containsKey(DateFormat('yyyy-MM-dd').format(date)));
                    if (i < 0) {
                      scheduleModel.add(ScheduleModel({
                        DateFormat('yyyy-MM-dd').format(date):
                            ScheduleTimingModel(
                                earlyMorningShift: [],
                                morningShift: [],
                                afternoonShift: [],
                                eveningShift: [],
                                midNightShift: [])
                      }));
                      index = scheduleModel.length - 1;
                    } else {
                      index = i;
                    }
                  });
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
            ]),
          ),
          Expanded(
              child: Container(
            width: MediaQuery.of(context).size.width,
            color: Color(0xFFf6f6f6),
            child: Column(
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 8.0),
                  child: Row(
                    children: [
                      PhysicalModel(
                        elevation: 10.0,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100.0),
                        shadowColor: Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13.0, vertical: 13.0),
                          child: Icon(
                            Icons.event,
                            size: 19.0,
                            color: Color(0xFF838383),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Schedule Timing',
                              style: getCustomFont(
                                  size: 16.0,
                                  color: Colors.black,
                                  weight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 1.0,
                            ),
                            Text(
                              'Timing and Duration',
                              style: getCustomFont(
                                  size: 12.0,
                                  color: Colors.black45,
                                  weight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      CircularPercentIndicator(
                        radius: 30.0,
                        lineWidth: 5.0,
                        percent: 0.5,
                        center: FittedBox(
                            child: Text(
                          '30\nAppts',
                          textAlign: TextAlign.center,
                          style: getCustomFont(size: 11.0, color: Colors.black),
                        )),
                        backgroundColor: Colors.grey.shade100,
                        progressColor: BLUECOLOR,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Expanded(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            boxShadow: SHADOW,
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(20.0))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  newDesign(scheduleModel[index]),
                                ],
                              ),
                            )),
                            const SizedBox(
                              height: 30.0,
                            ),
                            Row(children: [
                              Flexible(
                                  child: InkWell(
                                onTap: () {
                                  controller.animateToDate(
                                      DateTime(current.year, current.month,
                                          current.day + 1),
                                      duration: Duration(seconds: 1),
                                      curve: Curves.linear);
                                  setState(() {});
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(7.0)),
                                  child: Center(
                                    child: Text('Next Day',
                                        style: getCustomFont(
                                            size: 13.0, color: Colors.white)),
                                  ),
                                ),
                              )),
                              const SizedBox(
                                width: 20.0,
                              ),
                              Flexible(
                                  child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                decoration: BoxDecoration(
                                    color: BLUECOLOR,
                                    borderRadius: BorderRadius.circular(7.0)),
                                child: Center(
                                  child: Text('Save Schedule',
                                      style: getCustomFont(
                                          size: 13.0, color: Colors.white)),
                                ),
                              ))
                            ]),
                            const SizedBox(
                              height: 5.0,
                            )
                          ],
                        )))
              ],
            ),
          ))
        ]));
  }

  Widget newDesign(ScheduleModel e) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Early Morning Time Slot',
                    style: getCustomFont(
                        size: 14.0,
                        color: Colors.black87,
                        weight: FontWeight.w500),
                  ),
                ),
                GestureDetector(
                    onTap: () async {
                      var time = await _selectTime(context);
                      String newTime = formatTimeOfDay(time!);
                      setState(() {
                        e.scheduleData.values.last.earlyMorningShift
                            .add(newTime);
                      });
                    },
                    child: Icon(Icons.add_circle_outline,
                        size: 18.0, color: Colors.green))
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                children: e.scheduleData.values.last.earlyMorningShift
                    .map((e) => Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 7.0, vertical: 7.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9.0, vertical: 7.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          e,
                          style:
                              getCustomFont(size: 12.5, color: Colors.black87),
                        )))
                    .toList(),
              ),
            ),
            const SizedBox(
              height: 15.0,
            )
          ]),
        ),
        const SizedBox(
          height: 7.0,
        ),
        Container(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Morning Time Slot',
                    style: getCustomFont(
                        size: 14.0,
                        color: Colors.black87,
                        weight: FontWeight.w500),
                  ),
                ),
                GestureDetector(
                    onTap: () async {
                      var time = await _selectTime(context);
                      String newTime = formatTimeOfDay(time!);
                      setState(() {
                        e.scheduleData.values.last.morningShift.add(newTime);
                      });
                    },
                    child: Icon(Icons.add_circle_outline,
                        size: 18.0, color: Colors.green))
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                children: e.scheduleData.values.last.morningShift
                    .map((e) => Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 7.0, vertical: 7.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9.0, vertical: 7.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          e,
                          style:
                              getCustomFont(size: 12.5, color: Colors.black87),
                        )))
                    .toList(),
              ),
            ),
            const SizedBox(
              height: 15.0,
            )
          ]),
        ),
        const SizedBox(
          height: 7.0,
        ),
        Container(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Afternoon Time Slot',
                    style: getCustomFont(
                        size: 14.0,
                        color: Colors.black87,
                        weight: FontWeight.w500),
                  ),
                ),
                GestureDetector(
                    onTap: () async {
                      var time = await _selectTime(context);
                      String newTime = formatTimeOfDay(time!);
                      setState(() {
                        e.scheduleData.values.last.afternoonShift.add(newTime);
                      });
                    },
                    child: Icon(Icons.add_circle_outline,
                        size: 18.0, color: Colors.green))
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                children: e.scheduleData.values.last.afternoonShift
                    .map((e) => Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 7.0, vertical: 7.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9.0, vertical: 7.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          e,
                          style:
                              getCustomFont(size: 12.5, color: Colors.black87),
                        )))
                    .toList(),
              ),
            ),
            const SizedBox(
              height: 15.0,
            )
          ]),
        ),
        const SizedBox(
          height: 7.0,
        ),
        Container(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Evening Time Slot',
                    style: getCustomFont(
                        size: 14.0,
                        color: Colors.black87,
                        weight: FontWeight.w500),
                  ),
                ),
                GestureDetector(
                    onTap: () async {
                      var time = await _selectTime(context);
                      String newTime = formatTimeOfDay(time!);
                      setState(() {
                        e.scheduleData.values.last.eveningShift.add(newTime);
                      });
                    },
                    child: Icon(Icons.add_circle_outline,
                        size: 18.0, color: Colors.green))
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                children: e.scheduleData.values.last.eveningShift
                    .map((e) => Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 7.0, vertical: 7.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9.0, vertical: 7.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          e,
                          style:
                              getCustomFont(size: 12.5, color: Colors.black87),
                        )))
                    .toList(),
              ),
            ),
            const SizedBox(
              height: 15.0,
            )
          ]),
        ),
        const SizedBox(
          height: 7.0,
        ),
        Container(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Mid Night Time Slot',
                    style: getCustomFont(
                        size: 14.0,
                        color: Colors.black87,
                        weight: FontWeight.w500),
                  ),
                ),
                GestureDetector(
                    onTap: () async {
                      var time = await _selectTime(context);
                      String newTime = formatTimeOfDay(time!);
                      setState(() {
                        e.scheduleData.values.last.midNightShift.add(newTime);
                      });
                    },
                    child: Icon(Icons.add_circle_outline,
                        size: 18.0, color: Colors.green))
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                children: e.scheduleData.values.last.midNightShift
                    .map((e) => Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 7.0, vertical: 7.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9.0, vertical: 7.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          e,
                          style:
                              getCustomFont(size: 12.5, color: Colors.black87),
                        )))
                    .toList(),
              ),
            ),
            const SizedBox(
              height: 15.0,
            )
          ]),
        ),
      ]);

  Future<TimeOfDay?> _selectTime(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay.now();
    return await showTimePicker(context: context, initialTime: selectedTime);
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }
}
