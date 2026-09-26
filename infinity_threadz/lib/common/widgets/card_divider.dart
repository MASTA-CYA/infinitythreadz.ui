import 'package:flutter/material.dart';

class CardDividerWidget extends StatelessWidget {
  final Color color;
  const CardDividerWidget({super.key, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color,
      thickness: 2,
      indent: 35,
      endIndent: 35,
    );
  }
}
