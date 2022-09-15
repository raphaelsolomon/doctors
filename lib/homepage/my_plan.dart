
import 'package:doctor/constanst/strings.dart';
import 'package:doctor/dialog/subscribe.dart';
import 'package:doctor/providers/page_controller.dart';
import 'package:doctor/services/request.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';

class MyPlan extends StatefulWidget {
  const MyPlan({Key? key}) : super(key: key);

  @override
  State<MyPlan> createState() => _MyPlanState();
}

class _MyPlanState extends State<MyPlan> {
  String pricing = 'Free';
  List CONSULT_TYPE = [
    {'title': 'Audio Call', 'icon': Icons.spatial_audio},
    {'title': 'Video Call', 'icon': FontAwesome5.video},
    {'title': 'Chat', 'icon': FontAwesome5.facebook_messenger},
    {'title': 'Physical Visit', 'icon': FontAwesome5.walking}
  ];
  List<String> currencies = [];
  Map curMap = {};
  String shift = 'Morning';
  String bookingClass = 'Standard';
  String type = 'Audio Call';
  String frequency = 'Seconds';
  String fromCurrency = "USD";
  String toCurrency = "NGN";

  @override
  void initState() {
    RequestApiServices.loadCurrencies().then((value) {
      curMap = value['rates'];
      currencies = curMap.keys.map((e) => e as String).toList();
      setState(() {});
      print(currencies);
    });
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
                height: 40.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                      const SizedBox(
                        width: 20.0,
                      ),
                      Text('My Plans',
                          style:
                              getCustomFont(size: 16.0, color: Colors.white)),
                    ],
                  ),
                  Icon(
                    Icons.notifications,
                    color: Colors.white,
                  )
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [pricingServices()]),
            ),
          )
        ]));
  }

  Widget pricingServices() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        padding:
            EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Pricing',
                  style: getCustomFont(size: 17.0, color: Colors.black),
                )),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Flexible(
                    child: Row(
                  children: [
                    Radio(
                        value: pricing == 'Free',
                        groupValue: true,
                        activeColor: BLUECOLOR,
                        onChanged: (b) {
                          setState(() {
                            pricing = 'Free';
                          });
                        }),
                    Text(
                      'Free Plan',
                      style: getCustomFont(size: 12.0, color: Colors.black),
                    )
                  ],
                )),
                Flexible(
                    child: Row(
                  children: [
                    Radio(
                        value: pricing == 'Custom Price (per hour)',
                        groupValue: true,
                        activeColor: BLUECOLOR,
                        onChanged: (b) {
                          setState(() {
                            pricing = 'Custom Price (per hour)';
                          });
                        }),
                    Flexible(
                      child: FittedBox(
                        child: Text(
                          'Custom Price (per hour)',
                          style: getCustomFont(size: 13.0, color: Colors.black),
                        ),
                      ),
                    )
                  ],
                )),
              ],
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Select Consultation Type',
                style: getCustomFont(
                    size: 13.0, color: Colors.black, weight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...CONSULT_TYPE.map((e) => _dashTypeList(e)).toList()
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Select Frquency',
                style: getCustomFont(
                    size: 13.0, color: Colors.black, weight: FontWeight.w500),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...Frquency.map((e) => GestureDetector(
                        onTap: () {
                          setState(() {
                            frequency = e;
                          });
                        },
                        child: Container(
                          width: 120.0,
                          margin:
                              const EdgeInsets.only(right: 15.0, left: 10.0),
                          decoration: BoxDecoration(
                              color: frequency == e ? BLUECOLOR : Colors.white,
                              border: Border.all(
                                  color:
                                      frequency == e ? BLUECOLOR : Colors.black,
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(50.0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(
                                '$e',
                                style: getCustomFont(
                                    size: 13.0,
                                    color: frequency == e
                                        ? Colors.white
                                        : BLUECOLOR),
                              ),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Select Booking Class',
                style: getCustomFont(
                    size: 13.0, color: Colors.black, weight: FontWeight.w500),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...bookClass.map((e) => GestureDetector(
                        onTap: () {
                          setState(() {
                            bookingClass = e;
                          });
                        },
                        child: Container(
                          width: 120.0,
                          margin:
                              const EdgeInsets.only(right: 15.0, left: 10.0),
                          decoration: BoxDecoration(
                              color:
                                  bookingClass == e ? BLUECOLOR : Colors.white,
                              border: Border.all(
                                  color: bookingClass == e
                                      ? BLUECOLOR
                                      : Colors.black,
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(50.0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(
                                '$e',
                                style: getCustomFont(
                                    size: 13.0,
                                    color: bookingClass == e
                                        ? Colors.white
                                        : BLUECOLOR),
                              ),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Select Booking Shift',
                style: getCustomFont(
                    size: 13.0, color: Colors.black, weight: FontWeight.w500),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...consultationShift.map((e) => GestureDetector(
                        onTap: () {
                          setState(() {
                            shift = e;
                          });
                        },
                        child: Container(
                          width: 120.0,
                          margin:
                              const EdgeInsets.only(right: 15.0, left: 10.0),
                          decoration: BoxDecoration(
                              color: shift == e ? BLUECOLOR : Colors.white,
                              border: Border.all(
                                  color: shift == e ? BLUECOLOR : Colors.black,
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(50.0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(
                                '$e',
                                style: getCustomFont(
                                    size: 13.0,
                                    color:
                                        shift == e ? Colors.white : BLUECOLOR),
                              ),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Select Currency',
                style: getCustomFont(
                    size: 13.0, color: Colors.black, weight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Container(
              child: Row(
                children: [
                  _buildDropDownButton(fromCurrency)
                ],
              ),
            ),
             const SizedBox(
              height: 15.0,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                border: Border.all(width: 0.6, color: Colors.black26),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      'Add Services and Specialization',
                      style: getCustomFont(
                          size: 13.0,
                          color: Colors.black,
                          weight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Text(
                      'Services',
                      style: getCustomFont(
                          size: 13.0,
                          color: Colors.black54,
                          weight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      border: Border.all(width: 1.0, color: Colors.black45),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: Wrap(children: [
                            itemContainer(),
                            itemContainer(),
                            itemContainer()
                          ]),
                        ),
                        GestureDetector(
                            child: Icon(
                          Icons.add_circle_outline,
                          color: Colors.green,
                        )),
                        const SizedBox(
                          width: 5.0,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 3.0,
                  ),
                  Text(
                    'Note: press the add button to add new services',
                    style: getCustomFont(
                        size: 12.0,
                        color: Colors.black45,
                        weight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Text(
                      'Specialization',
                      style: getCustomFont(
                          size: 13.0,
                          color: Colors.black54,
                          weight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      border: Border.all(width: 1.0, color: Colors.black45),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: Wrap(children: [
                            itemContainer(),
                            itemContainer(),
                            itemContainer()
                          ]),
                        ),
                        GestureDetector(
                            child: Icon(
                          Icons.add_circle_outline,
                          color: Colors.green,
                        )),
                        const SizedBox(
                          width: 5.0,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 3.0,
                  ),
                  Text(
                    'Note: press the add button to add new services',
                    style: getCustomFont(
                        size: 12.0,
                        color: Colors.black45,
                        weight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            getButton(context, () {}, 'Proceed'),
            const SizedBox(
              height: 80.0,
            ),
          ]),
        ),
      );

  Widget itemContainer() => Container(
        width: 130.0,
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: BLUECOLOR,
          borderRadius: BorderRadius.circular(50.0),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          Flexible(
              child: FittedBox(
                  child: Text(
            'Tooth Cleaning',
            style: getCustomFont(size: 11.0, color: Colors.white),
          ))),
          const SizedBox(
            width: 10.0,
          ),
          Icon(
            Icons.cancel_outlined,
            size: 19.0,
            color: Colors.white,
          )
        ]),
      );

  Widget _dashTypeList(e) => GestureDetector(
        onTap: () => setState(() => type = e['title']),
        child: Container(
            margin: const EdgeInsets.only(right: 5.0),
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            decoration: BoxDecoration(
                color: type == e['title'] ? BLUECOLOR : Colors.transparent,
                borderRadius: BorderRadius.circular(50.0)),
            child: Row(
              children: [
                Icon(
                  e['icon'],
                  color: type == e['title'] ? Colors.white : Colors.black,
                  size: 14.0,
                ),
                const SizedBox(width: 10),
                Text(
                  '${e['title']}',
                  style: getCustomFont(
                      size: 14.0,
                      color: type == e['title'] ? Colors.white : Colors.black,
                      weight: FontWeight.normal),
                ),
              ],
            )),
      );

  _onFromChanged(String value) {
    setState(() {
      fromCurrency = value;
    });
  }

  _onToChanged(String value) {
    setState(() {
      toCurrency = value;
    });
  }

  Widget _buildDropDownButton(String currencyCategory) {
    return Container(
      height: 45.0,
      decoration: BoxDecoration(color: BLUECOLOR.withOpacity(.1)),
      child: Row(
        children: [
          DropdownButton(
            value: currencyCategory,
            items: currencies
                .map((String value) => DropdownMenuItem(
                      value: value,
                      child: Row(
                        children: <Widget>[
                          Text(value),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: (String? value) {
              if (currencyCategory == fromCurrency) {
                _onFromChanged(value!);
              } else {
                _onToChanged(value!);
              }
            },
          ),
        ],
      ),
    );
  }
}
