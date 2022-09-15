import 'package:agora_rtm/agora_rtm.dart';
import 'package:doctor/auth/change_password.dart';
import 'package:doctor/auth/profile_settings.dart';
import 'package:doctor/callscreens/pickup/pick_layout.dart';
import 'package:doctor/chat/chat_list.dart';
import 'package:doctor/company/myoffer.dart';
import 'package:doctor/company/myorder.dart';
import 'package:doctor/company/myreferral.dart';
import 'package:doctor/company/notificationsetting.dart';
import 'package:doctor/company/rateus.dart';
import 'package:doctor/company/reviews.dart';
import 'package:doctor/company/shareapp.dart';
import 'package:doctor/company/socialmedia.dart';
import 'package:doctor/company/support.dart';
import 'package:doctor/constanst/strings.dart';
import 'package:doctor/dialog/subscribe.dart';
import 'package:doctor/homepage/invoice.dart';
import 'package:doctor/homepage/my_calendar.dart';
import 'package:doctor/homepage/prescription.dart';
import 'package:doctor/homepage/reminder.dart';
import 'package:doctor/homepage/schedule_timing.dart';
import 'package:doctor/model/person/user.dart';
import 'package:doctor/providers/msg_log.dart';
import 'package:doctor/providers/page_controller.dart';
import 'package:doctor/resuable/custom_nav.dart';
import 'package:doctor/resuable/form_widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
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
      createClient();
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
    final page = context.watch<HomeController>().getPage;
    return KeyboardVisibilityBuilder(
        builder: (context, isVisible) => WillPopScope(
            onWillPop: () => context.read<HomeController>().onBackPress(),
            child: PickupLayout(
                user: box.get('details'),
                scaffold: Scaffold(
                    key: scaffold,
                    drawer: !removeBottom.contains(page)
                        ? navDrawer(context, scaffold)
                        : null,
                    backgroundColor: Colors.white,
                    body: Stack(children: [
                      _pages(page, scaffold),
                      !isVisible &&
                              (!removeBottom.contains(page) &&
                                  !removeBottom1.contains(page))
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: CustomNavBar(
                                context,
                                pageIndex: 0,
                              ))
                          : SizedBox()
                    ])))));
  }

  void createClient() async {
    _client = await AgoraRtmClient.createInstance(APP_ID);
    _client!.login(null, box.get(USERPATH)!.uid!);
    _client!.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      logController.addLog("Private Message from $peerId: ${message.text}");
    };
    _client!.onConnectionStateChanged = (int state, int reason) {
      if (kDebugMode) {
        print('Connection state changed: $state, reason: $reason');
      }
      if (state == 5) {
        _client!.logout();
        if (kDebugMode) {
          print('Logout.');
        }
      }
    };
  }

  Widget _pages(page, scaffold) {
    if (page == -19) {
      return NotificationSettingsPage();
    }
    if (page == -18) {
      return AuthChangePass();
    }
    if (page == -16) {
      return ProfileSettings(scaffold);
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
      return MyReviews(scaffold); //reviews
    }
    if (page == -9) {
      return MyFavourite(scaffold);
    }
    if (page == -5) {
      return MyInvoicePage(scaffold);
    }
    if (page == -3) {
      return MyOffer();
    }
    if (page == -2) {
      return SocialMedia(scaffold);
    }
    if (page == -1) {
      return ChatListScreen(scaffold, logController, _client);
    }
    if (page == 6) {
      return MyReminder();
    }
    if (page == 7) {
      return Prescription(scaffold);
    }
    if (page == 8) {
      return Container(); //my profile
    }
    if(page == 5) {
      return MyCalendar();
    }
     if(page == 2) {
      return ScheduleTiming(scaffold);
    }
    return Container();
  }
}
