import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:doctor/constanst/strings.dart';
import 'package:doctor/model/scheduleModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ScheduleTiming extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffold;
  const ScheduleTiming(this.scaffold, {super.key});

  @override
  State<ScheduleTiming> createState() => _ScheduleTimingState();
}

class _ScheduleTimingState extends State<ScheduleTiming> {
  List<ScheduleModel> scheduleModel = [];

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
                height: 43.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            widget.scaffold.currentState!.openDrawer();
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 18.0,
                          )),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Text('Schedule Timinig',
                          style:
                              getCustomFont(size: 18.0, color: Colors.white)),
                    ],
                  ),
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
                initialSelectedDate: DateTime.now(),
                selectionColor: Colors.white,
                selectedTextColor: Colors.black,
                dayTextStyle: getCustomFont(color: Colors.white, size: 10.0),
                dateTextStyle: getCustomFont(color: Colors.white, size: 19.0),
                monthTextStyle: getCustomFont(color: Colors.white, size: 10.0),
                onDateChange: (date) {
                  setState(() {
                    var index = scheduleModel.indexWhere(
                        (element) => element.scheduleData.containsKey(date));
                    if (index < 0) 
                      scheduleModel.add(ScheduleModel({date: []}, isEdit: false));
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
                              horizontal: 15.0, vertical: 15.0),
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
                                  size: 18.0,
                                  color: Colors.black,
                                  weight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 1.0,
                            ),
                            Text(
                              'Timing and Duration',
                              style: getCustomFont(
                                  size: 13.0,
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
                          style: getCustomFont(size: 12.0, color: Colors.black),
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
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...scheduleModel.map((e) => scheduleItem(e)),
                              const SizedBox(
                                height: 50.0,
                              )
                            ],
                          ),
                        )))
              ],
            ),
          ))
        ]));
  }

  scheduleItem(ScheduleModel e) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                child: FittedBox(
                    child: Text(
              'Time Slot - ${DateFormat('EEE, dd').format(e.scheduleData.keys.last)}',
              style: getCustomFont(
                  size: 15.0, color: Colors.black, weight: FontWeight.w500),
            ))),
            GestureDetector(
              onTap: () => setState(() => e.setIsEdit(!e.isEdit)),
              child: Row(
                children: [
                  Icon(
                    e.isEdit ? Icons.check : Icons.edit,
                    color: e.isEdit ? Colors.green : Colors.black,
                    size: 18.0,
                  ),
                  const SizedBox(
                    width: 2.0,
                  ),
                  Text(
                    e.isEdit ? 'Done' : 'Edit',
                    style: getCustomFont(
                        size: 15.0,
                        color: Colors.black,
                        weight: FontWeight.w500),
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        GridView.builder(
            padding: const EdgeInsets.all(0.0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15.0,
                mainAxisExtent: 45.0,
                crossAxisSpacing: 8.0),
            itemCount: e.scheduleData.values.last.length,
            itemBuilder: (ctx, i) => timeItem(e.scheduleData.values.last, i)),
        SizedBox(height: e.isEdit ? 10.0 : 0.0,),
        e.isEdit? GestureDetector(
          onTap: () {
            setState(() {
              e.scheduleData.values.last.add(ScheduleTimingModel(timeStart: DateTime.now(), timeEnd: DateTime.now()));
            });
          },
          child: Icon(Icons.add_circle_outline, color:BLUECOLOR,)):SizedBox(),
        const SizedBox(
          height: 30.0,
        ),
      ]);

  timeItem(List<ScheduleTimingModel> value, int i) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          border: Border.all(width: 1.3, color: BLUECOLOR),
        ),
        child: Row(children: [
          Text(
            '2: 00 PM',
            style: getCustomFont(
                size: 14.0, color: Colors.black, weight: FontWeight.w500),
          ),
          Text(
            ' - ',
            style: getCustomFont(
                size: 14.0, color: Colors.black, weight: FontWeight.w500),
          ),
          Text(
            '2: 00 PM',
            style: getCustomFont(
                size: 14.0, color: Colors.black, weight: FontWeight.w500),
          ),
          const SizedBox(
            width: 20.0,
          ),
          GestureDetector(
            onTap: () => setState(() => value.removeAt(i)),
            child: Icon(
              Icons.remove_circle_outline,
              color: Colors.redAccent,
              size: 19.0,
            ),
          )
        ]),
      );
}
