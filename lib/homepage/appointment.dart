import 'dart:convert';

import 'package:doctor/constant/strings.dart';
import 'package:doctor/model/person/user.dart';
import 'package:doctor/providers/page_controller.dart';
import 'package:doctor/services/request.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MyAppointment extends StatefulWidget {
  const MyAppointment({Key? key}) : super(key: key);

  @override
  State<MyAppointment> createState() => _MyAppointmentState();
}

class _MyAppointmentState extends State<MyAppointment> {
  List<String> headers = ['Appointments', 'Prescriptions', 'Medical Records', 'Billing'];
  final box = Hive.box<User>(BoxName);
  Map<String, dynamic> resultMap = {};
  bool isPageLoading = true;

  String index = 'Appointments';

  @override
  void initState() {
    getMyAppointment().then((value) {
      setState(() {
        isPageLoading = false;
        resultMap = value;
      });
    });
    super.initState();
  }

  Future<Map<String, dynamic>> getMyAppointment() async {
    final response = await http.Client().get(Uri.parse('${ROOTNEWURL}/api/appointments'), headers: {'Authorization': 'Bearer ${box.get(USERPATH)!.token}'});
    print(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Color(0xFFf6f6f6),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
            width: MediaQuery.of(context).size.width,
            color: BLUECOLOR,
            child: Column(children: [
              const SizedBox(
                height: 40.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () => context.read<HomeController>().onBackPress(),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 18.0,
                      )),
                  Text('Appointments', style: getCustomFont(color: Colors.white, size: 16.0)),
                  Icon(
                    null,
                    color: Colors.white,
                  )
                ],
              ),
              const SizedBox(
                height: 15.0,
              ),
            ]),
          ),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(5, (index) => appointmentItem()),
                    ),
                  )))
        ],
      ),
    );
  }

  Widget appointmentItem() {
    return Container(
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Colors.white, boxShadow: SHADOW),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: FittedBox(
                  child: Text(
                    'Booking Date - 16 Mar 2022',
                    maxLines: 1,
                    style: getCustomFont(size: 14.0, color: Colors.black, weight: FontWeight.w400),
                  ),
                )),
                Text(
                  'dental',
                  style: getCustomFont(size: 14.0, color: Colors.black45, weight: FontWeight.w400),
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: AssetImage('assets/imgs/1.png'),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. Ruby Perrln',
                      style: getCustomFont(color: Colors.black, size: 17.0, weight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    Text(
                      'Appt Date - 22 Mar 2020, 4:30PM',
                      style: getCustomFont(color: Colors.black54, size: 13.0, weight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      '\$150.00',
                      style: getCustomFont(color: Colors.black, size: 13.0, weight: FontWeight.w400),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getButton(context, () {}, icon: Icons.cancel, text: 'Decline', color: Colors.redAccent),
                const SizedBox(
                  width: 10.0,
                ),
                getButton(context, () {}, icon: Icons.check, text: 'Confirm', color: Colors.lightGreen),
                const SizedBox(
                  width: 10.0,
                ),
                getButton(context, () {}, icon: Icons.sync, text: 'Reschedule', color: Colors.orange),
              ],
            )
          ],
        ));
  }

  Widget getButton(context, callBack, {text = 'View', icon = Icons.remove_red_eye, color = Colors.lightBlueAccent}) => GestureDetector(
        onTap: () => callBack(),
        child: Container(
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(50.0)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 7.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  size: 14.0,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Text(
                  '$text',
                  maxLines: 1,
                  style: getCustomFont(size: 11.5, color: Colors.white, weight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
      );
}
