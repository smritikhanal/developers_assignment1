import 'bank_account.dart';
import 'interest_bearing.dart';

class SavingsAccount extends BankAccount implements InterestBearing {
  static const double minBalance = 500.0;
  static const double _defaultAnnualRate = 0.02; // 2%

  final double _annualRate;

  // withdrawal tracking per-month
  int _withdrawalCount = 0;
  int _withdrawalMonth = 0; // year*100 + month

  SavingsAccount(
    String accountNumber,
    String holderName,
    double balance, {
    double annualRate = _defaultAnnualRate,
  }) : _annualRate = annualRate,
       super(accountNumber, holderName, balance) {
    if (balance < minBalance) {
      throw ArgumentError(
        'Initial balance must be at least \$${minBalance.toStringAsFixed(2)}',
      );
    }
  }

  @override
  double get annualInterestRate => _annualRate;

  void _refreshWithdrawalCounter() {
    final now = DateTime.now();
    final m = now.year * 100 + now.month;
    if (_withdrawalMonth != m) {
      _withdrawalMonth = m;
      _withdrawalCount = 0;
    }
  }

  @override
  void deposit(double amount) {
    if (amount <= 0) throw ArgumentError('Deposit amount must be > 0');
    balance = balance + amount;
    recordTransaction('Deposit', amount, 'Deposit to savings');
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) throw ArgumentError('Withdraw amount must be > 0');
    _refreshWithdrawalCounter();
    if (_withdrawalCount >= 3) {
      throw StateError('Monthly withdrawal limit reached (3)');
    }
    final newBalance = balance - amount;
    if (newBalance < minBalance) {
      throw StateError(
        'Withdrawal would reduce balance below minimum of \$${minBalance.toStringAsFixed(2)}',
      );
    }
    balance = newBalance;
    _withdrawalCount += 1;
    recordTransaction('Withdraw', amount, 'Withdrawal from savings');
  }

  @override
  void applyMonthlyInterest() {
    final monthlyRate = _annualRate / 12;
    final interest = balance * monthlyRate;
    if (interest <= 0) return;
    balance = balance + interest;
    recordTransaction('Interest', interest, 'Monthly interest applied');
  }
}
