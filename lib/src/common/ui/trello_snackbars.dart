import 'package:flutter/material.dart';
import 'package:flutter_snackbar_plus/flutter_snackbar_plus.dart';

void showLoadingSnackBar(BuildContext context, {String text = "Loading..."}) {
  FlutterSnackBar.showTemplated(
    context,
    title: text,
    message: "Please wait...",
    style: FlutterSnackBarStyle(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      radius: BorderRadius.circular(6),
      backgroundColor: Colors.grey[700],
      shadow: BoxShadow(
        color: Colors.black.withOpacity(0.55),
        blurRadius: 32,
        offset: const Offset(0, 12),
        blurStyle: BlurStyle.normal,
        spreadRadius: -10,
      ),
      leadingSpace: 22,
      trailingSpace: 12,
      padding: const EdgeInsets.all(20),
      titleStyle: const TextStyle(fontSize: 20, color: Colors.white),
      messageStyle: TextStyle(
        fontSize: 16,
        color: Colors.white.withOpacity(0.7),
      ),
      titleAlignment: TextAlign.start,
      messageAlignment: TextAlign.start,
      loadingBarColor: Colors.amber,
      loadingBarRailColor: Colors.amber.withOpacity(0.4),
    ),
  );
}

void showSuccessSnackBar(BuildContext context, {String text = "Success"}) {
  FlutterSnackBar.showTemplated(
    context,
    title: text,
    leading: const Icon(
      Icons.check_circle_outline,
      color: Colors.white,
    ),
    style: FlutterSnackBarStyle(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      radius: BorderRadius.circular(6),
      backgroundColor: Colors.green[400],
      shadow: BoxShadow(
        color: Colors.black.withOpacity(0.55),
        blurRadius: 32,
        offset: const Offset(0, 12),
        blurStyle: BlurStyle.normal,
        spreadRadius: -10,
      ),
      leadingSpace: 22,
      trailingSpace: 12,
      padding: const EdgeInsets.all(20),
      titleStyle: const TextStyle(fontSize: 20, color: Colors.white),
      messageStyle: TextStyle(
        fontSize: 16,
        color: Colors.white.withOpacity(0.7),
      ),
      titleAlignment: TextAlign.start,
      messageAlignment: TextAlign.start,
    ),
  );
}

void showErrorSnackBar(BuildContext context, {String text = "Error"}) {
  FlutterSnackBar.showTemplated(
    context,
    title: text,
    message: "Please try again",
    leading: const Icon(
      Icons.error_outline_outlined,
      color: Colors.white,
    ),
    style: FlutterSnackBarStyle(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      radius: BorderRadius.circular(6),
      backgroundColor: Colors.red[400],
      shadow: BoxShadow(
        color: Colors.black.withOpacity(0.55),
        blurRadius: 32,
        offset: const Offset(0, 12),
        blurStyle: BlurStyle.normal,
        spreadRadius: -10,
      ),
      leadingSpace: 22,
      trailingSpace: 12,
      padding: const EdgeInsets.all(20),
      titleStyle: const TextStyle(fontSize: 20, color: Colors.white),
      messageStyle: TextStyle(
        fontSize: 16,
        color: Colors.white.withOpacity(0.7),
      ),
      titleAlignment: TextAlign.start,
      messageAlignment: TextAlign.start,
      loadingBarColor: Colors.amber,
      loadingBarRailColor: Colors.amber.withOpacity(0.4),
    ),
  );
}
