import 'transaction.dart';

abstract class BankAccount {
  String _accountNumber;
  String _accountHolderName;
  double _balance;
  final List<Transaction> _transactions = [];

  BankAccount(this._accountNumber, this._accountHolderName, this._balance);

  // Encapsulation: getters and setters with validation
  String get accountNumber => _accountNumber;

  String get accountHolderName => _accountHolderName;
  set accountHolderName(String name) {
    if (name.isEmpty)
      throw ArgumentError('Account holder name cannot be empty');
    _accountHolderName = name;
  }

  double get balance => _balance;
  // balance setter is protected-ish; allow subclasses or bank to set via deposit/withdraw
  set balance(double value) {
    _balance = value;
  }

  /// Transaction history access
  List<Transaction> get transactionHistory => List.unmodifiable(_transactions);

  /// Record a transaction. Subclasses should call this after updating balance.
  void recordTransaction(String type, double amount, String description) {
    _transactions.add(
      Transaction(
        timestamp: DateTime.now(),
        type: type,
        amount: amount,
        balanceAfter: _balance,
        description: description,
      ),
    );
  }

  // Abstract operations
  void deposit(double amount);
  void withdraw(double amount);

  // Display info
  String displayInfo() {
    return 'Account #$_accountNumber | Holder: $_accountHolderName | Balance: \$${_balance.toStringAsFixed(2)}';
  }

  @override
  String toString() => displayInfo();
}
