import 'package:flutter/material.dart';

class CommonUtils {
  static InputDecoration getInputDecoration(
      BuildContext context, String hintText) {
    return InputDecoration(
      hintText: hintText,
      labelStyle: const TextStyle(color: Colors.black),
      contentPadding:
          const EdgeInsets.only(left: 16.0, top: 12.0, bottom: 12.0),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
          width: 2.0,
        ),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1.0),
      ),
    );
  }

  static void showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
