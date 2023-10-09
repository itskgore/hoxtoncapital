import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/contants/theme_contants.dart';

class WedgeCustomDropDown extends StatelessWidget {
  final String? value;
  final Widget? hint;
  final List<dynamic> items;
  final Function(String) onChanged;
  List<DropdownMenuItem<String>>? itemsWidget;
  InputDecoration? decoration;
  String? mapValue = "";
  WedgeCustomDropDown(
      {Key? key,
      required this.items,
      this.itemsWidget,
      this.decoration,
      this.mapValue,
      this.hint,
      this.value,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      decoration: decoration ??
          const InputDecoration(
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.zero,
            enabledBorder: ktextFeildOutlineInputBorder,
            focusedBorder: ktextFeildOutlineInputBorder,
            border: ktextFeildOutlineInputBorder,
          ),
      isExpanded: true,
      iconStyleData: const IconStyleData(icon: Icon(Icons.arrow_drop_down)),
      buttonStyleData: const ButtonStyleData(
        height: 53,
        padding: EdgeInsets.only(left: 10, right: 10),
      ),
      dropdownStyleData: DropdownStyleData(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      value: value,
      hint: hint,
      selectedItemBuilder: (BuildContext context) {
        return items.map<Widget>((dynamic item) {
          return Container(
              alignment: Alignment.centerLeft,
              // width: 180,
              child: Text(mapValue == null ? item : item[mapValue!],
                  textAlign: TextAlign.end));
        }).toList();
      },
      items: itemsWidget ??
          List.generate(items.length, (index) {
            return DropdownMenuItem<String>(
              value: mapValue == null ? items[index] : items[index][mapValue!],
              child: Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  // color: items.indexOf(value) == index ? Colors.black12 : null,
                  border: Border(
                      bottom: BorderSide(
                          width: index == items.length - 1 ? 0.0 : 0.5,
                          color: kDividerColor)),
                  // borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  mapValue == null ? items[index] : items[index][mapValue!],
                  textAlign: TextAlign.left,
                  style: SubtitleHelper.h10,
                ),
              ),
            );
          }),
      onChanged: (value) {
        //Do something when changing the item if you want.
        onChanged(value.toString());
      },
      onSaved: (value) {},
    );
  }
}
