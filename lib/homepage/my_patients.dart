import 'package:doctor/constanst/strings.dart';
import 'package:doctor/providers/page_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';

class MyPatients extends StatelessWidget {
  const MyPatients({super.key});

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
                 
                  Text('My Patients',
                      style:
                          getCustomFont(size: 16.0, color: Colors.white)),
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
            padding: const EdgeInsets.only(
                left: 10.0, right: 8.0, top: 15.0, bottom: 15.0),
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
                        style: getCustomFont(
                            size: 18.0,
                            color: Colors.black,
                            weight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 1.0,
                      ),
                      Text(
                        '125 patients',
                        style: getCustomFont(
                            size: 13.0,
                            color: Colors.black45,
                            weight: FontWeight.w400),
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
                        ...List.generate(2, (index) => patientItem(context)),
                        const SizedBox(
                          height: 50.0,
                        )
                      ],
                    ),
                  )))
        ]));
  }

  Widget patientItem(context) => Container(
      padding: const EdgeInsets.all(15.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 5.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
          boxShadow: SHADOW),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Patient ID - PT0025',
                  style: getCustomFont(
                      color: Colors.black54,
                      size: 13.0,
                      weight: FontWeight.w400),
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.location_on, size: 15.0, color: Colors.black),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Flexible(
                      child: Text(
                        'Florida, USA',
                        textAlign: TextAlign.end,
                        style: getCustomFont(
                            color: Colors.black54,
                            size: 13.0,
                            weight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 27.0,
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
                      'Michelle Fairfax',
                      style: getCustomFont(
                          color: Colors.black,
                          size: 17.0,
                          weight: FontWeight.w400),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            '25 Years, Female',
                            style: getCustomFont(
                                color: Colors.black54,
                                size: 13.0,
                                weight: FontWeight.w400),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            'Blood Group - O+',
                            style: getCustomFont(
                                color: Colors.black54,
                                size: 13.0,
                                weight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: [
                       PhysicalModel(
                        elevation: 10.0,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100.0),
                        shadowColor: Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 5.0),
                          child: Icon(
                            Icons.phone,
                            size: 19.0,
                            color: Color(0xFF838383),
                          ),
                        ),
                      ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          '+1 504 368 6874',
                          style: getCustomFont(
                              color: Colors.black54,
                              size: 13.0,
                              weight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
        ],
      ));
}
