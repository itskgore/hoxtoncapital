import 'package:flutter/material.dart';

import '../../../../../../../core/contants/theme_contants.dart';

class BankSuccessNoteWidget extends StatelessWidget {
  const BankSuccessNoteWidget({
    Key? key,
    required this.noteBody,
  }) : super(key: key);

  final String noteBody;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: const Color(0xFFF5F7FF)),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: 'Note: ', style: TitleHelper.h11),
            TextSpan(
                text: noteBody,
                style: SubtitleHelper.h11
                    .copyWith(color: const Color(0xFF232C5E))),
          ],
        ),
      ),
    );
  }
}
