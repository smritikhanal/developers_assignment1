import 'bank_account.dart';
import 'interest_bearing.dart';

class PremiumAccount extends BankAccount implements InterestBearing {
  static const double _minBalance = 10000.0;
  static const double _interestRate = 0.05; // 5%

  PremiumAccount(
    String accountNumber,
    String accountHolderName,
    double initialBalance,
  ) : super(accountNumber, accountHolderName, initialBalance) {
    if (initialBalance < _minBalance) {
      throw ArgumentError(
        'Initial balance for PremiumAccount must be at least \$$_minBalance',
      );
    }
  }

  @override
  void deposit(double amount) {
    if (amount <= 0) throw ArgumentError('Deposit amount must be positive');
    balance = balance + amount;
    recordTransaction('deposit', amount, 'Deposit to premium');
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) throw ArgumentError('Withdrawal amount must be positive');
    if (balance - amount < _minBalance) {
      throw StateError(
        'Cannot withdraw: PremiumAccount must maintain minimum balance of \$$_minBalance',
      );
    }
    balance = balance - amount;
    recordTransaction('withdraw', amount, 'Withdrawal from premium');
  }

  @override
  double calculateInterest() {
    return balance * _interestRate;
  }

  @override
  void applyInterest() {
    final double interest = calculateInterest();
    balance = balance + interest;
    recordTransaction('interest', interest, 'Monthly interest applied');
  }
}
