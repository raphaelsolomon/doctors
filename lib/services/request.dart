import 'dart:convert';
import 'dart:io';
import 'package:doctor/constanst/strings.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


const String ROOTAPI = 'https://api.gettheskydoctors.com';


class RequestApiServices {
  
  String GOOGLEAPI = 'https://fcm.googleapis.com/fcm/send';

  void sendNotification(token) async {
    final res = await http.post(Uri.parse(GOOGLEAPI), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'key=${FIREBASE_WEB_TOKEN}'
    }, body: {
      'to': token,
      'priority': 'high',
      'notification': jsonEncode({
        'title': 'Notification',
        'body': 'Notification body',
      })
    });
    if (res.statusCode == 200) {}
  }

  static Future<Map<String, dynamic>> loadCurrencies() async {
    String uri = "https://api.apilayer.com/exchangerates_data/latest";
    var response = await http.get(Uri.parse(uri), headers: {
      "Accept": "application/json",
      "apikey": "p4qW5VLnHaRmgJd84qqszBU3j81sXRu8"
    });
    return json.decode(response.body);
  }

  static Future<String> downloadFile(String url, String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$filename';
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
