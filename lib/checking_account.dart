import 'bank_account.dart';

class CheckingAccount extends BankAccount {
  static const double _overdraftFee = 35.0;

  CheckingAccount(
    String accountNumber,
    String accountHolderName,
    double initialBalance,
  ) : super(accountNumber, accountHolderName, initialBalance) {
    // no minimum balance
  }

  @override
  void deposit(double amount) {
    if (amount <= 0) throw ArgumentError('Deposit amount must be positive');
    balance = balance + amount;
    recordTransaction('deposit', amount, 'Deposit to checking');
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) throw ArgumentError('Withdrawal amount must be positive');

    double newBalance = balance - amount;
    if (newBalance < 0) {
      // apply overdraft fee
      newBalance -= _overdraftFee;
    }
    balance = newBalance;
    recordTransaction('withdraw', amount, 'Withdrawal from checking');
    if (balance < 0) {
      // record overdraft fee as separate transaction
      recordTransaction('fee', _overdraftFee, 'Overdraft fee applied');
    }
  }
}
