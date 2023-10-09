class SearchStocksCryptoEntity {
  final String exchange;
  final String shortname;
  final String quoteType;
  final String symbol;
  final String index;
  final num score;
  final String typeDisp;
  final String longname;
  final String exchDisp;
  final bool isYahooFinance;

  SearchStocksCryptoEntity(
      {required this.exchange,
      required this.shortname,
      required this.quoteType,
      required this.symbol,
      required this.index,
      required this.score,
      required this.typeDisp,
      required this.longname,
      required this.exchDisp,
      required this.isYahooFinance});
}
