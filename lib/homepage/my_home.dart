import 'package:doctor/auth/otp.dart';
import 'package:doctor/constant/strings.dart';
import 'package:doctor/model/person/user.dart';
import 'package:doctor/providers/page_controller.dart';
import 'package:doctor/store/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffold;
  const HomePage(this.scaffold, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final box = Hive.box<User>(BoxName);
  User? user;
  bool isImage = true;

  @override
  void initState() {
    user = box.get(USERPATH);
    isImage = user!.profilePhoto == null ? false : true;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height,
      color: Color(0xFFf6f6f6),
      child: Column(
        children: [
          const SizedBox(height: 30.0),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () =>
                              widget.scaffold.currentState!.openDrawer(),
                          child: Icon(Icons.menu, color: Colors.black)),
                      CircleAvatar(
                        backgroundColor: BLUECOLOR.withOpacity(.3),
                        backgroundImage: isImage
                            ? NetworkImage(user!.profilePhoto!)
                            : NetworkImage(
                                'https://img.freepik.com/free-vector/flat-hand-drawn-patient-taking-medical-examination-illustration_23-2148859982.jpg?w=2000'),
                        radius: 20.0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 50.0),
                  child: FittedBox(
                    child: Text(
                      'Welcome, ${user!.name}',
                      style: getCustomFont(
                          size: 26.0,
                          color: Colors.black,
                          weight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 3.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'What would you like to do today?',
                    style: getCustomFont(
                        size: 13.0,
                        color: Colors.black,
                        weight: FontWeight.w400),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                user!.verified!
                    ? const SizedBox()
                    : Column(
                        children: [
                          GestureDetector(
                              onTap: () =>
                                  Get.to(() => AuthOtp(user!.email!, true)),
                              child: mailAlert(context)),
                          const SizedBox(
                            height: 29.0,
                          ),
                        ],
                      ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        ...List.generate(
                            homeItem1.length,
                            (i) => GestureDetector(
                                onTap: () => onClickItem1(i),
                                child: horizontalItem(homeItem1[i])))
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        ...List.generate(homeItem2.length,
                            (i) => horizontalItem(homeItem2[i]))
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        ...List.generate(
                            4, (index) => horizontalSecondItem(context))
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () => context.read<HomeController>().setPage(-23),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'View All Specialization',
                        style: getCustomFont(
                            size: 14.0,
                            color: BLUECOLOR,
                            weight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                viewAllSpecial(),
                viewAllSpecial(),
                viewAllSpecial(),
                const SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () => context.read<HomeController>().setPage(-24),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'View All Services',
                        style: getCustomFont(
                            size: 14.0,
                            color: BLUECOLOR,
                            weight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                viewAllSpecial(),
                viewAllSpecial(),
                viewAllSpecial(),
                const SizedBox(
                  height: 100.0,
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget viewAllSpecial() => Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(children: [
          Flexible(
              fit: FlexFit.tight,
              child: Text(
                'Addiction psychiatrists',
                style: getCustomFont(size: 14.0, color: Colors.black45),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(Icons.arrow_forward_ios,
                size: 18.0, color: Colors.black87),
          )
        ]),
      );

  Widget horizontalItem(homeItem1) => Container(
        width: 150.0,
        height: 200.0,
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.only(right: 10.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/imgs/1.png',
              width: 80.0,
              height: 80.0,
              fit: BoxFit.contain,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              '${homeItem1['title']}',
              textAlign: TextAlign.center,
              style: getCustomFont(
                  size: 15.5, color: Colors.black, weight: FontWeight.w600),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              '${homeItem1['desc']}',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: getCustomFont(
                  size: 12.0, color: Colors.black45, weight: FontWeight.w400),
            ),
            const SizedBox(
              height: 5.0,
            ),
          ],
        ),
      );

  Widget horizontalSecondItem(context) => Container(
        width: MediaQuery.of(context).size.width / 1.4,
        height: 100.0,
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
            color: BLUECOLOR.withOpacity(.5),
            borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          children: [],
        ),
      );

  Widget mailAlert(context) => Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 14.0),
        margin: const EdgeInsets.only(right: 20.0, left: 20.0),
        decoration: BoxDecoration(
            color: Colors.red.withOpacity(.2),
            borderRadius: BorderRadius.circular(10.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/imgs/message.png',
                width: 50.0, height: 50.0, fit: BoxFit.contain),
            const SizedBox(
              width: 15.0,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                      child: Text(
                    'E-mail Verification Pending',
                    style: getCustomFont(
                        size: 18.0,
                        color: Colors.black,
                        weight: FontWeight.bold),
                  )),
                  const SizedBox(height: 1.0),
                  FittedBox(
                      child: Text(
                    'verify your email to link your account',
                    style: getCustomFont(
                        size: 14.0,
                        color: Colors.black54,
                        weight: FontWeight.w400),
                  )),
                ],
              ),
            ),
            const SizedBox(
              width: 30.0,
            ),
            Icon(
              Icons.warning,
              color: Colors.red,
              size: 19.0,
            )
          ],
        ),
      );

  onClickItem1(int i) {
    if (i == 0) {
      return;
    }
    if (i == 1) {
      context.read<HomeController>().isEstore(true);
      Get.to(() => StorePage(0));
      return;
    }
    if (i == 2) {
      return;
    }
    if (i == 3) {
      return;
    }
    if (i == 4) {
      return;
    }
  }

  onClickItem2(int i) {
    if (i == 0) {
      context.read<HomeController>().setPage(-20);
      return;
    }
    if (i == 1) {
      context.read<HomeController>().setPage(7);
      Get.to(() => StorePage(0));
      return;
    }
    if (i == 2) {
      context.read<HomeController>().setPage(2);
      return;
    }
    if (i == 3) {
      context.read<HomeController>().setPage(5);
      return;
    }
    if (i == 4) {
      return;
    }
  }
}
