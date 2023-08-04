import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:doctor/constant/strings.dart';
import 'package:doctor/model/doctor.model.dart';
import 'package:doctor/model/login.model.dart';
import 'package:doctor/model/state.model.dart';
import 'package:doctor/person/user.dart';
import 'package:doctor/providers/page_controller.dart';
import 'package:doctor/services/request.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:provider/provider.dart';
import 'package:doctor/dialog/subscribe.dart' as popupMessage;

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final box = Hive.box<User>(BoxName);
  late PhoneController phone_controller = PhoneController(null);
  late User user;
  bool isImage = false;
  var selectedDate = DateTime.now();
  String index = 'Basic Info';
  String pricing = 'Free';
  List regList = [];
  Uint8List? encodeedImage;
  String fetchOnlineImage = '';
  String fetchOnlineDocument = '';
  StateCityModel? stateCityModel;
  List<String> headers = ['Basic Info', 'About Me', 'Hospital/Clinic Info', 'Contact Details', 'Education & Experience', 'Awards & Memberships'];

  //============================Basic information =================
  bool isBasicInfoLoading = false;
  final lastname = TextEditingController();
  final firstname = TextEditingController();
  final mobile_number = TextEditingController();
  final email = TextEditingController();
  String gender = 'Male';
  DateTime dob = DateTime.now();
  //============================About Me=================
  bool isAboutMeLoading = false;
  final aboutMeController = TextEditingController();

  //============================Clinic Info =================
  bool isClinicInfoLoading = false;
  final clinicName = TextEditingController();
  final clinicPhoneNumber = PhoneController(null);
  final clinicAddress = TextEditingController();
  List<String> imagesClinic = [];

  //============================ Education Information & Experience=================
  bool isEducationInfoLoading = false;
  List<Map<String, dynamic>> educationControllers = [
    {'degree': TextEditingController(), 'year': DateTime.now(), 'college': TextEditingController()}
  ];

  bool isExperienceInfoLoading = false;
  List<Map<String, dynamic>> experienceControllers = [
    {'clinicName': TextEditingController(), 'from': DateTime.now(), 'to': DateTime.now(), 'description': TextEditingController()}
  ];

