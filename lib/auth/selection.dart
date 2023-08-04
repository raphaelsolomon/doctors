import 'package:doctor/auth/login.dart';
import 'package:doctor/auth/stage_two.dart';
import 'package:doctor/constant/strings.dart';
import 'package:doctor/homepage/dashboard.dart';
import 'package:doctor/person/user.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SeledtionPage extends StatefulWidget {
  const SeledtionPage({Key? key}) : super(key: key);

  @override
  State<SeledtionPage> createState() => _SeledtionPageState();
}

class _SeledtionPageState extends State<SeledtionPage> {
  final user = Hive.box<User>(BoxName);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: user.listenable(),
      builder: ((context, value, child) => user.get(USERPATH) == null
          ? const AuthLogin()
          : user.get(USERPATH)!.doctor != null
              ? Dashboard()
              : CompleteRegistration('${user.get(USERPATH)!.token}')),
    );
  }
}
