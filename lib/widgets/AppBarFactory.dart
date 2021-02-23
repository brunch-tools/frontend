import 'package:flutter/material.dart';

class AppBarFactory {
  static AppBar getBar(BuildContext _context, String _title, String _subtitle) {
    return AppBar(
      title: Padding(
        child: Padding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_title, style: Theme.of(_context).textTheme.headline3, textAlign: TextAlign.left,),
              Text(_subtitle, style: Theme.of(_context).textTheme.headline5, textAlign: TextAlign.left)
            ],
          ),
          padding: EdgeInsets.only(top: 50),
        ),
        padding: EdgeInsets.only(left: 50),
      ),
      toolbarHeight: 150,
      elevation: 0.0,
    );
  }

  static Padding getPagePadding(Widget _child) {
    return Padding(child: _child, padding: EdgeInsets.symmetric(horizontal: 67),);
  }
}