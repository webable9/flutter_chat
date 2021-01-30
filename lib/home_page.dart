import 'dart:io';

import 'package:flutter_chat/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<AnimatedListState> _animListKey = GlobalKey<AnimatedListState>();
  TextEditingController _textEditingController = TextEditingController();

  List<String> _chats = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: Text("Chat App"),
            )
          : AppBar(
              title: Text("Chat App"),
            ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              key: _animListKey,
              reverse: true,
              itemBuilder: _buildItem,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Platform.isIOS
                      ? CupertinoTextField(
                          controller: _textEditingController,
                          placeholder: "메세지 입력창",
                          onSubmitted: _handleSubmitted,
                        )
                      : TextField(
                          controller: _textEditingController,
                          decoration: InputDecoration(
                            hintText: "메세지 입력창",
                          ),
                          onSubmitted: _handleSubmitted,
                        ),
                ),
                SizedBox(width: 8.0),
                Platform.isIOS
                    ? CupertinoButton(
                        child: Text("send"),
                        onPressed: () {
                          _handleSubmitted(_textEditingController.text);
                        },
                      )
                    : IconButton(
                        onPressed: () {
                          _handleSubmitted(_textEditingController.text);
                        },
                        icon: Icon(Icons.send),
                        color: Colors.amberAccent,
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(context, index, animation) {
    return ChatMessage(_chats[index], animation: animation);
  }

  void _handleSubmitted(String text) {
    Logger().d(text);
    _textEditingController.clear();
    _chats.insert(0, text);
    _animListKey.currentState.insertItem(0);
  }
}
