import 'dart:convert';

import 'package:brunch_tools/main.dart';
import 'package:brunch_tools/utilities/JsLocalStorage.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/html.dart';

typedef BoolCallback = void Function(bool);
typedef StringCallback = void Function(String);
typedef MapCallback = void Function(Map);

class WebSocket {
  static void getInfo(MapCallback callback) {
    if(JsLocalStorage.get("design-mode") == "true") {
      return callback(jsonDecode('{"daemon_version":"0.1.3","toolkit_version":"1.0.9","brunch_version":"Brunch r20210223","device_type":"Generic Brunchbook"}'));
    }
    var channel = HtmlWebSocketChannel.connect(Uri.parse("ws://127.0.0.1:15744"));
    channel.sink.add("{\"action\":\"get_info\"}");
    channel.stream.listen((event) {
      Map json = jsonDecode(event);
      channel.sink.close();
      callback(json);
    }).onError((error) {
      callback(null);
    });
  }

  static void updateToolkit(StringCallback callback) {
    if(JsLocalStorage.get("design-mode") == "true") {
      return callback(jsonDecode('{"success":"BEGAN UPDATING TOOLKIT"}'));
    }
    var channel = HtmlWebSocketChannel.connect(Uri.parse("ws://127.0.0.1:15744"));
    channel.sink.add("{\"action\":\"update_toolkit\"}");
    channel.stream.listen((event) {
      return callback(event);
    });
  }

  static void updateFramework(StringCallback callback) {
    if(JsLocalStorage.get("design-mode") == "true") {
      return callback(jsonDecode('{"success":"BEGAN UPDATING FRAMEWORK"}'));
    }
    var channel = HtmlWebSocketChannel.connect(Uri.parse("ws://127.0.0.1:15744"));
    channel.sink.add("{\"action\":\"update_framework\"}");
    channel.stream.listen((event) {
      return callback(event);
    });
  }

  static void updateDaemon() {
    if(JsLocalStorage.get("design-mode") == "true") {
      Register.daemonUpdateComplete = true;
    }
    var channel = HtmlWebSocketChannel.connect(Uri.parse("ws://127.0.0.1:15744"));
    channel.sink.add("{\"action\":\"update_daemon\"}");
    channel.stream.listen((event) {
      print(event);
    }).onDone(() {
      Register.daemonUpdateComplete = true;
    });
    Register.daemonUpdateComplete = false;
  }
}