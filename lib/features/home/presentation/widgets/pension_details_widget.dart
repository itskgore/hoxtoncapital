import 'package:flutter/material.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/features/assets/bank_account/userdata_summery/presentation/widgets/user_summery_card.dart';
import 'package:wedge/features/home/presentation/widgets/sub_widgets/section_titlebar.dart';

class PensionDetailsHome extends StatelessWidget {
  const PensionDetailsHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 400,
        child: Column(
          children: [
            SectionTitleBarHome(title: PENSIONS, onTap: () {}),
            const SizedBox(
              height: 10,
            ),
            PensionCard(),
            const SizedBox(
              height: 10,
            ),
            PensionCard(),
          ],
        ),
      ),
    );
  }
}
