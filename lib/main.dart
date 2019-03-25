// Step 7 (Final): Change the app's theme

import 'package:flutter/material.dart';
import 'package:robot/event/event_robot_respone.dart';
import 'package:robot/util/robot_util.dart';
import 'package:robot/model/chat_message.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  var robotUtil = RobotUtil();
  var _messages = List<ChatMessage>();
  TextEditingController _textController = TextEditingController();

  var user_me = "大白";
  var user_other = "小Q";

  initState() {
    super.initState();
    eventBus.on<EventRobotRespone>().listen((event) {
      print("收到event>>" + event.message);
      setState(() {
        _messages.insert(
            0, ChatMessage(user_other, OTHER, TYPE_TEXT, event.message));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('小Q聊天机器人'),
        ),
        body: Column(children: <Widget>[
          Flexible(
              child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder: (_, int index) {
              ChatMessage message = _messages[index];
              if (message.type_message == TYPE_TEXT) {
                if (message.type_user == 1)
                  return _buildChatRight(message.content);
                else
                  return _buildChatLeft(message.content);
              } else if (message.type_message == TYPE_IMG) {
                return _buildChatLeftImg(message.content);
              }
            },
            itemCount: _messages.length,
          )),
          Divider(height: 1.0),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildEditText(),
          )
        ]));
  }

  Widget _buildEditText() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
              child: TextField(
            //输入框
            controller: _textController,
            onSubmitted: _handleSubmitted,
            decoration: InputDecoration.collapsed(hintText: '请输入内容'),
          )),
          GestureDetector(
              onTap: () => _handleSubmitted(_textController.text),
              child: Container(
                //发送按钮
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                padding: const EdgeInsets.only(
                    left: 10.0, top: 6, right: 10, bottom: 6),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Text(
                  "发送",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              )),
        ],
      ),
    );
  }

  _handleSubmitted(String text) {
    if (text.isEmpty) return;
    print(text);
    setState(() {
      _messages.insert(0, ChatMessage(user_me, ME, TYPE_TEXT, text));
    });
    _textController.clear();
    if (text.endsWith("图片")) {
      setState(() {
        _messages.insert(
            0, ChatMessage(user_other, OTHER, TYPE_IMG, robotUtil.getImage(text)));
      });
    } else {
      robotUtil.getText(text);
    }
  }

  //聊天左侧布局
  Widget _buildChatLeft(message) {
    return Container(
      margin: const EdgeInsets.only(left: 5.0, right: 10.0),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, //对齐方式，左上对齐
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://pp.myapp.com/ma_icon/0/icon_42284557_1517984341/96'),
            radius: 20.0,
          ),
          Flexible(
              child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            decoration: BoxDecoration(
              //设置背景
              color: Colors.blue,
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(10.0)),
            ),
          ))
        ],
      ),
    );
  }

  //聊天右侧布局
  Widget _buildChatRight(message) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end, //对齐方式，左上对齐
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Flexible(
              child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              style: TextStyle(fontSize: 14, color: Colors.blue),
            ),
            decoration: BoxDecoration(
              //设置背景
              color: Colors.white,
              borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(10.0)),
            ),
          )),
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=2182894899,3428535748&fm=58&bpow=445&bpoh=605'),
            radius: 20.0,
          ),
        ],
      ),
    );
  }

  //聊天左侧布局
  Widget _buildChatLeftImg(message) {
    return Container(
      margin: const EdgeInsets.only(left: 5.0, right: 10.0),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, //对齐方式，左上对齐
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://pp.myapp.com/ma_icon/0/icon_42284557_1517984341/96'),
            radius: 20.0,
          ),
          Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
            child: Image.network(
              message,
              height: 200,
              width: 150,
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
    );
  }
}
