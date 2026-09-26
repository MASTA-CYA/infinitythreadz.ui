class AccountCard {
  final int id;
  final String number;
  final String name;
  final String expiry;
  final AccountType type;

  const AccountCard({
    required this.id,
    required this.number,
    required this.name,
    required this.expiry,
    required this.type,
  });
}

enum AccountType {
  credit,
  cheque,
  savings,
}

extension AccountTypeExtension on AccountType {
  String get name {
    switch (this) {
      case AccountType.cheque:
        return "Cheque";
      case AccountType.credit:
        return "Credit";
      case AccountType.savings:
        return "Savings";
      default:
        return "Unknown";
    }
  }
}
