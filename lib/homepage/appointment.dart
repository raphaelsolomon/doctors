import 'package:doctor/constant/strings.dart';
import 'package:doctor/model/appointment.model.dart';
import 'package:doctor/person/user.dart';
import 'package:doctor/providers/page_controller.dart';
import 'package:doctor/services/request.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MyAppointment extends StatefulWidget {
  const MyAppointment({Key? key}) : super(key: key);

  @override
  State<MyAppointment> createState() => _MyAppointmentState();
}

class _MyAppointmentState extends State<MyAppointment> {
  List<String> headers = ['Appointments', 'Prescriptions', 'Medical Records', 'Billing'];
  final box = Hive.box<User>(BoxName);
  late DoctorAppointment doctorAppointmentResult;
  bool isPageLoading = true;

  String index = 'Appointments';

  @override
  void initState() {
    getMyAppointment().then((value) {
      setState(() {
        isPageLoading = false;
        doctorAppointmentResult = value;
      });
    });
    super.initState();
  }

  Future<DoctorAppointment> getMyAppointment() async {
    late DoctorAppointment doctorAppointment;
    final response = await http.Client().get(Uri.parse('${ROOTAPI}/api/doctors/appointments'), headers: {'Authorization': '${box.get(USERPATH)!.token}'});
    if (response.statusCode == 200) {
      doctorAppointment = doctorAppointmentFromJson(response.body);
    }
    return doctorAppointment;
  }

  Future<void> declineAppointment(id, AppointmentDatum data) async {
    setState(() => data.setIsLoading(true));
    final response = await http.Client().get(Uri.parse('${ROOTAPI}/api/appointments/4/decline'), headers: {'Authorization': '${box.get(USERPATH)!.token}'});
    if (response.statusCode == 200) {
      getMyAppointment().then((value) {
        setState(() {
          data.setIsLoading(false);
          doctorAppointmentResult = value;
        });
      });
    }
  }

  Future<void> acceptAppointment(id, AppointmentDatum data) async {
    setState(() => data.setIsLoading(true));
    final response = await http.Client().get(Uri.parse('${ROOTAPI}/api/appointments/4/accept'), headers: {'Authorization': '${box.get(USERPATH)!.token}'});
    if (response.statusCode == 200) {
      getMyAppointment().then((value) {
        setState(() {
          data.setIsLoading(false);
          doctorAppointmentResult = value;
        });
      });
    }
  }

  Future<void> scheduleAppointment(id, AppointmentDatum data) async {
    setState(() => data.setIsLoading(true));
    final response = await http.Client().get(Uri.parse('${ROOTAPI}/api/appointments/4/schedule'), headers: {'Authorization': '${box.get(USERPATH)!.token}'});
    if (response.statusCode == 200) {
      getMyAppointment().then((value) {
        setState(() {
          data.setIsLoading(false);
          doctorAppointmentResult = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Color(0xFFf6f6f6),
      child: Column(
        children: [
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
                      onTap: () => context.read<HomeController>().onBackPress(),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 18.0,
                      )),
                  Text('Appointments', style: getCustomFont(color: Colors.white, size: 16.0)),
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
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(doctorAppointmentResult.data.data.length, (i) => appointmentItem(doctorAppointmentResult.data.data[i])),
                    ),
                  )))
        ],
      ),
    );
  }

  Widget appointmentItem(AppointmentDatum data) {
    return Container(
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Colors.white, boxShadow: SHADOW),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: FittedBox(
                  child: Text(
                    'Booking Date - ${DateFormat('dd MMM yyyy').format(data.bookingDate)}',
                    maxLines: 1,
                    style: getCustomFont(size: 14.0, color: Colors.black, weight: FontWeight.w400),
                  ),
                )),
                Text(
                  '${data.name}',
                  style: getCustomFont(size: 14.0, color: Colors.black45, weight: FontWeight.w400),
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(data.profilePicture ?? '', headers: {'Authorization': '${box.get(USERPATH)!.token}'}),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data.legalname}',
                        style: getCustomFont(color: Colors.black, size: 17.0, weight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        'Appt Date -${DateFormat('dd MMM yyyy hh:mm a').format(data.appointmentDate)}',
                        style: getCustomFont(color: Colors.black54, size: 13.0, weight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        'Meeting Type -${data.meetingType}',
                        style: getCustomFont(color: Colors.black54, size: 13.0, weight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        '\$${data.amount}',
                        style: getCustomFont(color: Colors.black, size: 13.0, weight: FontWeight.w400),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: data.isLoading
                  ? [CircularProgressIndicator()]
                  : data.status == "Pending"
                      ? [
                          getButton(context, () => declineAppointment('id', data), icon: Icons.cancel, text: 'Decline', color: Colors.redAccent),
                          const SizedBox(
                            width: 10.0,
                          ),
                          getButton(context, () => acceptAppointment('id', data), icon: Icons.check, text: 'Confirm', color: Colors.lightGreen),
                          const SizedBox(
                            width: 10.0,
                          ),
                          getButton(context, () => scheduleAppointment('id', data), icon: Icons.sync, text: 'Reschedule', color: Colors.orange),
                        ]
                      : data.status == "declined"
                          ? [Flexible(child: getButton(context, () => null, icon: Icons.cancel, text: 'Decline', color: Colors.grey))]
                          : [Flexible(child: getButton(context, () => null, icon: Icons.check, text: 'Confirm', color: Colors.grey))],
            )
          ],
        ));
  }

  Widget getButton(context, callBack, {text = 'View', icon = Icons.remove_red_eye, color = Colors.lightBlueAccent}) => GestureDetector(
        onTap: () => callBack(),
        child: Container(
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(50.0)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 7.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  size: 14.0,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Text(
                  '$text',
                  maxLines: 1,
                  style: getCustomFont(size: 11.5, color: Colors.white, weight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
      );
}
