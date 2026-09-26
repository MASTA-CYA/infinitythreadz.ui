import 'package:flutter/material.dart';

class ProfileNumbersWidget extends StatelessWidget {
  const ProfileNumbersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildButton(context, '3', 'Orders'),
        buildDivider(),
        buildButton(context, '1', 'Vouchers'),
        buildDivider(),
        buildButton(context, '515', 'Loyalty Points'),
      ],
    );
  }

  Widget buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 30,
      child: const VerticalDivider(),
    );
  }

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.merge(
                    const TextStyle(fontWeight: FontWeight.bold),
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.merge(
                    const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ),
          ],
        ),
      );
}
