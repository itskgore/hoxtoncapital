import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/mortgages_entity.dart';
import 'package:wedge/core/widgets/wedge_expension_tile.dart';

class PropertyWidget extends StatelessWidget {
  final List<dynamic> properties;
  final Function(int i) onDeletePresseds;
  final Function(int i) onEditPresseds;
  List<MortgagesEntity>? mortgages;
  bool? isMortgages;

  PropertyWidget(
      {required this.properties,
      required this.onDeletePresseds,
      this.mortgages,
      this.isMortgages,
      required this.onEditPresseds});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: properties.length,
        itemBuilder: (context, index) {
          List<MortgagesEntity> mortgagesEntity = [];
          if (isMortgages != null) {
            properties[index].mortgages.forEach((e) {
              mortgages!.forEach((element) {
                if (element.id == e.id) {
                  if (mortgages!
                      .where((mor) => mor.id == element.id)
                      .toList()
                      .isNotEmpty) {
                    mortgagesEntity.add(element);
                  }
                }
              });
            });
          }
          // mortgages!.forEach((element) {
          //   mortgagesEntity = properties[index]
          //       .mortgages
          //       .where((e) => e.id == element.id)
          //       .toList();
          //   properties[index].mortgages.forEach((e) {
          //     if (e.id == element.id) {
          //       // print("YOOOO");
          //     }
          //   });
          // });
          // }
          return WedgeExpansionTile(
            index: index,
            leftSubtitle: '${properties[index].country}',
            leftTitle: '${properties[index].name}',
            isUnlink: true,
            midWidget: isMortgages == null
                ? null
                : mortgagesEntity.isEmpty
                    ? null
                    : Column(
                        children: List.generate(
                            mortgagesEntity.length,
                            (index) => Column(
                                  children: [
                                    Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 14),
                                        child: _mortgages(
                                            mortgagesEntity[index], index + 1)),
                                  ],
                                ))),
            onDeletePressed: () {
              onDeletePresseds(index);
            },
            onEditPressed: () {
              onEditPresseds(index);
            },
            rightTitle:
                '${properties[index].currentValue.currency} ${properties[index].currentValue.amount}',
            rightSubTitle: "",
          );
        });
  }

  Widget _mortgages(MortgagesEntity mortgages, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Mortgage $index",
                style: SubtitleHelper.h11.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Provider", style: SubtitleHelper.h11),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text("Outstanding", style: SubtitleHelper.h11),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text("Interest rate", style: SubtitleHelper.h11),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text("Maturity remaining", style: SubtitleHelper.h11),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text("Monthly payment", style: SubtitleHelper.h11),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(mortgages.provider, style: SubtitleHelper.h11),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                      "${mortgages.outstandingAmount.currency} ${numberFormat.format(mortgages.outstandingAmount.amount)}",
                      style: SubtitleHelper.h11),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text("${mortgages.interestRate}%", style: SubtitleHelper.h11),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(getFormattedDate2(mortgages.maturityDate),
                      style: SubtitleHelper.h11),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                      "${mortgages.monthlyPayment.currency} ${numberFormat.format(mortgages.monthlyPayment.amount)} per month",
                      style: SubtitleHelper.h11),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
