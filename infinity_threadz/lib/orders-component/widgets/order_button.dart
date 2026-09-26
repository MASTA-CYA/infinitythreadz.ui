import 'package:flutter/material.dart';

class OrderButtonWidget extends StatelessWidget {
  final Widget icon;
  final String text;
  final Color? color;
  final bool? isPrimary;
  final VoidCallback onClicked;

  const OrderButtonWidget({
    super.key,
    required this.icon,
    required this.text,
    this.color,
    this.isPrimary = true,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary!
            ? Theme.of(context)
                .elevatedButtonTheme
                .style
                ?.backgroundColor
                ?.resolve({WidgetState.pressed})
            : Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor:   Colors.transparent,
        foregroundColor:
            color ?? (isPrimary! ? Colors.white : Theme.of(context).primaryColor),
        shape: StadiumBorder(
          side: BorderSide(color: color ?? Theme.of(context).primaryColor),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 6,
        ),
      ),
      icon: icon,
      label: Container(
        margin: const EdgeInsets.only(top: 6),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Galada',
            fontSize: 18,
          ),
        ),
      ),
      onPressed: onClicked,
    );
  }
}
