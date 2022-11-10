import 'package:doctor/constant/strings.dart';
import 'package:doctor/dialog/edit_prescription.dart';
import 'package:doctor/dialog/subscribe.dart';
import 'package:doctor/providers/page_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Prescription extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffold;
  const Prescription(this.scaffold, {Key? key}) : super(key: key);

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
                      GestureDetector(
                          onTap: () => context.read<HomeController>().onBackPress(),
                          child: Icon(Icons.arrow_back_ios,
                              size: 18.0, color: Colors.white)),
                      Text('My Prescriptions',
                          style: getCustomFont(size: 16.0, color: Colors.white)),
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
                    height: 15.0,
                  )
                ]),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 0.0),
                      itemCount: 10,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) => prescriptionItem(context))))
            ])),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                  'Prescription 1',
                  style: getCustomFont(
                      size: 13.0, color: Colors.black, weight: FontWeight.w400),
                )),
                Text(
                  '14 Mar 2022',
                  style: getCustomFont(
                      size: 13.0,
                      color: Colors.black45,
                      weight: FontWeight.w400),
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
                      style: getCustomFont(
                          color: Colors.black,
                          size: 15.0,
                          weight: FontWeight.w400),
                    ),
                    Text(
                      'Dental',
                      style: getCustomFont(
                          color: Colors.black54,
                          size: 12.0,
                          weight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: [
                        getButton(context,
                            () => null,
                            icon: Icons.download,
                            text: 'Download',
                            color: Colors.amberAccent),
                        const SizedBox(
                          width: 10.0,
                        ),
                        getButton(context,
                            () => showRequestSheet(context, EditPrescription(true)),
                            icon: Icons.edit_outlined,
                            text: 'Edit',
                            color: Colors.amberAccent),
                        const SizedBox(
                          width: 10.0,
                        ),
                        getButton(context, () {
                          dialogMessage(context, serviceMessage(context, 'Invoice Deleted....', status: true));
                        },
                            icon: Icons.delete_outline,
                            text: 'Delete',
                            color: Colors.redAccent),
                      ],
                    )
                  ],
                )
              ],
            ),
          ],
        ));
  }

  Widget getButton(context, callBack,
          {text = 'View',
          icon = Icons.remove_red_eye,
          color = Colors.lightBlueAccent}) =>
      GestureDetector(
        onTap: () => callBack(),
        child: Container(
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(50.0)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14.0, vertical: 7.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  size: 14.0,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 2.0,
                ),
                FittedBox(
                  child: Text(
                    '$text',
                    style: getCustomFont(
                        size: 13.0,
                        color: Colors.white,
                        weight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
