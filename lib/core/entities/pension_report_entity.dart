class PensionReportEntity {
  final List<PensionReportRecordsEntity>? records;

  PensionReportEntity({this.records});
}

class PensionReportRecordsEntity {
  String? pensionReportName;
  String? pensionName;
  String? reportUrl;

  PensionReportRecordsEntity(
      {this.pensionReportName, this.pensionName, this.reportUrl});
}
