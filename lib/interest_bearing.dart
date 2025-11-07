abstract class InterestBearing {
  /// Annual interest rate expressed as a decimal (e.g. 0.02 for 2%)
  double get annualInterestRate;

  /// Apply monthly interest to the account implementing this interface.
  void applyMonthlyInterest();
}
