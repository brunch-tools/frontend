import 'dart:convert';

import 'package:brunch_tools/main.dart';
import 'package:web_socket_channel/html.dart';

typedef BoolCallback = void Function(bool);
typedef StringCallback = void Function(String);
typedef MapCallback = void Function(Map);

class WebSocket {
  static void getInfo(MapCallback callback) {
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
    var channel = HtmlWebSocketChannel.connect(Uri.parse("ws://127.0.0.1:15744"));
    channel.sink.add("{\"action\":\"update_toolkit\"}");
    channel.stream.listen((event) {
      return callback(event);
    });
  }

  static void updateFramework(StringCallback callback) {
    var channel = HtmlWebSocketChannel.connect(Uri.parse("ws://127.0.0.1:15744"));
    channel.sink.add("{\"action\":\"update_framework\"}");
    channel.stream.listen((event) {
      return callback(event);
    });
  }

  static void updateDaemon() {
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