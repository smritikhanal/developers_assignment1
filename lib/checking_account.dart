import 'bank_account.dart';

class CheckingAccount extends BankAccount {
  static const double _overdraftFee = 35.0;

  CheckingAccount(String accountNumber, String holderName, double balance)
    : super(accountNumber, holderName, balance);

  @override
  void deposit(double amount) {
    if (amount <= 0) throw ArgumentError('Deposit amount must be > 0');
    balance = balance + amount;
    recordTransaction('Deposit', amount, 'Deposit to checking');
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) throw ArgumentError('Withdraw amount must be > 0');
    balance = balance - amount;
    recordTransaction('Withdraw', amount, 'Withdrawal from checking');
    if (balance < 0) {
      balance = balance - _overdraftFee;
      recordTransaction('OverdraftFee', _overdraftFee, 'Overdraft fee applied');
    }
  }
}
