import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:robot/model/robot_message.dart';
import 'package:robot/event/event_robot_respone.dart';

class RobotUtil {
  var url = "https://api.ai.qq.com/fcgi-bin/nlp/nlp_textchat";
  var app_id = "";
  var app_key = "";


  getText(question) {
    var params =
        "app_id=$app_id&nonce_str=fa577ce340859f9fe&question=${Uri.encodeFull(question)}&session=10000&time_stamp=${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
    http
        .post(Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: params + "&sign=" + getSign(params))
        .then((res) {
      RobotMessage robotMessage = RobotMessage(res.body);
      if (robotMessage.ret == 0 &&
          robotMessage.data != null &&
          robotMessage.data.answer.isNotEmpty) {
        eventBus.fire(EventRobotRespone(robotMessage.data.answer));
      } else {
        eventBus.fire(EventRobotRespone("请求失败，请重试"));
      }
    }).catchError((error) {
      print('错误>>$error');
      eventBus.fire(EventRobotRespone("请求失败，请重试"));
    });
  }

  //获取图片
  getImage(question){
    return "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1899334847,671631252&fm=27&gp=0.jpg";
  }

//获取签名
  getSign(params) {
    params += "&app_key=$app_key";
    var sign = md5.convert(utf8.encode(params));
    return sign.toString().toUpperCase();
  }

}
