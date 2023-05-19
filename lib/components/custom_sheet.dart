import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomSheet {
  static Future<T?> showScrollModalBottomSheet<T>({
    required BuildContext context,
    bool isScrollControlled = true,
    ShapeBorder? shape,
    double heightPercView = 0.95,
    double topMargin = 65.0,
    required Widget child,
  }) {
    final br = BorderRadius.circular(50);
    shape = shape ?? RoundedRectangleBorder(borderRadius: br);
    return showModalBottomSheet<T>(
      isScrollControlled: isScrollControlled,
      context: context,
      backgroundColor: Colors.transparent,
      shape: shape,
      builder: (ctx) {
        return Container(
          height: Get.height * heightPercView,
          decoration: BoxDecoration(
            borderRadius: br,
            color: Colors.transparent,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: child,
            ),
          ),
        );
      },
    );
  }
}
