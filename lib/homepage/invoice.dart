import 'dart:convert';

import 'package:doctor/company/invoice_receipt.dart';
import 'package:doctor/constant/strings.dart';
import 'package:doctor/dialog/alert_item.dart';
import 'package:doctor/dialog/subscribe.dart';
import 'package:doctor/person/user.dart';
import 'package:doctor/providers/page_controller.dart';
import 'package:doctor/services/request.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class MyInvoicePage extends StatefulWidget {
  const MyInvoicePage({Key? key}) : super(key: key);

  @override
  State<MyInvoicePage> createState() => _MyInvoicePageState();
}

class _MyInvoicePageState extends State<MyInvoicePage> {
  final box = Hive.box<User>(BoxName);
  Map<String, dynamic> resultMap = {};
  bool isPageLoading = true;

  @override
  void initState() {
    getMyPInvoices().then((value) {
      setState(() {
        isPageLoading = false;
        resultMap = value;
      });
    });
    super.initState();
  }

  Future<Map<String, dynamic>> getMyPInvoices() async {
    final response = await http.Client().get(Uri.parse('${ROOTNEWURL}/api/dashboard/prescriptions'), headers: {'Authorization': 'Bearer ${box.get(USERPATH)!.token}'});
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
                  Text('Invoices', style: getCustomFont(color: Colors.white, size: 16.0)),
                  InkWell(
                    child: Icon(
                      null,
                      color: Colors.white,
                    ),
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
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...List.generate(6, (index) => invoiceItem()),
                  const SizedBox(
                    height: 90.0,
                  ),
                ],
              ),
            ),
          ))
        ]));
  }

  Widget invoiceItem() {
    return Container(
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Colors.white, boxShadow: SHADOW),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Text(
                  '#MR-0010',
                  style: getCustomFont(size: 12.0, color: Colors.black, weight: FontWeight.w400),
                )),
                Text(
                  'Paid on - 14 Mar 2022',
                  style: getCustomFont(size: 12.0, color: Colors.black45, weight: FontWeight.w400),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Michelle Fairfax',
                            style: getCustomFont(color: Colors.black, size: 17.0, weight: FontWeight.w400),
                          ),
                          Flexible(
                            child: Text(
                              '\$450',
                              style: getCustomFont(color: Colors.black, size: 13.0, weight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3.0),
                      Text(
                        '#PT0025',
                        style: getCustomFont(color: Colors.black45, size: 13.0, weight: FontWeight.w400),
                      ),
                      const SizedBox(height: 3.0),
                      Row(
                        children: [
                          Flexible(
                            child: getButton(context, () => null, icon: Icons.download, text: 'Download', color: Colors.amberAccent),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Flexible(
                            child: getButton(context, () => showRequestSheet(context, InvoiceReceipt()), icon: Icons.share, text: 'view', color: Colors.lightBlue),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Flexible(
                            child: getButton(context, () {
                              showRequestSheet(context, ConfirmationDialog(() {
                                dialogMessage(context, serviceMessage(context, 'Invoice Deleted....', status: true));
                              }));
                            }, icon: Icons.delete_outline, text: 'Delete', color: Colors.redAccent),
                          ),
                        ],
                      )
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width,
                      //   child: Align(
                      //     alignment: Alignment.centerRight,
                      //     child: getButton(context, () {
                      //       context.read<HomeController>().setPage(-21);
                      //     }),
                      //   ),
                      // )
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
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 12.0,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Flexible(
                  child: Text(
                    '$text',
                    maxLines: 1,
                    style: getCustomFont(size: 12.0, color: Colors.white, weight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
