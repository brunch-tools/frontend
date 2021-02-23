// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

class JsCommons {

  static bool isStandalone() {
    return js.context.callMethod("isStandalone");
  }

}