import 'dart:convert';

import 'package:brunch_tools/main.dart';
import 'package:web_socket_channel/html.dart';

typedef BoolCallback = void Function(bool);
typedef StringCallback = void Function(String);

class WebSocket {
  static void getDaemonVersion(StringCallback callback) {
    var channel = HtmlWebSocketChannel.connect(Uri.parse("ws://127.0.0.1:15744"));
    channel.sink.add("{\"action\":\"get_info\"}");
    channel.stream.listen((event) {
      Map json = jsonDecode(event);
      channel.sink.close();
      callback(json["daemon_version"]);
    }).onError((error) {
      callback(null);
    });
  }

  static void updateDaemon() {
    var channel = HtmlWebSocketChannel.connect(Uri.parse("ws://127.0.0.1:15744"));
    channel.sink.add("{\"action\":\"update_daemon\"}");
    channel.stream.listen((event) {
      print(event);
    }).onDone(() {
      Register.updateComplete = true;
    });
    Register.updateComplete = false;
  }
}