//=========================Awards ========================
  bool isAwardsInfoLoading = false;
  List<Map<String, dynamic>> awardControllers = [
    {'award': TextEditingController(), 'year': DateTime.now()}
  ];

  //===========================Membership==================
  bool isMembershipInfoLoading = false;
  List<Map<String, dynamic>> membership = [
    {'membership_name': TextEditingController()}
  ];

  //==============================PAge Loading========================
  bool isPageLoading = true;
  StateData? stateData;
  City? city;
  DoctorProfile? doctorProfile;

  @override
  void initState() {
    user = box.get(USERPATH)!;
    getMyProfile()
        .then((value) => setState(() {
              doctorProfile = value;
              firstname.text = user.name!.split(' ')[0];
              lastname.text = user.name!.split(' ').length > 1 ? user.name!.split(' ')[1] : '';
              email.text = doctorProfile!.data.primaryEmail;
              phone_controller = PhoneController(PhoneNumber(isoCode: "NG", nsn: user.phone!));
              gender = doctorProfile!.data.gender == "male" ? 'Male' : 'Female';
              isPageLoading = false;
              aboutMeController.text = doctorProfile!.data.about;
              dob = (doctorProfile!.data.dob);
            }))
        .whenComplete(() async {
      fetchOnlineImage = await networkImageToBase64(doctorProfile!.data.displayPicPath);
      fetchOnlineDocument = await networkImageToBase64(doctorProfile!.data.documentPath);
    });
    super.initState();
  }

  Future<String> networkImageToBase64(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    return base64.encode(bytes);
  }

  Future<StateCityModel> getAllState() async {
    late StateCityModel stateModel;
    try {
      final res = await http.Client().get(Uri.parse('${ROOTAPI}/api/states/3/cities'), headers: {"Authorization": box.get(USERPATH)!.token!});
      if (res.statusCode == 200) {
        stateModel = stateCityModelFromJson(res.body);
      }
    } catch (e) {
      popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, '$e', status: false));
    } finally {
      isPageLoading = false;
    }
    return stateModel;
  }

  Future<DoctorProfile> getMyProfile() async {
    late DoctorProfile doctorProfile;
    try {
      final res = await http.Client().get(Uri.parse('${ROOTAPI}/api/doctors/${box.get(USERPATH)!.doctor!['id']}'), headers: {"Authorization": box.get(USERPATH)!.token!});
      if (res.statusCode == 200) {
        doctorProfile = doctorProfileFromJson(res.body);
      }
    } catch (e) {
      popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, '$e', status: false));
    } finally {
      isPageLoading = false;
    }
    return doctorProfile;
  }

  @override
  void dispose() {
    email.dispose();
    firstname.dispose();
    aboutMeController.dispose();
    phone_controller.dispose();
    lastname.dispose();
    clinicAddress.dispose();
    clinicAddress.dispose();
    clinicPhoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(0xFFf6f6f6),
        child: isPageLoading
            ? Center(child: CircularProgressIndicator.adaptive())
            : Column(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
                  width: MediaQuery.of(context).size.width,
                  color: BLUECOLOR,
                  child: Column(children: [
                    const SizedBox(
                      height: 45.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(onTap: () => context.read<HomeController>().onBackPress(), child: Icon(Icons.arrow_back_ios, size: 18.0, color: Colors.white)),
                        Text('Profile Settings', style: getCustomFont(size: 16.0, color: Colors.white)),
                        Icon(
                          null,
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
                                        : awardAndMemberShip())
                // registration())
              ]));
  }

  Widget _dashList(e) => GestureDetector(
        onTap: () => setState(() => index = e),
        child: Container(
            margin: const EdgeInsets.only(right: 5.0),
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            decoration: BoxDecoration(color: index == e ? BLUECOLOR : Colors.transparent, borderRadius: BorderRadius.circular(50.0)),
            child: Text(
              '$e',
              style: getCustomFont(size: 14.0, color: index == e ? Colors.white : Colors.black, weight: FontWeight.normal),
            )),
      );

  getCardForm(label, hint, {ctl, index, isList = false, items, max = 1, type = TextInputType.text, isReadOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                '$label',
                style: getCustomFont(size: 13.0, color: Colors.black54, weight: FontWeight.normal),
              ),
            ),
            isList && index != 0
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
            color: isReadOnly ? Colors.grey.shade300 : Colors.transparent,
          ),
          child: TextField(
            style: getCustomFont(size: 14.0, color: Colors.black45),
            controller: ctl,
            maxLines: max,
            keyboardType: type,
            readOnly: isReadOnly,
            decoration: InputDecoration(hintText: hint, contentPadding: const EdgeInsets.symmetric(horizontal: 10.0), hintStyle: getCustomFont(size: 14.0, color: Colors.black45), border: OutlineInputBorder(borderSide: BorderSide.none)),
          ),
        ),
      ],
    );
  }

  getRichTextForm(label, hint, height, {ctl}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label',
          style: getCustomFont(size: 13.0, color: Colors.black54, weight: FontWeight.normal),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Container(
          height: height,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey.shade200), color: Colors.transparent),
          child: TextField(
            style: getCustomFont(size: 14.0, color: Colors.black45),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(hintText: hint, contentPadding: const EdgeInsets.symmetric(horizontal: 10.0), hintStyle: getCustomFont(size: 12.0, color: Colors.black45), border: OutlineInputBorder(borderSide: BorderSide.none)),
          ),
        ),
      ],
    );
  }

  getDropDownAssurance(label, hint, context, callBack, List<String> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label',
          style: getCustomFont(size: 13.0, color: Colors.black54, weight: FontWeight.normal),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 45.0,
          decoration: BoxDecoration(color: Colors.transparent, border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8.0)),
          child: FormBuilderDropdown(
            name: 'gender',
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: '$hint',
              hintStyle: getCustomFont(size: 13.0, color: Colors.black45),
              contentPadding: const EdgeInsets.symmetric(horizontal: 9.9, vertical: 5.0),
              border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide.none),
            ),
            onChanged: (value) => callBack(value),
            items: list
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

  getDropDownState(label, hint, context, callBack, List<StateData> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label',
          style: getCustomFont(size: 13.0, color: Colors.black54, weight: FontWeight.normal),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 45.0,
          decoration: BoxDecoration(color: Colors.transparent, border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8.0)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<StateData>(
              hint: Text('$hint', style: getCustomFont(size: 13.0, color: Colors.black45)),
              value: stateData,
              onChanged: (StateData? value) => callBack(value),
              items: list
                  .map((stateData) => DropdownMenuItem<StateData>(
                        value: stateData,
                        child: Text(
                          stateData.name,
                          style: getCustomFont(size: 13.0, color: Colors.black45),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  getDropDownCity(label, hint, context, callBack, List<City> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label',
          style: getCustomFont(size: 13.0, color: Colors.black54, weight: FontWeight.normal),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 45.0,
          decoration: BoxDecoration(color: Colors.transparent, border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8.0)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              hint: Text('$hint', style: getCustomFont(size: 13.0, color: Colors.black45)),
              value: city,
              onChanged: (value) => callBack(value),
              items: list
                  .map((city) => DropdownMenuItem<City>(
                        value: city,
                        child: Text(
                          city.name,
                          style: getCustomFont(size: 13.0, color: Colors.black45),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget getButton(context, callBack, {text = 'Next'}) => GestureDetector(
        onTap: () => callBack(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 45.0,
          decoration: BoxDecoration(color: BLUECOLOR, borderRadius: BorderRadius.circular(50.0)),
          child: Center(
            child: Text(
              'Save',
              style: getCustomFont(size: 14.0, color: Colors.white, weight: FontWeight.normal),
            ),
          ),
        ),
      );

  Widget getDateForm(label, text, callBack) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label',
            style: getCustomFont(size: 13.0, color: Colors.black54, weight: FontWeight.normal),
          ),
          //abr to undo
          const SizedBox(
            height: 5.0,
          ),
          GestureDetector(
            onTap: () async {
              final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(1960, 1), lastDate: DateTime(2101));
              if (picked != null && picked != selectedDate) {
                callBack(picked);
              }
            },
            child: Container(
              height: 45.0,
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey.shade200), color: Colors.transparent),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text('$text', style: getCustomFont(size: 13.0, color: Colors.black45)),
                  )),
                  PhysicalModel(
                    elevation: 10.0,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100.0),
                    shadowColor: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                      child: Icon(
                        Icons.calendar_month,
                        size: 15.0,
                        color: Color(0xFF838383),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );

  //====================page 1=============================
  Widget basicInfo() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
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
                      backgroundImage: NetworkImage(doctorProfile!.data.displayPicPath),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width / 3.4, top: 93.0),
                      child: GestureDetector(
                        onTap: () async {
                          final image = await ImagePicker.platform.getImage(source: ImageSource.gallery);
                          this.isImage = true;
                          encodeedImage = await File(image!.path).readAsBytesSync();
                        },
                        child: Container(
                          decoration: BoxDecoration(color: BLUECOLOR, borderRadius: BorderRadius.circular(100.0)),
                          width: 28.0,
                          height: 28.0,
                          child: Icon(
                            Icons.camera_alt,
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
            getCardForm('First Name', 'John', ctl: firstname, isReadOnly: true),
            const SizedBox(
              height: 15.0,
            ),
            getCardForm('Last Name', 'Doe', ctl: lastname, isReadOnly: true),
            const SizedBox(
              height: 15.0,
            ),
            getPhoneNumberForm(ctl: phone_controller),
            const SizedBox(
              height: 15.0,
            ),
            getCardForm('E-mail Address', 'Johndoe55@gmail.com', ctl: email),
            const SizedBox(
              height: 15.0,
            ),
            getDropDownAssurance('Gender', gender, context, (value) {
              gender = gender;
            }, ['Male', 'Female', 'Rathe not say']),
            const SizedBox(
              height: 15.0,
            ),
            getDateForm('Date of Birth', DateFormat('dd EEEE, MMM, yyyy').format(dob), (date) {
              setState(() {
                dob = date;
              });
            }),
            const SizedBox(
              height: 30.0,
            ),
            isBasicInfoLoading ? SizedBox(width: MediaQuery.of(context).size.width, child: Center(child: CircularProgressIndicator())) : getButton(context, () => updateBasicinformations()),
            const SizedBox(
              height: 10.0,
            ),
          ]),
        ),
      );

  void updateBasicinformations() async {
    setState(() {
      isBasicInfoLoading = true;
    });

    var body = {
      "city_id": DoctorHive.fromJson(box.get(USERPATH)!.doctor!).cityId,
      "state_id": DoctorHive.fromJson(box.get(USERPATH)!.doctor!).stateId,
      "document_type_id": DoctorHive.fromJson(box.get(USERPATH)!.doctor!).documentTypeId,
      'primary_email': '${email.text.trim()}',
      'gender': '${gender}'.toLowerCase(),
      'dob': '${DateFormat('yyyy-MM-dd').format(dob)}',
      "about": DoctorHive.fromJson(box.get(USERPATH)!.doctor!).about,
      "specialization": jsonEncode(DoctorHive.fromJson(box.get(USERPATH)!.doctor!).specialization),
      "display_pic": isImage ? base64.encode(encodeedImage!) : fetchOnlineImage,
      "reg_no": DoctorHive.fromJson(box.get(USERPATH)!.doctor!).regNo,
      "document": fetchOnlineDocument,
      "address": DoctorHive.fromJson(box.get(USERPATH)!.doctor!).address
    };

    try {
      var response = await http.Client().put(Uri.parse('${ROOTNEWURL}/api/doctors/'), body: body, headers: {'Authorization': box.get(USERPATH)!.token!});
      print(response.statusCode);
      if (response.statusCode == 201) {
        final parsed = jsonDecode(response.body);
        popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, '${parsed['message']}', status: true));
      } else {
        popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, '${response.body}', status: false));
      }
    } catch (e) {
      popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, '${e}', status: false));
    } finally {
      getMyProfile().then((value) => setState(() {
            doctorProfile = value;
            firstname.text = user.name!.split(' ')[0];
            lastname.text = user.name!.split(' ').length > 1 ? user.name!.split(' ')[1] : '';
            email.text = doctorProfile!.data.primaryEmail;
            phone_controller = PhoneController(PhoneNumber(isoCode: "NG", nsn: user.phone!));
            gender = doctorProfile!.data.gender == "male" ? 'Male' : 'Female';
            isBasicInfoLoading = false;
            dob = (doctorProfile!.data.dob);
          }));
    }
  }

  getPhoneNumberForm({ctl, label = 'Mobile Number'}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label',
            style: getCustomFont(size: 13.0, color: Colors.black54, weight: FontWeight.normal),
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
            child: PhoneFormField(
              key: Key('phone-field'),
              controller: ctl, // controller & initialValue value
              shouldFormat: true, // default
              defaultCountry: 'NG', // default
              style: getCustomFont(size: 14.0, color: Colors.black45),
              autovalidateMode: AutovalidateMode.disabled,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(0.0),
                  // default to null
                  hintStyle: getCustomFont(size: 15.0, color: Colors.black45),
                  border: OutlineInputBorder(borderSide: BorderSide.none) // default to UnderlineInputBorder(),
                  ),
              validator: null,
              showFlagInInput: true, // default
              flagSize: 15, // default
              autofillHints: [AutofillHints.telephoneNumber], // default to null
              enabled: true, // default
            ),
          ),
        ],
      );

  Widget aboutMe() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'About Me',
                        style: getCustomFont(size: 17.0, color: Colors.black),
                      )),
                  const SizedBox(
                    height: 20.0,
                  ),
                  getRichTextForm('Biography', 'Within 400 character', MediaQuery.of(context).size.height / 1.8, ctl: aboutMeController),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          isAboutMeLoading ? SizedBox(width: MediaQuery.of(context).size.width, child: Center(child: CircularProgressIndicator())) : getButton(context, () => updateAboutMe()),
          const SizedBox(
            height: 20.0,
          ),
        ]),
      );

  void updateAboutMe() async {
    setState(() {
      isAboutMeLoading = true;
    });
    try {
      var response = await http.Client().post(Uri.parse('${ROOTNEWURL}/api/doctors/'), body: {
        'about': '${aboutMeController.text.trim()}',
        "city_id": DoctorHive.fromJson(box.get(USERPATH)!.doctor!).cityId,
        "state_id": DoctorHive.fromJson(box.get(USERPATH)!.doctor!).stateId,
        "document_type_id": DoctorHive.fromJson(box.get(USERPATH)!.doctor!).documentTypeId,
        'primary_email': '${email.text.trim()}',
        'gender': '${gender}'.toLowerCase(),
        'dob': '${DateFormat('yyyy-MM-dd').format(dob)}',
        "specialization": jsonEncode(DoctorHive.fromJson(box.get(USERPATH)!.doctor!).specialization),
        "display_pic": isImage ? base64.encode(encodeedImage!) : fetchOnlineImage,
        "reg_no": DoctorHive.fromJson(box.get(USERPATH)!.doctor!).regNo,
        "document": fetchOnlineDocument,
        "address": DoctorHive.fromJson(box.get(USERPATH)!.doctor!).address
      }, headers: {
        'Authorization': box.get(USERPATH)!.token!
      });

      if (response.statusCode == 201) {
        final parsed = jsonDecode(response.body);
        popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, '${parsed['message']}', status: true));
      } else {
        popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, '${response.body}', status: false));
      }
    } catch (e) {
      popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, '${e}', status: false));
    } finally {
      getMyProfile().then((value) => setState(() {
            doctorProfile = value;
            firstname.text = user.name!.split(' ')[0];
            lastname.text = user.name!.split(' ').length > 1 ? user.name!.split(' ')[1] : '';
            email.text = doctorProfile!.data.primaryEmail;
            phone_controller = PhoneController(PhoneNumber(isoCode: "NG", nsn: user.phone!));
            aboutMeController.text = doctorProfile!.data.about;
            gender = doctorProfile!.data.gender == "male" ? 'Male' : 'Female';
            isAboutMeLoading = false;
            dob = (doctorProfile!.data.dob);
          }));
    }
  }

  Widget clinicInfo() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Clinic Information',
                  style: getCustomFont(size: 17.0, color: Colors.black),
                )),
            const SizedBox(
              height: 20.0,
            ),
            getCardForm('Hospital/Clinic Name', '', ctl: clinicName),
            const SizedBox(
              height: 15.0,
            ),
            getPhoneNumberForm(ctl: clinicPhoneNumber, label: 'Hospital/Clinic Number'),
            const SizedBox(
              height: 15.0,
            ),
            getCardForm('Hospital/Clinic Address', '', max: null, type: TextInputType.multiline, ctl: clinicAddress),
            const SizedBox(
              height: 15.0,
            ),
            Text(
              'Hospital/Clinic images',
              style: getCustomFont(size: 13.0, color: Colors.black54, weight: FontWeight.normal),
            ),
            const SizedBox(
              height: 5.0,
            ),
            GestureDetector(
              onTap: () async {
                var images = await ImagePicker().pickMultiImage(imageQuality: 50, maxWidth: 500.0, maxHeight: 500.0);
                imagesClinic = images.map<String>((e) => e.path).toList();
              },
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(8.0),
                dashPattern: [8, 4],
                strokeCap: StrokeCap.butt,
                color: Colors.black45,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100.0,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: Colors.grey.shade200),
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
            ),
            const SizedBox(
              height: 30.0,
            ),
            isClinicInfoLoading ? SizedBox(width: MediaQuery.of(context).size.width, child: Center(child: CircularProgressIndicator())) : getButton(context, () => updateHospital_Clinic()),
            const SizedBox(
              height: 10.0,
            ),
          ]),
        ),
      );

  void updateHospital_Clinic() async {
    setState(() {
      isClinicInfoLoading = true;
    });
    if (clinicAddress.text.isEmpty) popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, 'Clinic/Hospital Address are required'));
    if (clinicName.text.isEmpty) popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, 'Clinic/Hospital Name are required'));
    if (clinicPhoneNumber.value!.nsn.isEmpty && clinicPhoneNumber.value!.countryCode.isEmpty) popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, 'Clinic/Hospital contact are required'));
    if (imagesClinic.isEmpty) return popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, 'Clinic/Hospital images are required'));

    try {
      final res = await http.Client().post(Uri.parse('${ROOTAPI}/api/doctors/clinic'),
          body: {'name': clinicName.text.trim(), 'address': clinicAddress.text.trim(), 'phone_number': '+${clinicPhoneNumber.value!.countryCode}${clinicPhoneNumber.value!.nsn}', 'clinic_pic_path': 'default.jpg'},
          headers: {"Authorization": box.get(USERPATH)!.token!});
      print(res.statusCode);
      if (res.statusCode == 201) {
        return popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, 'New clinic/hospital record added successfully', status: true));
      }
      return popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, '${jsonDecode(res.body)['message']}'));
    } catch (e) {
      popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, '$e'));
    } finally {
      setState(() {
        isClinicInfoLoading = false;
      });
    }
  }

  Widget addressInfo() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
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
            getDropDownState('State / Province', stateData!.name, context, (StateData s) {
              setState(() {
                stateData = s;
                city = s.cities.first;
              });
            }, stateCityModel!.data),
            const SizedBox(
              height: 15.0,
            ),
            getDropDownCity('City', city!.name, context, (s) {
              setState(() {
                city = s;
              });
            }, stateData!.cities),
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
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
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
                          style: getCustomFont(size: 13.0, color: Colors.black45),
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
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Education',
                  style: getCustomFont(size: 17.0, color: Colors.black),
                )),
            const SizedBox(
              height: 10.0,
            ),
            ...List.generate(educationControllers.length, (i) => getEducationItem(educationControllers[i], i)),
            const SizedBox(
              height: 10.0,
            ),
            GestureDetector(
                onTap: () => setState(() => educationControllers.add({'degree': TextEditingController(), 'year': DateTime.now(), 'college': TextEditingController()})),
                child: Icon(
                  Icons.add_circle_outline,
                  color: BLUECOLOR,
                )),
            const SizedBox(
              height: 50.0,
            ),
            isEducationInfoLoading
                ? SizedBox(width: MediaQuery.of(context).size.width, child: Center(child: CircularProgressIndicator()))
                : getButton(context, () {
                    if (educationControllers.isEmpty) return popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, 'Enter the required Informations', status: false));
                    setState(() {
                      isEducationInfoLoading = true;
                    });
                    Future.forEach(educationControllers, (Map<String, dynamic> element) async {
                      var response = await http.Client().post(Uri.parse('${ROOTNEWURL}/api/doctors/educations'), body: {
                        'degree': '${element['degree'].text.trim()}',
                        'institution': '${element['college'].text.trim()}',
                        'date_of_completion': '${DateFormat('yyyy-MM-dd').format(element['year'])}',
                      }, headers: {
                        'Authorization': '${box.get(USERPATH)!.token}'
                      });
                      if (response.statusCode == 200) {
                        return popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, 'New Education record successfully added...', status: true));
                      } else {
                        return popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, '${response.body}', status: false));
                      }
                    }).whenComplete(() => setState(() => isEducationInfoLoading = false));
                  }),
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
            ...List.generate(experienceControllers.length, (i) => getExperienceItem(experienceControllers[i], i)),
            const SizedBox(
              height: 10.0,
            ),
            GestureDetector(
                onTap: () => setState(() => experienceControllers.add({'clinicName': TextEditingController(), 'from': DateTime.now(), 'to': DateTime.now(), 'description': TextEditingController()})),
                child: Icon(
                  Icons.add_circle_outline,
                  color: BLUECOLOR,
                )),
            const SizedBox(
              height: 30.0,
            ),
            isExperienceInfoLoading
                ? SizedBox(width: MediaQuery.of(context).size.width, child: Center(child: CircularProgressIndicator()))
                : getButton(context, () {
                    if (experienceControllers.isEmpty) return popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, 'Enter the required Informations', status: false));
                    setState(() {
                      isExperienceInfoLoading = true;
                    });
                    Future.forEach(experienceControllers, (Map<String, dynamic> element) async {
                      var response = await http.Client().post(Uri.parse('${ROOTNEWURL}/api/doctors/${box.get(USERPATH)!.uid}/experiences'), body: {
                        'clinic_name': '${element['clinicName'].text.trim()}',
                        'from': '${DateFormat('yyyy-MM-dd').format(element['from'])}',
                        'to': '${DateFormat('yyyy-MM-dd').format(element['to'])}',
                        'designation': '${element['description'].text.trim()}',
                      }, headers: {
                        'Authorization': '${box.get(USERPATH)!.token}'
                      });
                      if (response.statusCode == 200) {
                        return popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, 'New Experience record successfully added...', status: true));
                      } else {
                        return popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, '${response.body}', status: false));
                      }
                    }).whenComplete(() => setState(() => isExperienceInfoLoading = false));
                  }),
            const SizedBox(
              height: 10.0,
            ),
          ]),
        ),
      );

  Widget awardAndMemberShip() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Awards',
                  style: getCustomFont(size: 17.0, color: Colors.black),
                )),
            const SizedBox(
              height: 20.0,
            ),
            ...List.generate(awardControllers.length, (i) => getAwardItem(awardControllers[i], i)),
            const SizedBox(
              height: 10.0,
            ),
            GestureDetector(
                onTap: () => setState(() => awardControllers.add({'award': TextEditingController(), 'year': DateTime.now()})),
                child: Icon(
                  Icons.add_circle_outline,
                  color: BLUECOLOR,
                )),
            const SizedBox(
              height: 50.0,
            ),
            isAwardsInfoLoading
                ? SizedBox(width: MediaQuery.of(context).size.width, child: Center(child: CircularProgressIndicator()))
                : getButton(context, () {
                    if (awardControllers.isEmpty) return popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, 'Enter the required Informations', status: false));
                    setState(() {
                      isAwardsInfoLoading = true;
                    });
                    Future.forEach(awardControllers, (Map<String, dynamic> element) async {
                      var response = await http.Client().post(Uri.parse('${ROOTNEWURL}/api/doctors/awards'), body: {
                        'award_title': '${element['award'].text.trim()}',
                        'date': '${DateFormat('yyyy-MM-dd').format(element['year'])}',
                      }, headers: {
                        'Authorization': '${box.get(USERPATH)!.token}'
                      });
                      if (response.statusCode == 200) {
                        return popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, 'New Award record successfully added...', status: true));
                      } else {
                        return popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, '${response.body}', status: false));
                      }
                    }).whenComplete(() => setState(() => isAwardsInfoLoading = false));
                  }, text: 'Save'),
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
            ...List.generate(membership.length, (i) => getMemberShipItem(membership[i], i)),
            const SizedBox(
              height: 10.0,
            ),
            GestureDetector(
                onTap: () => setState(() => membership.add({'membership_name': TextEditingController()})),
                child: Icon(
                  Icons.add_circle_outline,
                  color: BLUECOLOR,
                )),
            const SizedBox(
              height: 30.0,
            ),
            getButton(context, () {
              if (membership.isEmpty) return popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, 'Enter the required Informations', status: false));
              setState(() {
                isMembershipInfoLoading = true;
              });
              Future.forEach(membership, (Map<String, dynamic> element) async {
                var response = await http.Client().post(Uri.parse('${ROOTNEWURL}/api/doctors/${box.get(USERPATH)!.uid}/memberships'), body: {
                  'membership_name': '${element['membership_name'].text.trim()}',
                }, headers: {
                  'Authorization': '${box.get(USERPATH)!.token}'
                });
                if (response.statusCode == 200) {
                  return popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, 'New Award record successfully added...', status: true));
                } else {
                  return popupMessage.dialogMessage(context, popupMessage.serviceMessage(context, '${response.body}', status: false));
                }
              }).whenComplete(() => setState(() => isMembershipInfoLoading = false));
            }),
            const SizedBox(
              height: 10.0,
            ),
          ]),
        ),
      );

  Widget registration() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
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
            ...List.generate(regList.length, (i) => getRegistrationItem(regList[i], i)),
            const SizedBox(
              height: 10.0,
            ),
            GestureDetector(
                onTap: () => setState(() => regList.add({'registration': TextEditingController(), 'year': TextEditingController()})),
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
  Widget getEducationItem(Map<String, dynamic> e, i) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          getCardForm('Degree', '', ctl: e['degree'], isList: true, items: educationControllers, index: i),
          const SizedBox(
            height: 15.0,
          ),
          getDateForm('From', DateFormat('yyyy').format(e['year']), (date) {
            setState(() {
              e['year'] = date;
            });
          }),
          const SizedBox(
            height: 15.0,
          ),
          getCardForm('College/Institute', '', ctl: e['description']),
          const SizedBox(
            height: 15.0,
          ),
        ],
      );

  Widget getExperienceItem(Map<String, dynamic> e, i) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          getCardForm('Hospital Name', '', ctl: e['name'], isList: true, items: educationControllers, index: i),
          const SizedBox(
            height: 15.0,
          ),
          getDateForm('From', DateFormat('yyyy').format(e['from']), (date) {
            setState(() {
              e['from'] = date;
            });
          }),
          const SizedBox(
            height: 15.0,
          ),
          getDateForm('To', DateFormat('yyyy').format(e['to']), (date) {
            setState(() {
              e['to'] = date;
            });
          }),
          const SizedBox(
            height: 15.0,
          ),
          getCardForm('Job Description', '', ctl: e['description'], max: null, type: TextInputType.multiline),
          const SizedBox(
            height: 15.0,
          ),
        ],
      );

  Widget getAwardItem(Map<String, dynamic> e, i) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          getCardForm('Award', '', ctl: e['award'], isList: true, items: awardControllers, index: i),
          const SizedBox(
            height: 15.0,
          ),
          getDateForm('To', DateFormat('yyyy').format(e['year']), (date) {
            setState(() {
              e['year'] = date;
            });
          }),
          const SizedBox(
            height: 15.0,
          ),
        ],
      );

  Widget getMemberShipItem(e, i) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          getCardForm('Memberships', '', ctl: e['membership'], isList: true, items: membership, index: i),
          const SizedBox(
            height: 15.0,
          ),
        ],
      );

  Widget getRegistrationItem(e, i) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          getCardForm('Registrations', '', ctl: e['registration'], isList: true, items: regList, index: i),
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
