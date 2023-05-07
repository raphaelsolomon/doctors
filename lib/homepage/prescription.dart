import 'dart:convert';

import 'package:doctor/constant/strings.dart';
import 'package:doctor/dialog/alert_item.dart';
import 'package:doctor/dialog/edit_prescription.dart';
import 'package:doctor/dialog/subscribe.dart';
import 'package:doctor/model/person/user.dart';
import 'package:doctor/providers/page_controller.dart';
import 'package:doctor/services/request.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Prescription extends StatefulWidget {
  const Prescription({Key? key}) : super(key: key);

  @override
  State<Prescription> createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {
  final box = Hive.box<User>(BoxName);
  Map<String, dynamic> resultMap = {};
  bool isPageLoading = true;

  @override
  void initState() {
    getMyPrescription().then((value) {
      setState(() {
        isPageLoading = false;
        resultMap = value;
      });
    });
    super.initState();
  }

  Future<Map<String, dynamic>> getMyPrescription() async {
    final response = await http.Client().get(Uri.parse('${ROOTNEWURL}/api/dashboard/prescriptions'), headers: {'Authorization': 'Bearer ${box.get(USERPATH)!.token}'});
    print(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return {};
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
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                width: MediaQuery.of(context).size.width,
                color: BLUECOLOR,
                child: Column(children: [
                  const SizedBox(
                    height: 45.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(onTap: () => context.read<HomeController>().onBackPress(), child: Icon(Icons.arrow_back_ios, size: 18.0, color: Colors.white)),
                      Text('My Prescriptions', style: getCustomFont(size: 16.0, color: Colors.white)),
                      InkWell(
                        onTap: () {
                          context.read<HomeController>().setPage(-22);
                        },
                        child: Icon(
                          null,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  )
                ]),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0), itemCount: 10, shrinkWrap: true, itemBuilder: ((context, index) => prescriptionItem(context))))
            ])),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: FloatingActionButton(
              tooltip: 'Add',
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () => showRequestSheet(context, EditPrescription(false)),
              backgroundColor: BLUECOLOR,
            ),
          ),
        ),
      ],
    );
  }

  Widget prescriptionItem(context) {
    return Container(
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Colors.white, boxShadow: SHADOW),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Text(
                  'Prescription 1',
                  style: getCustomFont(size: 13.0, color: Colors.black, weight: FontWeight.w400),
                )),
                Text(
                  '14 Mar 2022',
                  style: getCustomFont(size: 13.0, color: Colors.black45, weight: FontWeight.w400),
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
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. Ruby Perrln',
                        style: getCustomFont(color: Colors.black, size: 15.0, weight: FontWeight.w400),
                      ),
                      Text(
                        'Dental',
                        style: getCustomFont(color: Colors.black54, size: 12.0, weight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: getButton(context, () => null, icon: Icons.download, text: 'Download', color: Colors.amberAccent),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Flexible(
                            child: getButton(context, () => showRequestSheet(context, EditPrescription(true)), icon: Icons.edit_outlined, text: 'Edit', color: Colors.amberAccent),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Flexible(
                            child: getButton(context, () {
                              showRequestSheet(context, ConfirmationDialog(() {
                                dialogMessage(context, serviceMessage(context, 'Prescription Deleted....', status: true));
                              }));
                            }, icon: Icons.delete_outline, text: 'Delete', color: Colors.redAccent),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
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
                  size: 12.0,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 2.0,
                ),
                Flexible(
                  child: Center(
                    child: Text(
                      '$text',
                      maxLines: 1,
                      style: getCustomFont(size: 11.0, color: Colors.white, weight: FontWeight.normal),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
