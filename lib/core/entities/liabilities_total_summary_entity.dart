class LiabilitiesTotalEntity {
  LiabilitiesTotalEntity({
    required this.currency,
    required this.amount,
    required this.count,
    required this.countryCount,
    required this.disconnectedAccountCount,
  });
  late final String currency;
  double amount;
  late final int count;
  late final num countryCount;
  late final int disconnectedAccountCount;

  List<Object> get props =>
      [currency, amount, count, countryCount, disconnectedAccountCount];
}
