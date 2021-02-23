// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class JsLocalStorage {

  static Object get(String key) {
    if (html.window.localStorage.containsKey(key))
      return html.window.localStorage[key];
    return null;
  }

  static void set(String key, String value) {
    html.window.localStorage[key] = value;
  }

  static void remove(String key) {
    html.window.localStorage.remove(key);
  }

  static void reset() {
    for(String key in html.window.localStorage.keys) {
      html.window.localStorage.remove(key);
    }
  }

}