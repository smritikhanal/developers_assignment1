abstract class InterestBearing {
  /// Calculate interest amount based on current balance.
  double calculateInterest();

  /// Apply the calculated interest to the account (concrete classes can override)
  void applyInterest();
}
