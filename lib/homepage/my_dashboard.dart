import 'package:doctor/constanst/strings.dart';
import 'package:doctor/providers/page_controller.dart';
import 'package:doctor/resuable/form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDashBoard extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffold;
  const MyDashBoard(this.scaffold, {super.key});

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
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                scaffold.currentState!.openDrawer();
                              },
                              child: Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: 18.0,
                              )),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Text('Dashboard',
                              style: getCustomFont(
                                  size: 16.0, color: Colors.white)),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          context.read<HomeController>().setPage(-22);
                        },
                        child: Icon(
                          Icons.notifications_active,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 60.0,
                  ),
                ]),
              ),
              const SizedBox(
                height: 80.0,
              ),
              Expanded(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: dashWidget(context, progress: 0.6),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        Flexible(
                          child: dashWidget(context,
                              result: 160,
                              text: 'Prescriptions',
                              icon: Icons.medication_liquid,
                              progress: 0.3),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(children: [
                      Flexible(child: appointmentButton(context, 'Today\'s\nAppointment')),
                       Flexible(child: appointmentButton(context, 'Upcoming\nAppointment')),
                    ],),
                  )
                ],
              ))
            ])),
        dashHeader(context),
      ],
    );
  }
}
