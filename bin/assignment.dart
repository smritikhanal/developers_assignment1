import 'package:assignment/assignment.dart';

void main(List<String> arguments) {
  final bank = Bank();

  final sa = bank.createSavingsAccount('Alice', 1000.0);
  final ca = bank.createCheckingAccount('Bob', 200.0);
  final pa = bank.createPremiumAccount('Carol', 15000.0);

  print('Created accounts:');
  print(sa.displayInfo());
  print(ca.displayInfo());
  print(pa.displayInfo());

  // perform some actions
  sa.deposit(200);
  try {
    sa.withdraw(600); // should be allowed (leaves 600 >= 500)
  } catch (e) {
    print('Savings withdraw failed: $e');
  }

  try {
    ca.withdraw(300); // causes overdraft + fee
  } catch (e) {
    print('Checking withdraw failed: $e');
  }

  try {
    bank.transfer(pa.accountNumber, sa.accountNumber, 1000);
    print('Transferred \$1000 from Premium to Savings');
  } catch (e) {
    print('Transfer failed: $e');
  }

  print('\nBank report:');
  print(bank.generateReport());
}
