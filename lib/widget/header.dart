import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  String? title;
  Header({this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.pink.withOpacity(0.5),
      elevation: 0.0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        title!, selectionColor: Colors.green,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
