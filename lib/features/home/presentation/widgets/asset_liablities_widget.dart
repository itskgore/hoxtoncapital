import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/dashboard_entity.dart';
import 'package:wedge/features/assets/assets_liablities_main/presentation/pages/assets_Liabilities_main_page.dart';

import '../../../../core/data_models/theme_model.dart';
import 'sub_widgets/section_titlebar.dart';

class AssetLiablitiesHome extends StatefulWidget {
  DashboardDataEntity dashboardDataEntity;
  Function onComplete;

  AssetLiablitiesHome(
      {Key? key, required this.dashboardDataEntity, required this.onComplete})
      : super(key: key);

  @override
  _AssetLiablitiesHomeState createState() => _AssetLiablitiesHomeState();
}

class _AssetLiablitiesHomeState extends State<AssetLiablitiesHome> {
  getAssetPercentage() {
    var assetPer = (widget.dashboardDataEntity.data.assetSummary.types /
            (widget.dashboardDataEntity.data.assetSummary.types +
                widget.dashboardDataEntity.data.liabilitySummary.types)) *
        100;
    if (widget.dashboardDataEntity.data.assetSummary.types == 0 &&
        widget.dashboardDataEntity.data.liabilitySummary.types == 0) {
      return 0.5;
    } else if (widget.dashboardDataEntity.data.liabilitySummary.types == 0) {
      return 1.0;
    } else if (widget.dashboardDataEntity.data.assetSummary.types == 0) {
      return 0.0;
    } else {
      return double.parse("0.${assetPer.round()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);
    return Container(
      height: 180,
      color: appThemeColors!.bg,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          children: [
            SectionTitleBarHome(
                title: translate!.assetsAndLiabilities,
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              AssetsAndLiabilitiesMainPage())).then((value) {
                    widget.onComplete();
                  });
                }),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.dashboardDataEntity.data.baseCurrency} ${numberFormat.format(widget.dashboardDataEntity.data.assetSummary.value)}",
                  style: TitleHelper.h11,
                ),
                Text(
                  "${widget.dashboardDataEntity.data.baseCurrency} ${numberFormat.format(widget.dashboardDataEntity.data.liabilitySummary.value)} ",
                  style: TitleHelper.h11,
                ),
              ],
            ),
            // (dataSet?.assetSummary?.types / (dataSet?.assetSummary?.types | dataSet?.liabilitySummary?.types)) * 100,);
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: MediaQuery.of(context).size.width,
              height: 6,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: LinearProgressIndicator(
                  value: getAssetPercentage(),
                  minHeight: 3,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(HexColor("#6AAC89")),
                  backgroundColor:
                      appThemeColors!.charts!.liabilties!.progressLineColor!,
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${translate.assets} (${widget.dashboardDataEntity.data.assetSummary.types})",
                  style: SubtitleHelper.h11,
                ),
                Text(
                  "${translate.liabilities} (${widget.dashboardDataEntity.data.liabilitySummary.types})",
                  style: SubtitleHelper.h11,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
