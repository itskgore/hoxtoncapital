import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/widgets/wedge_expension_tile.dart';

class MortgagesWidget extends StatelessWidget {
  List<dynamic> mortgages;
  final Function(int i) onDeletePressed;
  final Function(int i) onEditPressed;
  MortgagesWidget(
      {super.key,
      required this.mortgages,
      required this.onDeletePressed,
      required this.onEditPressed});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: mortgages.length,
        itemBuilder: (context, index) {
          final property = [];
          for (var element
              in RootApplicationAccess.assetsEntity?.properties ?? []) {
            for (var m in element.mortgages) {
              if (m.id == mortgages[index].id) {
                property.add(element);
              }
            }
          }
          return WedgeExpansionTile(
            index: index,
            leftSubtitle: '${mortgages[index].country}',
            isUnlink: true,
            leftTitle: '${mortgages[index].provider}',
            midWidget: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Interest rate"),
                      const SizedBox(
                        height: 8.0,
                      ),
                      const Text("Monthly payment"),
                      const SizedBox(
                        height: 8.0,
                      ),
                      const Text("Maturity date"),
                      property.isEmpty
                          ? Container()
                          : Column(
                              children: List.generate(property.length, (index) {
                              return const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Text("Property"),
                                ],
                              );
                            })),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("${mortgages[index].interestRate}%"),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                          "${mortgages[index].monthlyPayment.currency} ${mortgages[index].monthlyPayment.amount} per month"),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(getFormattedDate2(mortgages[index].maturityDate)),
                      property.isEmpty
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: List.generate(property.length, (index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Text("${property[index].name}"),
                                  ],
                                );
                              }),
                            )
                    ],
                  ),
                ],
              ),
            ),
            onDeletePressed: () {
              onDeletePressed(index);
            },
            onEditPressed: () {
              onEditPressed(index);
            },
            rightTitle:
                '${mortgages[index].outstandingAmount.currency} ${mortgages[index].outstandingAmount.amount}',
          );
        });
  }
}
