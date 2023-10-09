import 'package:flutter/material.dart';
import 'package:wedge/core/entities/vehicle_entity.dart';
import 'package:wedge/core/widgets/wedge_expension_tile.dart';

class VehicleWidget extends StatelessWidget {
  final List<VehicleEntity> properties;
  final Function(int i) onDeletePresseds;
  final Function(int i) onEditPresseds;

  VehicleWidget(
      {required this.properties,
      required this.onDeletePresseds,
      required this.onEditPresseds});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: properties.length,
        itemBuilder: (context, index) {
          final data = properties[index];
          return WedgeExpansionTile(
            index: index,
            leftSubtitle: data.country,
            isUnlink: true,
            leftTitle: data.name,
            midWidget: null,
            onDeletePressed: () {
              onDeletePresseds(index);
            },
            onEditPressed: () {
              onEditPresseds(index);
            },
            rightTitle: '${data.value.currency} ${data.value.amount}',
            rightSubTitle: "",
          );
        });
  }
}
