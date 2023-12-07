import 'package:flutter/material.dart';

class WebLayout extends StatefulWidget {
  const WebLayout({super.key});

  @override
  State<WebLayout> createState() => _WebLayoutState();
}

class _WebLayoutState extends State<WebLayout> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text("web laayout "),
        ),
      ),
    );
  }
}
