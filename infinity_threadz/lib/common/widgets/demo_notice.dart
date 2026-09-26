import 'package:flutter/material.dart';

/// Tells the user that [feature] needs a backend and is not part of the demo.
void showDemoNotice(BuildContext context, String feature) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text("$feature isn't available in the demo yet."),
      ),
    );
}
