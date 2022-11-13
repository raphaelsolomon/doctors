import 'package:doctor/constant/strings.dart';
import 'package:doctor/providers/page_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:provider/provider.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  var selectedDate = DateTime.now();
  String index = 'Basic Info';
  String pricing = 'Free';
  List education = [];
  List experience = [];
  List award = [];
  List membership = [];
  List regList = [];
  List<String> headers = [
    'Basic Info',
    'About Me',
    'Hospital/Clinic Info',
    'Contact Details',
    'Education & Experience',
    'Awards & Memberships',
    'Registration'
  ];
  
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
                      onTap: () => context.read<HomeController>().onBackPress(),
                      child: Icon(Icons.arrow_back_ios,
                          size: 18.0, color: Colors.white)),
                  Text('Profile Settings',
                      style: getCustomFont(size: 16.0, color: Colors.white)),
                  Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                  )
                ],
              ),
              const SizedBox(
                height: 15.0,
              )
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [...headers.map((e) => _dashList(e)).toList()],
              ),
            ),
          ),
          Expanded(
              child: index == 'Basic Info'
                  ? basicInfo()
                  : index == 'About Me'
                      ? aboutMe()
                      : index == 'Hospital/Clinic Info'
                          ? clinicInfo()
                          : index == 'Contact Details'
                              ? addressInfo()
                                  : index == 'Education & Experience'
                                      ? educationExperience()
                                      : index == 'Awards & Memberships'
                                          ? awardAndMemberShip()
                                          : registration())
        ]));
  }

  Widget _dashList(e) => GestureDetector(
        onTap: () => setState(() => index = e),
        child: Container(
            margin: const EdgeInsets.only(right: 5.0),
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            decoration: BoxDecoration(
                color: index == e ? BLUECOLOR : Colors.transparent,
                borderRadius: BorderRadius.circular(50.0)),
            child: Text(
              '$e',
              style: getCustomFont(
                  size: 14.0,
                  color: index == e ? Colors.white : Colors.black,
                  weight: FontWeight.normal),
            )),
      );

  getCardForm(label, hint, {ctl, index, isList = false, items, max = 1, type = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                '$label',
                style: getCustomFont(
                    size: 13.0,
                    color: Colors.black54,
                    weight: FontWeight.normal),
              ),
            ),
            isList
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        items.removeAt(index);
                      });
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 20.0,
                    ))
                : SizedBox(),
          ],
        ),
        const SizedBox(
          height: 5.0,
        ),
        Container(
          height: 45.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey.shade200),
              color: Colors.transparent),
          child: TextField(
            style: getCustomFont(size: 14.0, color: Colors.black45),
            maxLines: max,
            keyboardType: type,
            decoration: InputDecoration(
                hintText: hint,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                hintStyle: getCustomFont(size: 14.0, color: Colors.black45),
                border: OutlineInputBorder(borderSide: BorderSide.none)),
          ),
        ),
      ],
    );
  }

  getRichTextForm(label, hint, {ctl}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label',
          style: getCustomFont(
              size: 13.0, color: Colors.black54, weight: FontWeight.normal),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Container(
          height: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey.shade200),
              color: Colors.transparent),
          child: TextField(
            style: getCustomFont(size: 14.0, color: Colors.black45),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                hintText: hint,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                hintStyle: getCustomFont(size: 12.0, color: Colors.black45),
                border: OutlineInputBorder(borderSide: BorderSide.none)),
          ),
        ),
      ],
    );
  }

  getDropDownAssurance(label, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label',
          style: getCustomFont(
              size: 13.0, color: Colors.black54, weight: FontWeight.normal),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 45.0,
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(8.0)),
          child: FormBuilderDropdown(
            name: 'gender',
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
            initialValue: 'Male',
            items: ['Male', 'Female', 'Rather Not Say']
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
      ],
    );
  }

  Widget getButton(context, callBack) => GestureDetector(
        onTap: () => callBack(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 45.0,
          decoration: BoxDecoration(
              color: BLUECOLOR, borderRadius: BorderRadius.circular(50.0)),
          child: Center(
            child: Text(
              'Next',
              style: getCustomFont(
                  size: 14.0, color: Colors.white, weight: FontWeight.normal),
            ),
          ),
        ),
      );

  Widget getDateForm(label, text, callBack) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label',
            style: getCustomFont(
                size: 13.0, color: Colors.black54, weight: FontWeight.normal),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Container(
            height: 45.0,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey.shade200),
                color: Colors.transparent),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text('$text',
                      style: getCustomFont(size: 13.0, color: Colors.black45)),
                )),
                GestureDetector(
                  onTap: () => callBack(),
                  child: PhysicalModel(
                    elevation: 10.0,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100.0),
                    shadowColor: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7.0, vertical: 7.0),
                      child: Icon(
                        Icons.calendar_month,
                        size: 15.0,
                        color: Color(0xFF838383),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      );

  //====================page 1=============================
  Widget basicInfo() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Basic Information',
                  style: getCustomFont(size: 17.0, color: Colors.black),
                )),
            const SizedBox(
              height: 20.0,
            ),
            Container(
              width: double.infinity,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 60.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: AssetImage('assets/imgs/1.png'),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width / 3.4,
                          top: 93.0),
                      child: GestureDetector(
                        onTap: () => null,
                        child: Container(
                          decoration: BoxDecoration(
                              color: BLUECOLOR,
                              borderRadius: BorderRadius.circular(100.0)),
                          width: 28.0,
                          height: 28.0,
                          child: Icon(
                            Icons.photo,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            getCardForm('Username', 'JohnDoe98'),
            const SizedBox(
              height: 15.0,
            ),
            getCardForm('Full Name', 'John'),
            const SizedBox(
              height: 15.0,
            ),
            getCardForm('Last Name', 'Doe'),
            const SizedBox(
              height: 15.0,
            ),
            getPhoneNumberForm(ctl: null),
            const SizedBox(
              height: 15.0,
            ),
            getCardForm('E-mail Address', 'Johndoe55@gmail.com'),
            const SizedBox(
              height: 15.0,
            ),
            getDropDownAssurance('Gender', context),
            const SizedBox(
              height: 15.0,
            ),
            getDateForm('Date of Birth',
                DateFormat('dd EEEE, MMM, yyyy').format(selectedDate), () {}),
            const SizedBox(
              height: 30.0,
            ),
            getButton(context, () {}),
            const SizedBox(
              height: 10.0,
            ),
          ]),
        ),
      );

  getPhoneNumberForm({ctl, label: 'Mobile Number'}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label',
            style: getCustomFont(
                size: 13.0, color: Colors.black54, weight: FontWeight.normal),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Container(
            height: 45.0,
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: const Color(0xFFE8E8E8), width: 1.0),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: PhoneFormField(
                    key: Key('phone-field'),
                    controller: ctl, // controller & initialValue value
                    shouldFormat: true, // default
                    defaultCountry: IsoCode.NG, // default
                    style: getCustomFont(size: 14.0, color: Colors.black45),
                    autovalidateMode: AutovalidateMode.disabled,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(0.0),
                        hintText: 'Mobile Number', // default to null
                        hintStyle:
                            getCustomFont(size: 15.0, color: Colors.black45),
                        border: OutlineInputBorder(
                            borderSide: BorderSide
                                .none) // default to UnderlineInputBorder(),
                        ),
                    validator: null,
                    isCountryChipPersistent: false, // default
                    isCountrySelectionEnabled: true, // default
                    countrySelectorNavigator: CountrySelectorNavigator.dialog(),
                    showFlagInInput: true, // default
                    flagSize: 15, // default
                    autofillHints: [
                      AutofillHints.telephoneNumber
                    ], // default to null
                    enabled: true, // default
                  ),
                )),
                PhysicalModel(
                  elevation: 10.0,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100.0),
                  shadowColor: Colors.grey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7.0, vertical: 7.0),
                    child: Icon(
                      Icons.smartphone,
                      size: 15.0,
                      color: Color(0xFF838383),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      );

  Widget aboutMe() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'About Me',
                  style: getCustomFont(size: 17.0, color: Colors.black),
                )),
            const SizedBox(
              height: 20.0,
            ),
            getRichTextForm(
              'Biography',
              'Within 400 character',
            ),
            const SizedBox(
              height: 30.0,
            ),
            getButton(context, () {}),
            const SizedBox(
              height: 10.0,
            ),
          ]),
        ),
      );

  Widget clinicInfo() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Clinic Information',
                  style: getCustomFont(size: 17.0, color: Colors.black),
                )),
            const SizedBox(
              height: 20.0,
            ),
            getCardForm('Hospital/Clinic Name', ''),
            const SizedBox(
              height: 15.0,
            ),
            getPhoneNumberForm(ctl: null, label: 'Hospital/Clinic Number'),
            const SizedBox(
              height: 15.0,
            ),
            getCardForm('Hospital/Clinic Address', '', max: null, type: TextInputType.multiline),
            const SizedBox(
              height: 15.0,
            ),
            Text(
              'Hospital/Clinic images',
              style: getCustomFont(
                  size: 13.0, color: Colors.black54, weight: FontWeight.normal),
            ),
            const SizedBox(
              height: 5.0,
            ),
            DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(8.0),
              dashPattern: [8, 4],
              strokeCap: StrokeCap.butt,
              color: Colors.black45,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 100.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey.shade200),
                child: Center(
                  child: Text('Click her to upload images',
                      style: getCustomFont(
                        size: 13.0,
                        color: Colors.black45,
                        weight: FontWeight.normal,
                      )),
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            getButton(context, () {}),
            const SizedBox(
              height: 10.0,
            ),
          ]),
        ),
      );

  Widget addressInfo() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Doctor Contact Details',
                  style: getCustomFont(size: 17.0, color: Colors.black),
                )),
            const SizedBox(
              height: 30.0,
            ),
            getCardForm('Address 1', 'JohnDoe98', max: null, type: TextInputType.multiline),
            const SizedBox(
              height: 15.0,
            ),
            getCardForm('Address 2', 'John', max: null, type: TextInputType.multiline),
            const SizedBox(
              height: 15.0,
            ),
            getCardForm('Country', 'Doe'),
            const SizedBox(
              height: 15.0,
            ),
            getCardForm('State / Province', ''),
            const SizedBox(
              height: 15.0,
            ),
            getCardForm('City', 'Doe'),
            const SizedBox(
              height: 35.0,
            ),
            getButton(context, () {}),
            const SizedBox(
              height: 10.0,
            ),
          ]),
        ),
      );

  Widget pricingServices() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: SingleChildScrollView(
          child: Column(children: [
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
                        onChanged: (b) {
                          setState(() {
                            pricing = 'Free';
                          });
                        }),
                    Text(
                      'Free',
                      style: getCustomFont(size: 12.0, color: Colors.black45),
                    )
                  ],
                )),
                Flexible(
                    child: Row(
                  children: [
                    Radio(
                        value: pricing == 'Custom Price (per hour)',
                        groupValue: true,
                        onChanged: (b) {
                          setState(() {
                            pricing = 'Custom Price (per hour)';
                          });
                        }),
                    Flexible(
                      child: FittedBox(
                        child: Text(
                          'Custom Price (per hour)',
                          style:
                              getCustomFont(size: 13.0, color: Colors.black45),
                        ),
                      ),
                    )
                  ],
                )),
              ],
            ),
            getCardForm('', ''),
            const SizedBox(
              height: 15.0,
            ),
            getCardForm('Services', ''),
            const SizedBox(
              height: 15.0,
            ),
            getCardForm('Specialization', ''),
            const SizedBox(
              height: 30.0,
            ),
            getButton(context, () {}),
            const SizedBox(
              height: 10.0,
            ),
          ]),
        ),
      );

  Widget educationExperience() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Education',
                      style: getCustomFont(size: 17.0, color: Colors.black),
                    )),
                const SizedBox(
                  height: 10.0,
                ),
                getCardForm('Degree', ''),
                const SizedBox(
                  height: 15.0,
                ),
                getDateForm('Year of Award', DateFormat('dd EEEE, MMM, yyyy').format(selectedDate), () {}),
                const SizedBox(
                  height: 15.0,
                ),
                getCardForm('College/Institute', ''),
                const SizedBox(
                  height: 10.0,
                ),
                ...List.generate(
                    education.length, (i) => getEducationItem(education[i], i)),
                const SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                    onTap: () => setState(() => education.add({
                          'degree': TextEditingController(),
                          'college': TextEditingController(),
                          'year': TextEditingController()
                        })),
                    child: Icon(
                      Icons.add_circle_outline,
                      color: BLUECOLOR,
                    )),
                const SizedBox(
                  height: 20.0,
                ),
                Divider(
                  color: Colors.black87,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Experience',
                      style: getCustomFont(size: 17.0, color: Colors.black),
                    )),
                const SizedBox(
                  height: 10.0,
                ),
                getCardForm('Hospital/Clinic Name', '', ctl: null),
                const SizedBox(
                  height: 15.0,
                ),
                getDateForm('From', DateFormat('dd EEEE, MMM, yyyy').format(selectedDate), () {}),
                const SizedBox(
                  height: 15.0,
                ),
                getDateForm('To', DateFormat('dd EEEE, MMM, yyyy').format(selectedDate), () {}),
                const SizedBox(
                  height: 15.0,
                ),
                getCardForm('Job Description', '', ctl: null, max: null, type: TextInputType.multiline),
                const SizedBox(
                  height: 10.0,
                ),
                ...List.generate(experience.length,
                    (i) => getExperienceItem(experience[i], i)),
                const SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                    onTap: () => setState(() => experience.add({
                          'name': TextEditingController(),
                          'from': TextEditingController(),
                          'to': TextEditingController(),
                          'desc': TextEditingController()
                        })),
                    child: Icon(
                      Icons.add_circle_outline,
                      color: BLUECOLOR,
                    )),
                const SizedBox(
                  height: 30.0,
                ),
                getButton(context, () {}),
                const SizedBox(
                  height: 10.0,
                ),
              ]),
        ),
      );

  Widget awardAndMemberShip() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Awards',
                      style: getCustomFont(size: 17.0, color: Colors.black),
                    )),
                const SizedBox(
                  height: 20.0,
                ),
                getCardForm('Award', ''),
                const SizedBox(
                  height: 15.0,
                ),
                getDateForm('To', DateFormat('dd EEEE, MMM, yyyy').format(selectedDate), () {}),
                const SizedBox(
                  height: 10.0,
                ),
                ...List.generate(
                    award.length, (i) => getAwardItem(award[i], i)),
                const SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                    onTap: () => setState(() => award.add({
                          'award': TextEditingController(),
                          'year': TextEditingController()
                        })),
                    child: Icon(
                      Icons.add_circle_outline,
                      color: BLUECOLOR,
                    )),
                const SizedBox(
                  height: 20.0,
                ),
                Divider(
                  color: Colors.black87,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Memberships',
                      style: getCustomFont(size: 17.0, color: Colors.black),
                    )),
                const SizedBox(
                  height: 20.0,
                ),
                getCardForm('Memberships', '', ctl: null),
                const SizedBox(
                  height: 10.0,
                ),
                ...List.generate(membership.length,
                    (i) => getMemberShipItem(membership[i], i)),
                const SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                    onTap: () => setState(() => membership
                        .add({'membership': TextEditingController()})),
                    child: Icon(
                      Icons.add_circle_outline,
                      color: BLUECOLOR,
                    )),
                const SizedBox(
                  height: 30.0,
                ),
                getButton(context, () {}),
                const SizedBox(
                  height: 10.0,
                ),
              ]),
        ),
      );

  Widget registration() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Awards',
                      style: getCustomFont(size: 17.0, color: Colors.black),
                    )),
                const SizedBox(
                  height: 20.0,
                ),
                getCardForm('Registrations', ''),
                const SizedBox(
                  height: 10.0,
                ),
                getCardForm('Year', ''),
                const SizedBox(
                  height: 10.0,
                ),
                ...List.generate(
                    regList.length, (i) => getRegistrationItem(regList[i], i)),
                const SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                    onTap: () => setState(() => regList.add({
                          'registration': TextEditingController(),
                          'year': TextEditingController()
                        })),
                    child: Icon(
                      Icons.add_circle_outline,
                      color: BLUECOLOR,
                    )),
                const SizedBox(
                  height: 30.0,
                ),
                getButton(context, () {}),
                const SizedBox(
                  height: 10.0,
                ),
              ]),
        ),
      );

  //====================EducationItem======================
  Widget getEducationItem(e, i) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          getCardForm('Degree', '',
              ctl: e['degree'], isList: true, items: education, index: i),
          const SizedBox(
            height: 15.0,
          ),
          getCardForm('Year of Completion', '', ctl: e['college']),
          const SizedBox(
            height: 15.0,
          ),
          getCardForm('College/Institute', '', ctl: e['year']),
          const SizedBox(
            height: 15.0,
          ),
        ],
      );

  Widget getExperienceItem(e, i) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          getCardForm('Hospital Name', '',
              ctl: e['name'], isList: true, items: experience, index: i),
          const SizedBox(
            height: 15.0,
          ),
          getCardForm('From', '', ctl: e['from']),
          const SizedBox(
            height: 15.0,
          ),
          getCardForm('To', '', ctl: e['to']),
          const SizedBox(
            height: 15.0,
          ),
        ],
      );

  Widget getAwardItem(e, i) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          getCardForm('Award', '',
              ctl: e['award'], isList: true, items: award, index: i),
          const SizedBox(
            height: 15.0,
          ),
          getCardForm('Year', '', ctl: e['year']),
          const SizedBox(
            height: 15.0,
          ),
        ],
      );

  Widget getMemberShipItem(e, i) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          getCardForm('Memberships', '',
              ctl: e['membership'], isList: true, items: membership, index: i),
          const SizedBox(
            height: 15.0,
          ),
        ],
      );

  Widget getRegistrationItem(e, i) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          getCardForm('Registrations', '',
              ctl: e['registration'], isList: true, items: regList, index: i),
          const SizedBox(
            height: 15.0,
          ),
          getCardForm('Year', '', ctl: e['year']),
          const SizedBox(
            height: 15.0,
          ),
        ],
      );

  //=======================================================
}
