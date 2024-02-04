import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void showsnackbar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

void copytoclipboard(BuildContext context, String data) {
  Clipboard.setData(ClipboardData(text: data));
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text("Copied to Clipboard")));
}
