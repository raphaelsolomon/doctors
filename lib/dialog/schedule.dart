import 'package:doctor/constant/strings.dart';
import 'package:doctor/dialog/subscribe.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleCalender extends StatefulWidget {
  final Function callBack;
  const ScheduleCalender({required this.callBack, Key? key}) : super(key: key);

  @override
  State<ScheduleCalender> createState() => _ScheduleCalenderState();
}

class _ScheduleCalenderState extends State<ScheduleCalender> {
  final eventTitle = TextEditingController();
  final eventDesc = TextEditingController();
  TimeOfDay? current = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

  @override
  void dispose() {
    eventDesc.dispose();
    eventTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 9.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Text(
                'Add New Event',
                style: getCustomFont(
                    size: 14.0, color: Colors.black, weight: FontWeight.w500),
              )),
              Icon(
                Icons.cancel_outlined,
                color: Colors.black45,
              ),
            ],
          ),
          Divider(),
          const SizedBox(
            height: 10.0,
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Event Title',
                    style: getCustomFont(
                        size: 15.0,
                        color: Colors.black,
                        weight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                getCardForm('Event Title', ctl: eventTitle),
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Event Description',
                    style: getCustomFont(
                        size: 15.0,
                        color: Colors.black,
                        weight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                getRichCardForm('Event Description', ctl: eventDesc),
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Event Time',
                    style: getCustomFont(
                        size: 15.0,
                        color: Colors.black,
                        weight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                getTimeForm('${ formatTimeOfDay(current!)}', () async {
                    current = await _selectTime(context);
                    setState(() {});
                }),
                const SizedBox(
                  height: 30.0,
                ),
                Divider(),
                const SizedBox(
                  height: 20.0,
                ),
                getButton(context, () {
                  if (eventTitle.text.trim().isEmpty) {
                    dialogMessage(
                        context, serviceMessage(context, 'Title is required'));
                    return;
                  }
                  if (eventDesc.text.trim().isEmpty) {
                    dialogMessage(
                        context, serviceMessage(context, 'Description is required'));
                    return;
                  }
                  widget.callBack(eventTitle.text, eventDesc.text, formatTimeOfDay(current!));
                  Navigator.pop(context);
                }),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }

  getCardForm(hint, {ctl}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        height: 45.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: BLUECOLOR.withOpacity(.05)),
        child: TextField(
          controller: ctl,
          style: getCustomFont(size: 14.0, color: Colors.black45),
          maxLines: 1,
          decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
              hintStyle: getCustomFont(size: 14.0, color: Colors.black45),
              border: OutlineInputBorder(borderSide: BorderSide.none)),
        ),
      ),
    );
  }

  getRichCardForm(hint, {ctl}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        height: 140.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: BLUECOLOR.withOpacity(.05)),
        child: TextField(
          style: getCustomFont(size: 14.0, color: Colors.black45),
          maxLines: null,
          controller: ctl,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
              hintStyle: getCustomFont(size: 14.0, color: Colors.black45),
              border: OutlineInputBorder(borderSide: BorderSide.none)),
        ),
      ),
    );
  }

  getTimeForm(text, callBack) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: GestureDetector(
        onTap: () => callBack(),
        child: Container(
          height: 45.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: BLUECOLOR.withOpacity(.05)),
          child: Text('${text}', style: getCustomFont(size: 14.0, color: Colors.black45))
        ),
      ),
    );
  }

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

  Widget getButton(context, callBack) => GestureDetector(
        onTap: () => callBack(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 45.0,
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
          decoration: BoxDecoration(
              color: BLUECOLOR, borderRadius: BorderRadius.circular(50.0)),
          child: Center(
            child: Text(
              'Add Schedule',
              style: getCustomFont(
                  size: 14.0, color: Colors.white, weight: FontWeight.normal),
            ),
          ),
        ),
      );
}
