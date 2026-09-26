import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final bool? isPrimary;
  final VoidCallback onClicked;

  const ButtonWidget({
    super.key,
    required this.text,
    this.isPrimary = true,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary!
            ? Theme.of(context)
                .elevatedButtonTheme
                .style
                ?.backgroundColor
                ?.resolve({WidgetState.pressed})
            : Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        foregroundColor:
            isPrimary! ? Colors.white : Theme.of(context).primaryColor,
        shape: StadiumBorder(
          side: BorderSide(color: Theme.of(context).primaryColor),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 12,
        ),
      ),
      onPressed: onClicked,
      child: Container(
        margin: const EdgeInsets.only(top: 3),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Galada',
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
