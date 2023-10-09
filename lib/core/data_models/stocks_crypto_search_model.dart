import 'package:wedge/core/entities/stocks_crypto_search_entity.dart';

class SearchStocksCryptoModel extends SearchStocksCryptoEntity {
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

  SearchStocksCryptoModel(
      {required this.exchange,
      required this.shortname,
      required this.quoteType,
      required this.symbol,
      required this.index,
      required this.score,
      required this.typeDisp,
      required this.longname,
      required this.exchDisp,
      required this.isYahooFinance})
      : super(
            exchDisp: exchDisp,
            exchange: exchange,
            index: index,
            isYahooFinance: isYahooFinance,
            longname: longname,
            quoteType: quoteType,
            score: score,
            shortname: shortname,
            symbol: symbol,
            typeDisp: typeDisp);

  factory SearchStocksCryptoModel.fromJson(Map<String, dynamic> json) {
    return SearchStocksCryptoModel(
        exchange: json['exchange'] ?? "",
        shortname: json['shortname'] ?? "",
        quoteType: json['quoteType'] ?? "",
        symbol: json['symbol'] ?? "",
        index: json['index'] ?? "",
        score: json['score'] ?? 0,
        typeDisp: json['typeDisp'] ?? "",
        longname: json['longname'] ?? "",
        exchDisp: json['exchDisp'] ?? "",
        isYahooFinance: json['isYahooFinance'] ?? true);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['exchange'] = exchange;
    data['shortname'] = shortname;
    data['quoteType'] = quoteType;
    data['symbol'] = symbol;
    data['index'] = index;
    data['score'] = score;
    data['typeDisp'] = typeDisp;
    data['longname'] = longname;
    data['exchDisp'] = exchDisp;
    data['isYahooFinance'] = isYahooFinance;
    return data;
  }
}
