import 'package:doctor/constant/strings.dart';
import 'package:flutter/material.dart';

class EditPrescription extends StatefulWidget {
  const EditPrescription({Key? key}) : super(key: key);

  @override
  State<EditPrescription> createState() => _EditPrescriptionState();
}

class _EditPrescriptionState extends State<EditPrescription> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 1.5,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 9.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10.0,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(
              child: Text(
                'Edit Prescription',
                style: getCustomFont(size: 16.0, color: Colors.black54),
              ),
            ),
            GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.cancel_outlined,
                  size: 20.0,
                  color: Colors.black,
                ))
          ]),
          Divider(),
          const SizedBox(
            height: 10.0,
          ),
          const SizedBox(
            height: 30.0,
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[]),
          ))
        ],
      ),
    );
  }

  Widget getButton(context, callBack) => GestureDetector(
        onTap: () => callBack(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 45.0,
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
          decoration: BoxDecoration(
              color: BLUECOLOR, borderRadius: BorderRadius.circular(50.0)),
          child: Center(
            child: Text(
              'Update',
              style: getCustomFont(
                  size: 14.0, color: Colors.white, weight: FontWeight.normal),
            ),
          ),
        ),
      );
}
