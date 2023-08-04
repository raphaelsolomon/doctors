import 'package:doctor/constant/strings.dart';
import 'package:doctor/person/user.dart';
import 'package:doctor/providers/page_controller.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyBlogPage extends StatefulWidget {
  const MyBlogPage({Key? key}) : super(key: key);

  @override
  State<MyBlogPage> createState() => _MyBlogPageState();
}

class _MyBlogPageState extends State<MyBlogPage> {
  late WebViewController controller;
  final box = Hive.box<User>(BoxName);

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      //..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://gettheskydoctors.com/')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://doccure-html.dreamguystech.com/template/doctor-blog.html'), headers: {"Authorization": "Bearer ${box.get(USERPATH)!.token}"});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color(0xFFf6f6f6),
          child: Column(children: [
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
                    Flexible(
                      child: Text('My Blog', style: getCustomFont(size: 16.0, color: Colors.white)),
                    ),
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
            const SizedBox(
              height: 15.0,
            ),
            Expanded(
                flex: 1,
                child: WebViewWidget(
                  controller: controller,
                ))
          ])),
    );
  }
}
