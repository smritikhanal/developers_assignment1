import 'bank_account.dart';
import 'interest_bearing.dart';

class PremiumAccount extends BankAccount implements InterestBearing {
  static const double minBalance = 10000.0;
  static const double _defaultAnnualRate = 0.05; // 5%

  final double _annualRate;

  PremiumAccount(
    String accountNumber,
    String holderName,
    double balance, {
    double annualRate = _defaultAnnualRate,
  }) : _annualRate = annualRate,
       super(accountNumber, holderName, balance) {
    if (balance < minBalance) {
      throw ArgumentError(
        'Premium accounts require an initial balance of at least \$${minBalance.toStringAsFixed(2)}',
      );
    }
  }

  @override
  double get annualInterestRate => _annualRate;

  @override
  void deposit(double amount) {
    if (amount <= 0) throw ArgumentError('Deposit amount must be > 0');
    balance = balance + amount;
    recordTransaction('Deposit', amount, 'Deposit to premium account');
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) throw ArgumentError('Withdraw amount must be > 0');
    final newBalance = balance - amount;
    if (newBalance < minBalance) {
      throw StateError(
        'Premium account must maintain a minimum balance of \$${minBalance.toStringAsFixed(2)}',
      );
    }
    balance = newBalance;
    recordTransaction('Withdraw', amount, 'Withdrawal from premium account');
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
