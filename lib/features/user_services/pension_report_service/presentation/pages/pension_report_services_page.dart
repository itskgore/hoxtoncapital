import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/user_services_entity.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';

import '../cubit/pension_report_cubit.dart';

class PensionReportServicesPage extends StatefulWidget {
  RecordsEntity servicesRecord;

  PensionReportServicesPage({Key? key, required this.servicesRecord})
      : super(key: key);

  @override
  State<PensionReportServicesPage> createState() =>
      _PensionReportServicesPageState();
}

class _PensionReportServicesPageState extends State<PensionReportServicesPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata("");
  }

  List<String> tempFolderId = [];

  getdata(String folderId) {
    // if (services != null) {
    if (folderId.isNotEmpty) {
      tempFolderId.add(folderId);
    }
    context.read<PensionReportRecordsCubit>().getData(
          "pensionReport/viewList/execute",
        );
    // }
  }

  _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appThemeColors!.bg,
      appBar: wedgeAppBar(context: context, title: "Pension Reports"),
      body: BlocBuilder<PensionReportRecordsCubit, PensionReportRecordsState>(
        builder: (context, state) {
          if (state is PensionReportRecordsLoaded) {
            return Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      state.data.records!.length == 0
                          ? Center(
                              child: Text(
                              "No Data Found!",
                              style: SubtitleHelper.h10,
                            ))
                          : Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                itemCount: state.data.records!.length,
                                itemBuilder: (con, index) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          _launchURL(Uri.parse(state
                                              .data.records![index].reportUrl
                                              .toString()));
                                        },
                                        leading: Icon(
                                          Icons.description,
                                          color: appThemeColors!.primary,
                                          size: 50,
                                        ),
                                        title: Text(
                                          state.data.records![index]
                                              .pensionName!,
                                          textAlign: TextAlign.start,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: SubtitleHelper.h10.copyWith(
                                              color: appThemeColors!.textDark),
                                        ),
                                        subtitle: Text(state
                                            .data
                                            .records![index]
                                            .pensionReportName!),
                                      ),
                                      Divider()
                                    ],
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is PensionReportRecordsLoading) {
            return Center(
              child: buildCircularProgressIndicator(width: 90),
            );
          } else {
            return Center(
              child: buildCircularProgressIndicator(width: 90),
            );
          }
        },
      ),
    );
  }
}
