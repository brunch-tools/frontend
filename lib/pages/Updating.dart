import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:brunch_tools/main.dart';
import 'package:brunch_tools/utilities/WebSocket.dart';
import 'package:brunch_tools/widgets/AppBarFactory.dart';
import 'package:flutter/material.dart';

typedef BoolCallback = void Function(bool);
typedef UpdateCallback = void Function(bool, String, String);

class Updating extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return UpdatingState();
  }

  static void needsToolkitUpdate(UpdateCallback callback) {
    String ver = "";
    WebSocket.getInfo((str) async {
      if(str == null || str["toolkit_version"] == null) {
        callback(false, "", "");
        return;
      }

      int localVersion = int.parse(str["toolkit_version"].replaceAll(".",""));
      int serverVersion = 0;
      final response = await http.get('https://raw.githubusercontent.com/WesBosch/brunch-toolkit/main/brunch-toolkit');
      for(String s in response.body.split("\n")) {
        if(s.startsWith("TOOLVER=")) {
          ver=s.replaceAll("TOOLVER=\"", "").replaceAll(RegExp(r'"'), "");
          serverVersion=int.parse(s.replaceAll("TOOLVER=\"v", "").replaceAll(RegExp(r'."'), "").replaceAll(".", ""));
        }
      }
      if(str["toolkit_version"] == "NONE") {
        callback(true, "NONE", ver);
        return;
      }
      callback(localVersion < serverVersion, "v"+str["toolkit_version"], ver);
    });
  }

  static void needsFrameworkUpdate(UpdateCallback callback) {
    WebSocket.getInfo((str) async {
      if(str == null || str["framework_version"] == null) {
        callback(false, "", "");
        return;
      }
      if(str["brunch_version"] == "NONE") {
        callback(true, "NONE", "NONE");
        return;
      }
      final response = await http.get('https://api.github.com/repos/sebanc/brunch/releases/latest');
      int localVersion = int.parse(str["brunch_version"].replaceFirst("Brunch r","").replaceFirst(RegExp(r'[0-9][0-9] '),""));
      int serverVersion = int.parse(jsonDecode(response.body)["name"].replaceFirst("Brunch r","").replaceFirst(RegExp(r'[0-9][0-9] stable '),""));
      callback(localVersion < serverVersion, str["brunch_version"], jsonDecode(response.body)["name"]);
    });
  }

  static void needsDaemonUpdate(UpdateCallback callback) {
    WebSocket.getInfo((str) async {
      if(str == null) {
        callback(false, "", "");
        return;
      }
      final response = await http.get('https://api.github.com/repos/brunch-tools/daemon/releases/latest');
      int localVersion = int.parse(str["daemon_version"].replaceAll(".",""));
      int serverVersion = int.parse(jsonDecode(response.body)["name"].replaceFirst("Release v","").replaceAll(".",""));
      callback(localVersion < serverVersion, "v"+str["daemon_version"], jsonDecode(response.body)["name"].replaceFirst("Release ",""));
    });
  }

}

class UpdatingState extends State<Updating> {

  Timer _timer;
  Widget _toShow = Text("Please wait while we check for updates!", overflow: TextOverflow.visible, textAlign: TextAlign.left);
  bool _hasLoaded = false;

  bool _isUpdating = false;
  bool _canUpdateToolkit = false;
  bool _wantsUpdateToolkit = false;
  String _currentToolkitVersion;
  String _toToolkitVersion;
  bool _canUpdateFramework = false;
  bool _wantsUpdateFramework = false;
  String _currentFrameworkVersion;
  String _toFrameworkVersion;
  bool _canUpdateDaemon = false;
  bool _wantsUpdateDaemon = false;
  String _currentDaemonVersion;
  String _toDaemonVersion;

