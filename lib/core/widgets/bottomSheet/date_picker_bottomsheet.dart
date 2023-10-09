import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/widgets/bottomSheet/duration_selector_bottomsheet.dart';

import '../../contants/string_contants.dart';
import '../../contants/theme_contants.dart';
import '../../utils/wedge_func_methods.dart';

class DatePickerBottomSheet extends StatefulWidget {
  final DateTime initDate;
  final Function onChange;
  final String? createdAt;
  final bool? showOneYearDateRange;
  final DateTime? selectedDate;

  const DatePickerBottomSheet(
      {Key? key,
      required this.initDate,
      required this.onChange,
      this.showOneYearDateRange,
      this.createdAt,
      this.selectedDate})
      : super(key: key);

  @override
  State<DatePickerBottomSheet> createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<DatePickerBottomSheet> {
  late String selectedMonth;
  late String selectedYear;
  DateTime currentDate = DateTime.now();
  dynamic selectedValue;
  List<String> optionsList = [];
  DateTime? createdAt;
  String? newDateFormant;

  @override
  void initState() {
    log('YOOO init state called');
    createdAt = widget.createdAt != null
        ? DateTime.parse("${widget.createdAt}")
        : DateTime(
            DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);
    selectedYear = currentDate.year.toString();
    selectedMonth =
        DateTime(currentDate.year, currentDate.month + 1, currentDate.day)
            .month
            .toString();
    //gat dropdown Month List
    getDateRangeList();
    super.initState();
  }

  getDateRangeList() {
    DateTime? newDate = DateTime.now();
    DateTime currentDate = createdAt != null
        ? DateTime(createdAt!.year, createdAt!.month - 1, 1)
        : DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
    String newDateFormant = dateFormatter5.format(newDate);
    String currentDateFormant = dateFormatter5.format(currentDate);
    if (widget.showOneYearDateRange == true) {
      for (var i = 0; i <= 11; i++) {
        optionsList.add(newDateFormant);
        newDate = DateTime(newDate!.year, newDate.month - 1, 1);
        newDateFormant = dateFormatter5.format(newDate);
      }
    } else {
      var i = 0;
      while (currentDateFormant != newDateFormant) {
        i++;
        optionsList.add(newDateFormant);
        newDate = DateTime(newDate!.year, newDate.month - 1, 1);
        newDateFormant = dateFormatter5.format(newDate);
        if (currentDateFormant == newDateFormant) {
          return;
        }
        if (i == 12) {
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = size.height;
    DateTime now = DateTime.now();
    double dropDownHeight = height < 700
        ? height * 0.55
        : height < 800
            ? height * .46
            : height * 0.42;

    //Date Range Picker
    Future<void> _showDateRangePicker() async {
      await showModalBottomSheet(
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            physics:
                const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
            child: Container(
              height: dropDownHeight,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              child: Column(children: [
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: 2,
                    width: 170,
                    color: Colors.black),
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: height * .02, horizontal: 20),
                        child: Text(
                          'Select timeline',
                          style:
                              SubtitleHelper.h10.copyWith(color: Colors.grey),
                        ),
                      ),
                      SizedBox(height: height * .01),
                      SizedBox(
                        height: size.height * .3,
                        child: SingleChildScrollView(
                          child: widgetListTile(
                            options: optionsList,
                            isReturnValue: true,
                            isDateFormatted: true,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value;
                              });
                              widget.onChange(selectedValue);
                              Navigator.pop(context);
                            },
                            selectedOption: widget.selectedDate != null
                                ? 0
                                : selectedValue != null
                                    ? optionsList.indexOf(selectedValue)
                                    : 0, // The index of the initially selected option
                          ),
                        ),
                      )
                    ]),
              ]),
            ),
          );
        },
      );
    }

    //Date Picker Widget
    return InkWell(
        onTap: () async {
          _showDateRangePicker();
        },
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(4)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                  ),
                  child: Text(
                      dateFormatter14.format(widget.selectedDate ??
                          (selectedValue != null
                              ? DateTime.parse(selectedValue)
                              : widget.initDate)),
                      style: SubtitleHelper.h11),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: appThemeColors?.primary,
                )
              ],
            )));
  }
}
