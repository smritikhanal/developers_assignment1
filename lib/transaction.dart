class Transaction {
  final DateTime timestamp;
  final String type; // deposit, withdraw, fee, interest, transfer
  final double amount;
  final double balanceAfter;
  final String description;

  Transaction({
    required this.timestamp,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    required this.description,
  });

  @override
  String toString() {
    final ts = timestamp.toIso8601String();
    return '[$ts] $type: \$${amount.toStringAsFixed(2)} | Balance: \$${balanceAfter.toStringAsFixed(2)} | $description';
  }
}
