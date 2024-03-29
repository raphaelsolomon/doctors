import 'package:doctor/constant/strings.dart';
import 'package:doctor/dialog/subscribe.dart';
import 'package:doctor/person/user.dart';
import 'package:doctor/providers/page_controller.dart';
import 'package:doctor/services/request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:doctor/dialog/subscribe.dart' as popupMessage;
import 'package:http/http.dart' as http;

class MyPlan extends StatefulWidget {
  const MyPlan({Key? key}) : super(key: key);

  @override
  State<MyPlan> createState() => _MyPlanState();
}

class _MyPlanState extends State<MyPlan> {
  final currency = TextEditingController();
  final converted = TextEditingController();
  String pricing = 'Free';
  List CONSULT_TYPE = [
    {'title': 'Audio Call', 'icon': Icons.spatial_audio},
    {'title': 'Video Call', 'icon': FontAwesome5.video},
    {'title': 'Chat', 'icon': FontAwesome5.facebook_messenger},
    {'title': 'Physical Visit', 'icon': FontAwesome5.walking}
  ];

  List<String> services = [];
  List<String> specialization = [];
  List<String> currencies = [];
  Map curMap = {};
  String shift = 'Morning';
  Map<String, String> bookingClass = {'name': 'Standard', 'class': 'standard'};
  String type = 'Audio Call';
  String frequency = 'Seconds';
  String fromCurrency = "USD";
  String toCurrency = "NGN";
  String bookingShift = 'morning';
  final box = Hive.box<User>(BoxName);
  bool isPageLoading = false;

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
                      onTap: () {
                        context.read<HomeController>().onBackPress();
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 18.0,
                      )),
                  Text('My Plans', style: getCustomFont(size: 16.0, color: Colors.white)),
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
            child: SingleChildScrollView(
              child: Column(children: [pricingServices()]),
            ),
          )
        ]));
  }

  Widget pricingServices() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                        value: pricing == 'Custom Price',
                        groupValue: true,
                        activeColor: BLUECOLOR,
                        onChanged: (b) {
                          setState(() {
                            pricing = 'Custom Price';
                          });
                        }),
                    Flexible(
                      child: FittedBox(
                        child: Text(
                          'Custom Price',
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
                style: getCustomFont(size: 13.0, color: Colors.black, weight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [...CONSULT_TYPE.map((e) => _dashTypeList(e)).toList()],
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
                style: getCustomFont(size: 13.0, color: Colors.black, weight: FontWeight.w500),
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
                          margin: const EdgeInsets.only(right: 15.0, left: 10.0),
                          decoration: BoxDecoration(color: frequency == e ? BLUECOLOR : Colors.white, border: Border.all(color: frequency == e ? BLUECOLOR : Colors.black, width: 1.0), borderRadius: BorderRadius.circular(50.0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(
                                '$e',
                                style: getCustomFont(size: 13.0, color: frequency == e ? Colors.white : BLUECOLOR),
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
                style: getCustomFont(size: 13.0, color: Colors.black, weight: FontWeight.w500),
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
                          margin: const EdgeInsets.only(right: 15.0, left: 10.0),
                          decoration: BoxDecoration(
                              color: bookingClass['name'] == e['name'] ? BLUECOLOR : Colors.white, border: Border.all(color: bookingClass['name'] == e['name'] ? BLUECOLOR : Colors.black, width: 1.0), borderRadius: BorderRadius.circular(50.0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(
                                '${e['name']}',
                                style: getCustomFont(size: 13.0, color: bookingClass['name'] == e['name'] ? Colors.white : BLUECOLOR),
                              ),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            dropDown(label: 'Booking Shift', text: 'Select Booking Shift'),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Text(
                'Select Currency',
                style: getCustomFont(size: 13.0, color: Colors.black, weight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            _buildDropDownButton(fromCurrency, callBack: (s) {
              var total = double.parse('${curMap[toCurrency]}') * int.parse(s);
              setState(() {
                converted.text = '${total}';
              });
            }),
            const SizedBox(height: 15.0),
            _buildConvert(toCurrency, callBack: (s) {
              var total = double.parse('${curMap[s]}') * int.parse(currency.text.isEmpty ? '0' : currency.text);
              setState(() {
                converted.text = '${total}';
              });
            }),
            const SizedBox(
              height: 25.0,
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
                      style: getCustomFont(size: 13.0, color: Colors.black, weight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Text(
                      'Services',
                      style: getCustomFont(size: 13.0, color: Colors.black54, weight: FontWeight.w500),
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
                          child: Wrap(children: services.map((e) => itemContainer(services, e)).toList()),
                        ),
                        GestureDetector(
                            onTap: () => showServicesDropDown(),
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
                    'Note: press the add button to add new specialization',
                    style: getCustomFont(size: 12.0, color: Colors.black45, weight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 35.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Text(
                      'Specialization',
                      style: getCustomFont(size: 13.0, color: Colors.black54, weight: FontWeight.w500),
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
                          child: Wrap(children: specialization.map((e) => itemContainer(specialization, e)).toList()),
                        ),
                        GestureDetector(
                            onTap: () => showBottomSheet(),
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
                    style: getCustomFont(size: 12.0, color: Colors.black45, weight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            getButton(context, () async {}, 'Save Plan'),
            const SizedBox(
              height: 80.0,
            ),
          ]),
        ),
      );

  Future<void> getAllState() async {
    try {
      final res = await http.Client().post(Uri.parse('${ROOTAPI}/api/doctors/plans'), headers: {
        "Authorization": box.get(USERPATH)!.token!
      }, body: {
        "price_types": pricing == 'Free' ? "free_plan" : 'custom_plan',
        "consultation_type": type == 'Audio Call'
            ? 'audio_call'
            : type == 'Video Call'
                ? 'video_call'
                : type == 'Chat'
                    ? 'chat'
                    : 'physical_vist',
        "frequency": frequency == "Seconds"
            ? 'seconds'
            : frequency == 'Minutes'
                ? 'minutes'
                : 'hours',
        "booking_class": bookingClass['name'],
        "booking_shift": bookingShift,
        "currency": "naira",
        "amount": converted.text,
        "services": services,
        "specializations": specialization
      });
      if (res.statusCode == 200) {
        popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, 'Plan Successfully Added..', status: true));
      }
    } catch (e) {
      popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, '$e', status: false));
    } finally {
      isPageLoading = false;
    }
  }

  Widget itemContainer(List<String> item, e) => Container(
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: BLUECOLOR,
          borderRadius: BorderRadius.circular(50.0),
        ),
        padding: const EdgeInsets.all(6.0),
        child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(
              fit: FlexFit.loose,
              child: Text(
                '$e',
                maxLines: 1,
                style: getCustomFont(size: 12.0, color: Colors.white),
              )),
          GestureDetector(
            onTap: () {
              setState(() {
                int i = item.indexWhere((element) => element == e);
                if (i > 0) {
                  item.removeAt(i);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.cancel_outlined,
                size: 19.0,
                color: Colors.white,
              ),
            ),
          )
        ]),
      );

  Widget _dashTypeList(e) => GestureDetector(
        onTap: () => setState(() => type = e['title']),
        child: Container(
            margin: const EdgeInsets.only(right: 5.0),
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            decoration: BoxDecoration(color: type == e['title'] ? BLUECOLOR : Colors.transparent, borderRadius: BorderRadius.circular(50.0)),
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
                  style: getCustomFont(size: 14.0, color: type == e['title'] ? Colors.white : Colors.black, weight: FontWeight.normal),
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

  Widget _buildDropDownButton(String currencyCategory, {callBack}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 48.0,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: BLUECOLOR.withOpacity(.05)),
      child: Row(
        children: [
          DropdownButton(
            underline: SizedBox(),
            value: currencyCategory,
            items: currencies
                .map((String value) => DropdownMenuItem(
                      value: value,
                      child: Row(
                        children: <Widget>[
                          Text(
                            value,
                            style: getCustomFont(size: 13.0, color: Colors.black45),
                          ),
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
          const SizedBox(
            width: 10.0,
          ),
          Flexible(
              child: TextFormField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: getCustomFont(size: 13.0, color: Colors.black45),
            controller: currency,
            onChanged: (s) => callBack(s),
            decoration: InputDecoration(hintText: 'Enter price', helperStyle: getCustomFont(size: 13.0, color: Colors.black45), contentPadding: const EdgeInsets.symmetric(vertical: 0.0), border: OutlineInputBorder(borderSide: BorderSide.none)),
          ))
        ],
      ),
    );
  }

  Widget _buildConvert(String currencyCategory, {callBack}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 48.0,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: BLUECOLOR.withOpacity(.05)),
      child: Row(
        children: [
          DropdownButton(
            underline: SizedBox(),
            value: currencyCategory,
            items: currencies
                .map((String value) => DropdownMenuItem(
                      value: value,
                      child: Row(
                        children: <Widget>[
                          Text(
                            value,
                            style: getCustomFont(size: 13.0, color: Colors.black45),
                          ),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: (String? value) {
              if (currencyCategory == fromCurrency) {
                _onFromChanged(value!);
              } else {
                _onToChanged(value!);
                callBack(value);
              }
            },
          ),
          const SizedBox(
            width: 10.0,
          ),
          Flexible(
              child: TextFormField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            readOnly: true,
            enabled: false,
            controller: converted,
            style: getCustomFont(size: 13.0, color: Colors.black45),
            decoration: InputDecoration(hintText: '0.00', helperStyle: getCustomFont(size: 13.0, color: Colors.black45), contentPadding: const EdgeInsets.symmetric(vertical: 0.0), border: OutlineInputBorder(borderSide: BorderSide.none)),
          ))
        ],
      ),
    );
  }

  Widget dropDown({list, text, label}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$text',
              style: getCustomFont(size: 13.0, color: Colors.black, weight: FontWeight.w500),
            ),
            const SizedBox(
              height: 7.0,
            ),
            Row(
              children: [
                Flexible(
                  child: Container(
                    height: 45.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: BLUECOLOR.withOpacity(.05),
                    ),
                    margin: const EdgeInsets.only(top: 5.0),
                    child: FormBuilderDropdown(
                      name: 'skill',
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black54,
                      ),
                      decoration: InputDecoration(
                        labelStyle: getCustomFont(size: 13.0, color: Colors.black45),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 9.9, vertical: 5.0),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        if (value == 'Morning') bookingShift = 'morning';
                        if (value == 'Afternoon') bookingShift = 'afternoon';
                        if (value == 'Evening') bookingShift = 'evening';
                        if (value == 'Mid Night') bookingShift = 'night';
                      },
                      items: ['Morning', 'Afternoon', 'Evening', 'Mid Night']
                          .map((gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(
                                  gender,
                                  style: getCustomFont(size: 13.0, color: Colors.black45),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        child: Column(
          children: [
            const SizedBox(
              height: 8.0,
            ),
            Text(
              'Select Specialization',
              style: getCustomFont(size: 28.0, color: Colors.black, weight: FontWeight.w700),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SingleChildScrollView(
                  child: Column(
                      children: List.generate(
                          SpecialitiesFilter.length,
                          (i) => Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (!specialization.contains(SpecialitiesFilter[i])) {
                                          specialization.add(SpecialitiesFilter[i]);
                                        }
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        '${SpecialitiesFilter[i]}',
                                        style: getCustomFont(size: 16.0, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ))),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showServicesDropDown() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        child: Column(
          children: [
            const SizedBox(
              height: 8.0,
            ),
            Text(
              'Select Services',
              style: getCustomFont(size: 28.0, color: Colors.black, weight: FontWeight.w700),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SingleChildScrollView(
                  child: Column(
                      children: List.generate(
                          ServicesList.length,
                          (i) => Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (!services.contains(ServicesList[i])) {
                                          services.add(ServicesList[i]);
                                        }
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        '${ServicesList[i]}',
                                        style: getCustomFont(size: 16.0, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ))),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
