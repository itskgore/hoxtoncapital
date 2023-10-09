import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';

class DurationSelectorDropdown extends StatefulWidget {
  final String initialValue;
  final List<String> items;
  final Function(String?)? onChanged;

  DurationSelectorDropdown(
      {Key? key,
      required this.initialValue,
      required this.items,
      this.onChanged})
      : super(key: key);

  @override
  State<DurationSelectorDropdown> createState() =>
      _DurationSelectorDropdownState();
}

class _DurationSelectorDropdownState extends State<DurationSelectorDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(border: Border.all(color: Colors.black38)),
      child: DropdownButton<String>(
        underline: const SizedBox(),
        isDense: true,
        elevation: 0,
        focusColor: appThemeColors?.primary,
        icon: const Icon(Icons.keyboard_arrow_down),
        value: widget.initialValue,
        onChanged: widget.onChanged,
        items: widget.items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
