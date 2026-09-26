import 'package:flutter/material.dart';
import 'package:infinity_threadz/wallet-component/models/transaction_model.dart';
import 'package:intl/intl.dart';

class AccountTransactionWidget extends StatelessWidget {
  const AccountTransactionWidget({
    super.key,
    required this.transaction,
    required this.formatCurrency,
  });

  final AccountTransaction transaction;
  final NumberFormat formatCurrency;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        transaction.reference,
        style: Theme.of(context).textTheme.titleLarge?.merge(
              const TextStyle(fontWeight: FontWeight.bold),
            ),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 16,
              ),
              const SizedBox(
                width: 6,
              ),
              Container(
                margin: const EdgeInsets.only(top: 5.5),
                child: Text(
                  transaction.date,
                  style: Theme.of(context).textTheme.bodyLarge?.merge(
                        const TextStyle(color: Colors.grey),
                      ),
                ),
              ),
              const SizedBox(width: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.watch_later_outlined,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.5),
                    child: Text(
                      transaction.time,
                      style: Theme.of(context).textTheme.titleMedium?.merge(
                            const TextStyle(color: Colors.grey),
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      trailing: Text(
        formatCurrency.format(transaction.type == TransactionType.debit
            ? (transaction.amount * -1)
            : transaction.amount),
        style: Theme.of(context).textTheme.bodyMedium?.merge(
              TextStyle(
                  color: transaction.type == TransactionType.debit
                      ? Colors.red
                      : Colors.green),
            ),
      ),
    );
  }
}
