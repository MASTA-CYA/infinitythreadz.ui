import 'package:flutter/material.dart';
import 'package:infinity_threadz/wallet-component/models/account_card_model.dart';

class AccountCardWidget extends StatelessWidget {
  final AccountCard card;
  final bool isSelected;
  final Function(AccountCard card) onCardSelected;

  const AccountCardWidget({
    super.key,
    required this.card,
    required this.isSelected,
    required this.onCardSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 200, minWidth: 300),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        height: 50,
                        width: 300,
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          card.type.name,
                          style:
                              Theme.of(context).textTheme.displaySmall?.merge(
                                    TextStyle(
                                        fontFamily: 'Galada',
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      card.name,
                      style: Theme.of(context).textTheme.titleLarge?.merge(
                            const TextStyle(fontFamily: 'Galada'),
                          ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      card.number.replaceAll(RegExp(' '), '\t\t\t\t'),
                      style: Theme.of(context).textTheme.titleLarge?.merge(
                            const TextStyle(fontFamily: 'Galada'),
                          ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      'Expires: ${card.expiry}',
                      style: Theme.of(context).textTheme.titleLarge?.merge(
                            const TextStyle(fontFamily: 'Galada'),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      onTap: () => onCardSelected(card),
    );
  }
}
