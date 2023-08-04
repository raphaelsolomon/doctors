import 'package:agora_rtm/agora_rtm.dart';
import 'package:doctor/auth/change_password.dart';
import 'package:doctor/auth/profile_settings.dart';
import 'package:doctor/callscreens/pickup/pick_layout.dart';
import 'package:doctor/chat/chat_list.dart';
import 'package:doctor/company/favourite.dart';
import 'package:doctor/company/myoffer.dart';
import 'package:doctor/company/myreferral.dart';
import 'package:doctor/company/notification.dart';
import 'package:doctor/company/notificationsetting.dart';
import 'package:doctor/company/rateus.dart';
import 'package:doctor/company/reviews.dart';
import 'package:doctor/company/shareapp.dart';
import 'package:doctor/company/socialmedia.dart';
import 'package:doctor/company/support.dart';
import 'package:doctor/constant/strings.dart';
import 'package:doctor/dialog/subscribe.dart';
import 'package:doctor/homepage/account.dart';
import 'package:doctor/homepage/appointment.dart';
import 'package:doctor/homepage/invoice.dart';
import 'package:doctor/homepage/my_calendar.dart';
import 'package:doctor/homepage/my_dashboard.dart';
import 'package:doctor/homepage/my_home.dart';
import 'package:doctor/homepage/my_patients.dart';
import 'package:doctor/homepage/my_plan.dart';
import 'package:doctor/homepage/prescription.dart';
import 'package:doctor/homepage/reminder.dart';
import 'package:doctor/homepage/schedule_timing.dart';
import 'package:doctor/homepage/services.dart';
import 'package:doctor/homepage/specialization.dart';
import 'package:doctor/person/user.dart';
import 'package:doctor/providers/msg_log.dart';
import 'package:doctor/providers/page_controller.dart';
import 'package:doctor/resuable/custom_nav.dart';
import 'package:doctor/resuable/form_widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  AgoraRtmClient? _client;
  LogController logController = LogController();
  final scaffold = GlobalKey<ScaffoldState>();
  final box = Hive.box<User>(BoxName);

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      FirebaseMessaging.instance.getToken().then((value) => print(value));
      dialogMessage(context, subscribe(context));
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _client!.logout();
  }

  @override
  Widget build(BuildContext context) {
    print(box.get(USERPATH)!.email);
    final page = context.watch<HomeController>().getPage;
    return KeyboardVisibilityBuilder(
        builder: (context, isVisible) => WillPopScope(
            onWillPop: () => context.read<HomeController>().onBackPress(),
            child: PickupLayout(
                user: box.get('details'),
                scaffold: Scaffold(
                    key: scaffold,
                    drawer: !removeBottom.contains(page) ? navDrawer(context, scaffold) : null,
                    backgroundColor: Colors.white,
                    body: Stack(children: [
                      _pages(page, scaffold),
                      !isVisible && (!removeBottom.contains(page) && !removeBottom1.contains(page))
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: CustomNavBar(
                                context,
                                pageIndex: 0,
                              ))
                          : SizedBox()
                    ])))));
  }

  Widget _pages(page, scaffold) {
    if (page == -24) {
      return Services();
    }
    if (page == -23) {
      return Specialization();
    }
    if (page == -22) {
      return NotificationPage();
    }
    if (page == -20) {
      return MyPatients();
    }
    if (page == -19) {
      return NotificationSettingsPage();
    }
    if (page == -18) {
      return AuthChangePass();
    }
    if (page == -16) {
      return ProfileSettings(); //done
    }
    if (page == -15) {
      return ShareApp();
    }
    if (page == -14) {
      return RateUS();
    }
    if (page == -13) {
      return SupportPage();
    }
    if (page == -12) {
      return MyReferrals();
    }
    if (page == -10) {
      return MyReviews(); //reviews
    }
    if (page == -9) {
      return MyFavourite();
    }
    if (page == -5) {
      return MyInvoicePage();
    }
    if (page == -3) {
      return MyOffer();
    }
    if (page == -2) {
      return SocialMedia(scaffold);
    }
    if (page == -1) {
      return ChatListScreen(scaffold, logController);
    }
    if (page == 6) {
      return MyReminder();
    }
    if (page == 10) {
      return MyAppointment();
    }
    if (page == 7) {
      return Prescription();
    }
    if (page == 8) {
      return Container(); //my profile
    }
    if (page == -6) {
      return AccountPage();
    }
    if (page == 5) {
      return MyCalendar();
    }
    if (page == 3) {
      return MyPlan();
    }
    if (page == 2) {
      return ScheduleTiming();
    }
    if (page == 1) {
      return MyDashBoard(scaffold);
    }
    return HomePage(scaffold);
  }
}
//
//
//
//SELECT commodity, COUNT(*) AS magnitude FROM commodities WHERE userId=8 GROUP BY commodity ORDER BY magnitude DESC//
//SELECT status, COUNT(*) AS magnitude FROM commodities GROUP BY status ORDER BY magnitude DESC LIMIT 2