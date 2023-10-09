import 'package:flutter/material.dart';

import '../../../../../core/contants/theme_contants.dart';

class CustomUnOrderList extends StatelessWidget {
  final List<String> listItems;

  const CustomUnOrderList({Key? key, required this.listItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 5, left: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: listItems.map((str) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '\u2022',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Text(
                  str,
                  textAlign: TextAlign.left,
                  softWrap: true,
                  style: SubtitleHelper.h11,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
