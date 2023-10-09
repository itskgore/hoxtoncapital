import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';

class BeneficiaryContactDays extends StatefulWidget {
  final String title;
  final String description;
  List<Map<String, dynamic>> contactDays;
  final Function(List<Map<String, dynamic>>) onChange;

  BeneficiaryContactDays(
      {Key? key,
      required this.title,
      required this.onChange,
      required this.description,
      required this.contactDays})
      : super(key: key);

  @override
  _BeneficiaryContactDaysState createState() => _BeneficiaryContactDaysState();
}

class _BeneficiaryContactDaysState extends State<BeneficiaryContactDays> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Column(
        children: [
          Text(
            widget.title,
            style: SubtitleHelper.h10,
          ),
          const SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.contactDays.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.contactDays.forEach((element) {
                        element['isSelected'] = false;
                      });
                      widget.contactDays[index]['isSelected'] = true;
                    });
                    widget.onChange(widget.contactDays);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 15),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: widget.contactDays[index]['isSelected']
                            ? lighten(appThemeColors!.primary!, 0.2)
                            : Colors.transparent,
                        border: Border.all(
                            color: widget.contactDays[index]['isSelected']
                                ? lighten(appThemeColors!.primary!, 0.2)
                                : lighten(appThemeColors!.textDark!, .5))),
                    alignment: Alignment.center,
                    child: Text(
                      widget.contactDays[index]['text'],
                      style: SubtitleHelper.h10.copyWith(
                        color: widget.contactDays[index]['isSelected']
                            ? appThemeColors!.textLight!
                            : lighten(appThemeColors!.textDark!, .5),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            widget.description,
            style: SubtitleHelper.h10,
          ),
        ],
      ),
    );
  }
}
