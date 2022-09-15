import 'package:doctor/constanst/strings.dart';
import 'package:doctor/providers/page_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDashBoard extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffold;
  const MyDashBoard(this.scaffold, {super.key});

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
                          style:
                              getCustomFont(size: 16.0, color: Colors.white)),
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
                height: 10.0,
              ),
            ]),
          ),
        ]));
          
  }
}