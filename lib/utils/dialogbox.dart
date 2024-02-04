import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/rendering.dart';
import 'package:tictactoe/pages/online/logic.dart';

void dialogbox(BuildContext context, String value,String v1,) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.success,
    animType: AnimType.topSlide,
    btnOkText: v1,
    title: value,
    btnOkOnPress: () {
      logic().clearBoard(context);
    },
  )..show();
}
