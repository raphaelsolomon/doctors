import 'dart:convert';

import 'package:doctor/constant/strings.dart';
import 'package:doctor/dialog/subscribe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_picker/flutter_picker.dart';

class EditPrescription extends StatefulWidget {
  final bool isEdit;
  const EditPrescription(this.isEdit, {Key? key}) : super(key: key);

  @override
  State<EditPrescription> createState() => _EditPrescriptionState();
}

class _EditPrescriptionState extends State<EditPrescription> {
  final pillName = TextEditingController();
  final pillNumbers = TextEditingController();
  bool addButtonLoading = false;
  bool isActive = false;
  List days = [];
  String frequency = '';

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
                !widget.isEdit ? 'Add Prescription' :'Edit Prescription',
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
          Expanded(
              child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 25.0,
              ),
              getCardForm('Reminder Name', 'Enter Reminder Name',
                  ctl: pillName),
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  'Select Days',
                  style: getCustomFont(
                      size: 14.0,
                      color: Colors.black45,
                      weight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              getDaysForm(),
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  'Frequency',
                  style: getCustomFont(
                      size: 14.0,
                      color: Colors.black45,
                      weight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              getDropDownAssurance(),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Flexible(
                      child: getCardForm(
                          'Numbers of times', 'Enter Number of times',
                          ctl: pillNumbers))
                ],
              ),
              const SizedBox(
                height: 40.0,
              ),
              addButtonLoading
                  ? Center(child: CircularProgressIndicator(color: BLUECOLOR))
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: getPayButton(context, () => null,
                          !widget.isEdit ? 'Save Prescription' : 'Update Prescription'),
                    ),
              const SizedBox(
                height: 20.0,
              ),
            ]),
          ))
        ],
      ),
    );
  }

  getDropDownAssurance() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      height: 49.0,
      decoration: BoxDecoration(
          color: BLUECOLOR.withOpacity(.1),
          borderRadius: BorderRadius.circular(5.0)),
      child: FormBuilderDropdown(
        name: 'skill',
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 9.9, vertical: 5.0),
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide.none),
        ),
        initialValue: 'Daily',
        onChanged: (value) => frequency = '$value',
        items: [
          'Daily',
          'Bi-Weekly',
          'Weekly',
          'Bi-Monthly',
          'Monthly',
          'Quarterly',
          'Bi-Yearly',
          'Yearly'
        ]
            .map((gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(
                    gender,
                    style: getCustomFont(size: 13.0, color: Colors.black),
                  ),
                ))
            .toList(),
      ),
    );
  }

  getDaysForm() {
    return GestureDetector(
      onTap: () {
        showPickerArray(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Container(
          height: 48.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: BLUECOLOR.withOpacity(.1)),
          child: Row(
            children: [
              const SizedBox(
                width: 10.0,
              ),
              Icon(
                Icons.calendar_month_rounded,
                color: BLUECOLOR,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Flexible(
                  child: Text(
                days.join(', '),
                style: getCustomFont(
                    size: 13.0, color: Colors.black, weight: FontWeight.w500),
              )),
            ],
          ),
        ),
      ),
    );
  }

  showPickerArray(BuildContext context) {
    Picker(
      adapter: PickerDataAdapter<String>(
          pickerdata: JsonDecoder().convert(PickerData2), isArray: true),
      hideHeader: false,
      title: new Text(
        "Select Days",
        style: getCustomFont(size: 18.0, color: Colors.black),
      ),
      textAlign: TextAlign.center,
      textStyle: getCustomFont(size: 14.0, color: Colors.black),
      onConfirm: (Picker picker, List value) {
        isActive = false;
        days = picker.getSelectedValues().where((e) => e != 'Non').toList();
        setState(() {});
      },
      onCancel: () {
        setState(() {
          isActive = false;
        });
      },
    ).showBottomSheet(context);
  }

  getCardForm(label, hint, {ctl}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label',
            style: getCustomFont(
                size: 14.0, color: Colors.black45, weight: FontWeight.w500),
          ),
          const SizedBox(height: 10.0),
          Container(
            height: 48.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: BLUECOLOR.withOpacity(.1)),
            child: TextField(
              controller: ctl,
              style: getCustomFont(size: 14.0, color: Colors.black45),
              maxLines: 1,
              decoration: InputDecoration(
                  hintText: hint,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  hintStyle: getCustomFont(size: 14.0, color: Colors.black45),
                  border: OutlineInputBorder(borderSide: BorderSide.none)),
            ),
          )
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