  @override
  void initState() {
    super.initState();
    checkForUpdate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    if(_hasLoaded && !_isUpdating) {
      _toShow = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Checkbox(
                value: _wantsUpdateToolkit,
                onChanged: _canUpdateToolkit?(toVal) {
                  setState(() {
                    _wantsUpdateToolkit=toVal;
                  });
                }:null,
              ),
              Text(_canUpdateToolkit?"Update the Brunch Toolkit to "+_toToolkitVersion+" from "+_currentToolkitVersion:"There are no toolkit updates available, you're on "+_currentToolkitVersion, style: Theme.of(context).textTheme.headline6, overflow: TextOverflow.visible),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: _wantsUpdateFramework,
                onChanged: _canUpdateFramework?(toVal) {
                  setState(() {
                    _wantsUpdateFramework=toVal;
                    _wantsUpdateDaemon=toVal;
                  });
                }:null,
              ),
              Text(_canUpdateFramework?"Update the Brunch Framework to "+_toFrameworkVersion+" from "+_currentFrameworkVersion:"There are no framework updates available,\nyou're on "+_currentFrameworkVersion, style: Theme.of(context).textTheme.headline6, overflow: TextOverflow.visible),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: _wantsUpdateDaemon,
                onChanged: _canUpdateDaemon?(toVal) {
                  if(_wantsUpdateFramework) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You can only disable Daemon updates if you disable framework updates!")));
                  } else {
                    setState(() {
                      _wantsUpdateDaemon=toVal;
                    });
                  }
                }:null,
              ),
              Text(_canUpdateDaemon?"Update the Brunch Tools Daemon to "+_toDaemonVersion+" from "+_currentDaemonVersion:"There are no daemon updates available, you're on "+_currentDaemonVersion, style: Theme.of(context).textTheme.headline6, overflow: TextOverflow.visible),
            ],
          ),
        ],
      );
    }
  }

  void checkForUpdate() async {
    Updating.needsToolkitUpdate((needsTkUpdate, currentTkVersion, newTkVersion) {
      Updating.needsFrameworkUpdate((needsFrUpdate, currentFrVersion, newFrVersion) {
        Updating.needsDaemonUpdate((needsDaUpdate, currentDaVersion, newDaVersion) {
         setState(() {
           _canUpdateToolkit=needsTkUpdate;
           _wantsUpdateToolkit=needsTkUpdate;
           _currentToolkitVersion=currentTkVersion;
           _toToolkitVersion=newTkVersion;

           _canUpdateFramework=needsFrUpdate;
           _wantsUpdateFramework=needsFrUpdate;
           _currentFrameworkVersion=currentFrVersion;
           _toFrameworkVersion=newFrVersion;

           if(needsFrUpdate) {
             _canUpdateDaemon=needsDaUpdate;
             _wantsUpdateDaemon=true;
           } else {
             _canUpdateDaemon=needsDaUpdate;
             _wantsUpdateDaemon=needsDaUpdate;
           }
           _currentDaemonVersion=currentDaVersion;
           _toDaemonVersion=newDaVersion;

           _hasLoaded = true;
         });
        });
      });
    });
  }

  void beginWithToolkit() async {
    _isUpdating=true;
    if(_wantsUpdateToolkit)
      WebSocket.updateToolkit((event) {
        print(event);
        beginWithFramework();
      });
    else
      beginWithFramework();
  }

  void beginWithFramework() async {
    if(_wantsUpdateFramework)
      WebSocket.updateToolkit((event) {
        print(event);
        beginWithDaemon();
      });
    else
      beginWithDaemon();
  }

  void beginWithDaemon() async {
    if(_wantsUpdateDaemon) {
      WebSocket.updateDaemon();
      _timer = Timer.periodic(Duration(seconds: 5), (timer) {
        waitForDaemon();
      });
    } else {
      _isUpdating = false;
      Navigator.of(context).pop();
    }
  }

  void waitForDaemon() async {
    if(!Register.daemonUpdateComplete)
      return;
    WebSocket.getInfo((str) {
      if(str == null)
        return;
      _timer.cancel();
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.getBar(context, "Update Center", "Manage Brunch Components From Here!"),
      body: AppBarFactory.getPagePadding(
        Center(
          child: GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width<995?1:2,
            childAspectRatio: MediaQuery.of(context).size.width<995?3:2,
            shrinkWrap: true,
            children: [
              Container(
                child: Image(image: AssetImage("assets/images/alert-illustration_2x 1.png")),
              ),
              Align(
                child: _toShow,
                alignment: MediaQuery.of(context).size.width<995?Alignment.topCenter:Alignment.centerLeft,
              ),
            ],
          )
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        currentIndex: 1,
        onTap: (i) => {
          if(_isUpdating) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You can't leave while updating!"),)),
          } else {
            if(i==0) {
              Navigator.of(context).pop(),
            } else {
              setState(() {
                _toShow = Text("The daemon has automatically began to update, this should only take a few minutes.\n\nSit back and relax, you'll be taken back to your previous screen when a connection is available.", overflow: TextOverflow.visible, textAlign: TextAlign.left, style: Theme.of(context).textTheme.headline5);
                beginWithToolkit();
              }),
            }
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.cancel_outlined),
              tooltip: "Head to the Home Page, no update conducted!",
              label: "Cancel"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.arrow_forward),
              tooltip: "Begin Updating Your Brunch Installation",
              label: "Update"
          ),
        ],
      ),
    );
  }


}
