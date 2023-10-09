class AssetTotalEntity {
  AssetTotalEntity(
      {required this.currency,
      required this.amount,
      required this.count,
      required this.countryCount,
      required this.disconnectedAccountCount});
  late final String currency;
  double amount;
  late final int count;
  late num countryCount;
  late int disconnectedAccountCount;

  List<Object> get props =>
      [currency, amount, count, countryCount, disconnectedAccountCount];
}
