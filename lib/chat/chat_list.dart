import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_rtm/src/agora_rtm_client.dart';
import 'package:doctor/chat/msg_screen.dart';
import 'package:doctor/constant/strings.dart';
import 'package:doctor/person/user.dart';
import 'package:doctor/providers/msg_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatListScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffold;
  final LogController logController;
  const ChatListScreen(this.scaffold, this.logController, {Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final controller = TextEditingController();
  final box = Hive.box<User>(BoxName);

  @override
  void initState() {
    _signInAgoraChat();
    _initSDK();
    _addChatListener();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    ChatClient.getInstance.chatManager.removeEventHandler(box.get(USERPATH)!.uid!);
    ChatClient.getInstance.logout(true);
    super.dispose();
  }

  void _signInAgoraChat() async {
    try {
      await ChatClient.getInstance.loginWithAgoraToken(box.get(USERPATH)!.uid!, '007eJxTYJjvnzQxRG5TwP0pAbvYX4pVs/H+3rTh7M/3neZzO2/wBXIrMBimGKalGpqYmSUbJpuYpqZYmpmYWKQmW1qmphgmGhgYlD/0T2kIZGSQXHKalZGBlYGRgYkBxGdgAACUch3l');
      print('login succcess, userID: ${box.get(USERPATH)!.uid!}');
    } on ChatError catch (e) {
      print('login failed, code: ${e.code}, desc: ${e.description}');
    }
  }

  void _initSDK() async {
    ChatOptions options = ChatOptions(
      appKey: '71376350#1118140',
      autoLogin: false,
    );
    await ChatClient.getInstance.init(options);
  }

  void _addChatListener() {
    ChatClient.getInstance.chatManager.addEventHandler(box.get(USERPATH)!.uid!, ChatEventHandler(onCmdMessagesReceived: (messages) {}));
  }

  void sendMessage() async {
    if (controller.text.trim().isEmpty) {
      return;
    }

    var message = ChatMessage.createTxtSendMessage(targetId: 'target_ID', content: controller.text);
    if (message.status == MessageStatus.SUCCESS) {
      widget.logController.addLog('send message: ${controller.text}');
    } else if (message.status == MessageStatus.FAIL) {
      widget.logController.addLog('send message failed: ${controller.text}');
    }
    ChatClient.getInstance.chatManager.sendMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: BLUECOLOR,
        child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 16.0),
            width: MediaQuery.of(context).size.width,
            height: 86.0,
            color: BLUECOLOR,
            child: Column(children: [
              const SizedBox(
                height: 25.0,
              ),
              Row(
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        GestureDetector(onTap: () => widget.scaffold.currentState!.openDrawer(), child: Icon(Icons.menu, color: Colors.white)),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text('Chat', style: getCustomFont(size: 18.0, color: Colors.white))
                      ],
                    ),
                  ),
                  Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                  )
                ],
              )
            ]),
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(color: Color(0xFFF6F6F6), borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
            child: Column(children: [
              getSearchForm(ctl: controller),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: users.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0.0),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (ctx, i) => getChatItems(() {
                            Get.to(() => MessageScreen(widget.logController, users[i]));
                          })))
            ]),
          ))
        ]));
  }

  getChatItems(callBack) => GestureDetector(
        onTap: () => callBack(),
        child: Container(
          padding: const EdgeInsets.all(15.0),
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 1.0, blurRadius: 10.0, offset: Offset(0.0, 1.0))], color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundImage: AssetImage('assets/imgs/1.png'),
                backgroundColor: Colors.grey,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Flexible(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Bernadette Carol',
                          style: getCustomFont(size: 19.0, color: Colors.black, weight: FontWeight.w400),
                        ),
                      ),
                      Text(
                        '09:25 AM',
                        style: getCustomFont(size: 12.0, color: Colors.black45, weight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Flexible(
                      child: Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.lightGreen,
                            size: 13.0,
                          ),
                          const SizedBox(
                            width: 4.0,
                          ),
                          Flexible(
                              child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Text(
                              DUMMYTEXT,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getCustomFont(size: 14.0, color: Colors.black45, weight: FontWeight.w400),
                            ),
                          )),
                        ],
                      ),
                    ),
                    CircleAvatar(
                        backgroundColor: Colors.lightGreen,
                        radius: 12.0,
                        child: Text(
                          '1',
                          style: getCustomFont(
                            size: 13.0,
                            color: Colors.white,
                          ),
                        ))
                  ])
                ],
              )),
            ],
          ),
        ),
      );

  getSearchForm({ctl}) => Container(
        height: 45.0,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          border: Border.all(color: const Color(0xFFE8E8E8), width: 1.0),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: 18.0,
              color: Color(0xFF838383),
            ),
            Flexible(
                child: TextFormField(
              controller: ctl,
              keyboardType: TextInputType.text,
              style: getCustomFont(size: 15.0, color: Colors.black45),
              decoration: InputDecoration(
                  hintText: 'Search chats', contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0), hintStyle: getCustomFont(size: 15.0, color: Colors.black45), border: const OutlineInputBorder(borderSide: BorderSide.none)),
            )),
          ],
        ),
      );
}
