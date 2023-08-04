import 'dart:convert';

import 'package:doctor/constant/strings.dart';
import 'package:doctor/person/user.dart';
import 'package:doctor/providers/page_controller.dart';
import 'package:doctor/resuable/form_widgets.dart';
import 'package:doctor/services/request.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MyPatients extends StatefulWidget {
  const MyPatients({super.key});

  @override
  State<MyPatients> createState() => _MyPatientsState();
}

class _MyPatientsState extends State<MyPatients> {
  final box = Hive.box<User>(BoxName);
  Map<String, dynamic> resultMap = {};
  bool isPageLoading = true;

  @override
  void initState() {
    getMyPatients().then((value) {
      setState(() {
        isPageLoading = false;
        resultMap = value;
      });
    });
    super.initState();
  }

  Future<Map<String, dynamic>> getMyPatients() async {
    final response = await http.Client().get(Uri.parse('${ROOTNEWURL}/api/dashboard/all-patients'), headers: {'Authorization': 'Bearer ${box.get(USERPATH)!.token}'});
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
        child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
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
                  Text('My Patients', style: getCustomFont(size: 16.0, color: Colors.white)),
                  Icon(
                    Icons.notifications,
                    color: Colors.white,
                  )
                ],
              ),
              const SizedBox(
                height: 15.0,
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 8.0, top: 15.0, bottom: 15.0),
            child: Row(
              children: [
                PhysicalModel(
                  elevation: 10.0,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100.0),
                  shadowColor: Colors.grey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                    child: Icon(
                      FontAwesome5.person_booth,
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
                        'My Patient List',
                        style: getCustomFont(size: 18.0, color: Colors.black, weight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 1.0,
                      ),
                      Text(
                        '125 patients',
                        style: getCustomFont(size: 13.0, color: Colors.black45, weight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(boxShadow: SHADOW, color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(20.0))),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...List.generate(2, (index) => patientItem(context)),
                        const SizedBox(
                          height: 50.0,
                        )
                      ],
                    ),
                  )))
        ]));
  }
}
