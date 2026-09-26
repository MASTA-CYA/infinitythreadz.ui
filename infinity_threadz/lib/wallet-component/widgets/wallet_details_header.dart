import 'package:flutter/material.dart';
import 'package:infinity_threadz/common/color_helper.dart' as color_helper;

class WalletDetailsHeaderWidget extends StatelessWidget {
  final String title;
  final Function(String title, bool isExpanded) onSectionExpanded;

  WalletDetailsHeaderWidget({
    super.key,
    required this.title,
    required this.onSectionExpanded,
  });

  final ValueNotifier _isExpanded = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isExpanded,
      builder: (context, isExpanded, child) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          color: Theme.of(context).brightness == Brightness.dark
              ? color_helper.darken(Colors.grey, 85)
              : Colors.grey.withValues(alpha: 0.2),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.merge(
                          const TextStyle(
                            fontFamily: 'Galada',
                          ),
                        ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: GestureDetector(
                    child: isExpanded
                        ? Icon(
                            Icons.arrow_downward,
                            color: Theme.of(context).primaryColor,
                          )
                        : const Icon(Icons.arrow_upward),
                    onTap: () async => onIconExpanded(isExpanded),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> onIconExpanded(bool isExpanded) async {
    _isExpanded.value = !isExpanded;
    onSectionExpanded(title, isExpanded);
  }
}
