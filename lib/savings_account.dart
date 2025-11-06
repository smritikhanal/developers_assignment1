import 'bank_account.dart';
import 'interest_bearing.dart';

class SavingsAccount extends BankAccount implements InterestBearing {
  static const double _minBalance = 500.0;
  static const double _interestRate = 0.02; // 2%
  static const int _monthlyWithdrawalLimit = 3;

  int _withdrawalsThisMonth = 0;

  SavingsAccount(
    String accountNumber,
    String accountHolderName,
    double initialBalance,
  ) : super(accountNumber, accountHolderName, initialBalance) {
    if (initialBalance < _minBalance) {
      throw ArgumentError(
        'Initial balance for SavingsAccount must be at least \$$_minBalance',
      );
    }
  }

  @override
  void deposit(double amount) {
    if (amount <= 0) throw ArgumentError('Deposit amount must be positive');
    balance = balance + amount;
    recordTransaction('deposit', amount, 'Deposit to savings');
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) throw ArgumentError('Withdrawal amount must be positive');
    if (_withdrawalsThisMonth >= _monthlyWithdrawalLimit) {
      throw StateError('Monthly withdrawal limit reached');
    }
    if (balance - amount < _minBalance) {
      throw StateError(
        'Cannot withdraw: balance would fall below minimum of \$$_minBalance',
      );
    }
    balance = balance - amount;
    _withdrawalsThisMonth += 1;
    recordTransaction('withdraw', amount, 'Withdrawal from savings');
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

  void resetMonthly() {
    _withdrawalsThisMonth = 0;
  }
}
