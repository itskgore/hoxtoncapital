import 'package:wedge/core/entities/pension_report_entity.dart';

class PensionReport extends PensionReportEntity {
  List<PensionReportRecords>? records;

  PensionReport({this.records}) : super(records: records);

  PensionReport.fromJson(Map<String, dynamic> json) {
    if (json['records'] != null) {
      records = <PensionReportRecords>[];
      json['records'].forEach((v) {
        records!.add(PensionReportRecords.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (records != null) {
      data['records'] = records!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PensionReportRecords extends PensionReportRecordsEntity {
  String? pensionReportName;
  String? pensionName;
  String? reportUrl;

  PensionReportRecords(
      {this.pensionReportName, this.pensionName, this.reportUrl})
      : super(
            pensionName: pensionName,
            pensionReportName: pensionReportName,
            reportUrl: reportUrl);

  PensionReportRecords.fromJson(Map<String, dynamic> json) {
    pensionReportName = json['pensionReportName'];
    pensionName = json['pensionName'];
    reportUrl = json['reportUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pensionReportName'] = pensionReportName;
    data['pensionName'] = pensionName;
    data['reportUrl'] = reportUrl;
    return data;
  }
}
