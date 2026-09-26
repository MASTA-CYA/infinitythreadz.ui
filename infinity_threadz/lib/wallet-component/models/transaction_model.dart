class AccountTransaction {
  final String date;
  final String time;
  final String reference;
  final double amount;
  final TransactionType type;

  const AccountTransaction({
    required this.date,
    required this.time,
    required this.reference,
    required this.amount,
    required this.type,
  });
}

enum TransactionType {
  debit,
  credit,
}
