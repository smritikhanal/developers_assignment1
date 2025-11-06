import 'bank_account.dart';

class StudentAccount extends BankAccount {
  static const double _maxBalance = 5000.0;

  StudentAccount(
    String accountNumber,
    String accountHolderName,
    double initialBalance,
  ) : super(accountNumber, accountHolderName, initialBalance) {
    if (initialBalance > _maxBalance) {
      throw ArgumentError(
        'Initial balance for StudentAccount cannot exceed \$$_maxBalance',
      );
    }
  }

  @override
  void deposit(double amount) {
    if (amount <= 0) throw ArgumentError('Deposit amount must be positive');
    if (balance + amount > _maxBalance) {
      throw StateError(
        'Deposit would exceed maximum balance of \$$_maxBalance',
      );
    }
    balance = balance + amount;
    recordTransaction('deposit', amount, 'Deposit to student account');
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) throw ArgumentError('Withdrawal amount must be positive');
    if (amount > balance) throw StateError('Insufficient funds');
    balance = balance - amount;
    recordTransaction('withdraw', amount, 'Withdrawal from student account');
  }
}
