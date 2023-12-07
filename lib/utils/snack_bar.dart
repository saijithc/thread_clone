//snakbar

import 'package:flutter/material.dart';

showSnakBar(BuildContext context, String res) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(res),
    ),
  );
}
