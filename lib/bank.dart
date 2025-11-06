import 'bank_account.dart';
import 'savings_account.dart';
import 'checking_account.dart';
import 'premium_account.dart';
import 'student_account.dart';
import 'interest_bearing.dart';

class Bank {
  final Map<String, BankAccount> _accounts = {};
  int _nextSequence = 100000;

  String _generateAccountNumber() {
    _nextSequence += 1;
    return _nextSequence.toString();
  }

  SavingsAccount createSavingsAccount(
    String holderName,
    double initialBalance,
  ) {
    String acc = _generateAccountNumber();
    final account = SavingsAccount(acc, holderName, initialBalance);
    _accounts[acc] = account;
    return account;
  }

  CheckingAccount createCheckingAccount(
    String holderName,
    double initialBalance,
  ) {
    String acc = _generateAccountNumber();
    final account = CheckingAccount(acc, holderName, initialBalance);
    _accounts[acc] = account;
    return account;
  }

  PremiumAccount createPremiumAccount(
    String holderName,
    double initialBalance,
  ) {
    String acc = _generateAccountNumber();
    final account = PremiumAccount(acc, holderName, initialBalance);
    _accounts[acc] = account;
    return account;
  }

  StudentAccount createStudentAccount(
    String holderName,
    double initialBalance,
  ) {
    String acc = _generateAccountNumber();
    final account = StudentAccount(acc, holderName, initialBalance);
    _accounts[acc] = account;
    return account;
  }

  BankAccount? findAccount(String accountNumber) => _accounts[accountNumber];

  /// Transfer amount from one account to another. Throws on failure.
  void transfer(String fromAcc, String toAcc, double amount) {
    if (amount <= 0) throw ArgumentError('Transfer amount must be positive');
    final from = findAccount(fromAcc);
    final to = findAccount(toAcc);
    if (from == null) throw StateError('Source account not found');
    if (to == null) throw StateError('Destination account not found');

    // Attempt withdraw then deposit. If withdraw throws, nothing changes.
    from.withdraw(amount);
    // If deposit throws (rare), attempt to rollback. For simplicity we try to rollback.
    try {
      to.deposit(amount);
      // record explicit transfer transactions
      try {
        from.recordTransaction('transfer_out', amount, 'Transferred to $toAcc');
      } catch (_) {}
      try {
        to.recordTransaction('transfer_in', amount, 'Received from $fromAcc');
      } catch (_) {}
    } catch (e) {
      // rollback
      from.deposit(amount);
      rethrow;
    }
  }

  /// Apply monthly interest to all interest-bearing accounts.
  void applyMonthlyInterest() {
    for (final acc in _accounts.values) {
      if (acc is InterestBearing) {
        try {
          (acc as InterestBearing).applyInterest();
        } catch (_) {
          // ignore errors for now; could log
        }
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
