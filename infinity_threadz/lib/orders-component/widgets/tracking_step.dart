import 'package:flutter/material.dart';
import 'package:infinity_threadz/common/widgets/card_divider.dart';

class TrackingStepWidget extends StatelessWidget {
  final String title;
  final String body;
  final Color? color;
  final bool isLastChild;
  final bool isConnectorLeft;
  final String completionTime;

  const TrackingStepWidget({
    super.key,
    required this.color,
    required this.isLastChild,
    required this.title,
    required this.body,
    required this.isConnectorLeft,
    required this.completionTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 100),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(width: 3, color: color!),
              borderRadius: const BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium?.merge(
                        const TextStyle(fontFamily: 'Galada'),
                      ),
                ),
                CardDividerWidget(color: color!),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
        ...buildConnector(context),
      ],
    );
  }

  List<Widget> buildConnector(BuildContext context) {
    List<Widget> widgets = [];

    if (!isLastChild) {
      widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            isConnectorLeft && completionTime.isNotEmpty
                ? Text(
                    completionTime,
                    style: Theme.of(context).textTheme.bodyLarge?.merge(
                          const TextStyle(fontFamily: 'Galada'),
                        ),
                  )
                : const SizedBox.shrink(),
            Container(
              width: 3,
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(30),
                ),
                color: color,
              ),
              child: CardDividerWidget(color: color!),
            ),
            !isConnectorLeft && completionTime.isNotEmpty
                ? Text(
                    completionTime,
                    style: Theme.of(context).textTheme.bodyLarge?.merge(
                          const TextStyle(fontFamily: 'Galada'),
                        ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      );
    } else {
      widgets.add(const SizedBox.shrink());
    }

    return widgets;
  }
}
