import 'bank_account.dart';
import 'savings_account.dart';
import 'checking_account.dart';
import 'premium_account.dart';
import 'student_account.dart';
import 'interest_bearing.dart';

// Single, consolidated Bank class.
class Bank {
  final Map<String, BankAccount> _accounts = {};
  int _nextSequence = 100000;

  String _generateAccountNumber() => (++_nextSequence).toString();

  void addAccount(BankAccount account) {
    if (_accounts.containsKey(account.accountNumber)) {
      throw ArgumentError('Account ${account.accountNumber} already exists');
    }
    _accounts[account.accountNumber] = account;
  }

  SavingsAccount createSavingsAccount(
    String holderName,
    double initialBalance, {
    double annualRate = 0.02,
  }) {
    final number = _generateAccountNumber();
    final account = SavingsAccount(
      number,
      holderName,
      initialBalance,
      annualRate: annualRate,
    );
    _accounts[number] = account;
    return account;
  }

  CheckingAccount createCheckingAccount(
    String holderName,
    double initialBalance,
  ) {
    final number = _generateAccountNumber();
    final account = CheckingAccount(number, holderName, initialBalance);
    _accounts[number] = account;
    return account;
  }

  PremiumAccount createPremiumAccount(
    String holderName,
    double initialBalance, {
    double annualRate = 0.05,
  }) {
    final number = _generateAccountNumber();
    final account = PremiumAccount(
      number,
      holderName,
      initialBalance,
      annualRate: annualRate,
    );
    _accounts[number] = account;
    return account;
  }

  StudentAccount createStudentAccount(
    String holderName,
    double initialBalance,
  ) {
    final number = _generateAccountNumber();
    final account = StudentAccount(number, holderName, initialBalance);
    _accounts[number] = account;
    return account;
  }

  BankAccount? findAccount(String accountNumber) => _accounts[accountNumber];

  void transfer(String fromAcc, String toAcc, double amount) {
    if (amount <= 0) throw ArgumentError('Transfer amount must be positive');
    final from = findAccount(fromAcc);
    final to = findAccount(toAcc);
    if (from == null) throw StateError('Source account not found');
    if (to == null) throw StateError('Destination account not found');

    from.withdraw(amount);
    try {
      to.deposit(amount);
    } catch (e) {
      from.deposit(amount);
      rethrow;
    }

    from.recordTransaction('TransferOut', amount, 'Transfer to $toAcc');
    to.recordTransaction('TransferIn', amount, 'Transfer from $fromAcc');
  }

  void applyMonthlyInterestToAll() {
    for (final acc in _accounts.values) {
      if (acc is InterestBearing) {
        try {
          (acc as InterestBearing).applyMonthlyInterest();
        } catch (_) {}
      }
    }
  }

  List<BankAccount> getAllAccounts() => _accounts.values.toList();

  String generateReport() {
    final buffer = StringBuffer();
    buffer.writeln('Bank Accounts Report');
    buffer.writeln('--------------------');
    for (final acc in _accounts.values) {
      buffer.writeln(acc.displayInfo());
    }
    return buffer.toString();
  }
}
