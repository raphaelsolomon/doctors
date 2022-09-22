import 'dart:async';

import 'package:doctor/constant/strings.dart';
import 'package:doctor/providers/page_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CompleteRegistration extends StatelessWidget {
  final String token;
  CompleteRegistration(this.token, {Key? key}) : super(key: key);

  final Completer<WebViewController> _controller = Completer<WebViewController>();

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
                  Text('Stage 2 Authentication',
                      style: getCustomFont(size: 16.0, color: Colors.white)),
                  InkWell(
                    onTap: () {
                      context.read<HomeController>().setPage(-22);
                    },
                    child: Icon(
                      Icons.notifications_active,
                      color: Colors.white,
                    ),
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
              child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            gestureNavigationEnabled: true,
            onWebViewCreated: (controller) {
              _controller.complete(controller);
              controller.loadUrl('', headers: {"Authorization": "Bearer $token"});
            },
            onProgress: (int progress) {
              if (progress > 100) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text("WebView is loading (progress : $progress%)")));
              }
            },
            navigationDelegate: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              if (url.contains("dashboard")) {
                Navigator.pop(context);
              }
            }
          ))
        ]));
  }
}
