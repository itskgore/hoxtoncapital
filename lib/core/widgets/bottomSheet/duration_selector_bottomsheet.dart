import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wedge/core/config/app_config.dart';

import '../../contants/string_contants.dart';
import '../../contants/theme_contants.dart';
import '../../utils/wedge_func_methods.dart';
import '../../utils/wedge_snackBar.dart';
import '../buttons/app_button.dart';
import '../dropdown/datepicker_dropdown.dart';

class DurationSelectorBottomSheet extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Function onChange;
  final List initDateList;
  final String createdAt;
  final bool isShowMax;
  const DurationSelectorBottomSheet(
      {Key? key,
      required this.startDate,
      required this.endDate,
      required this.onChange,
      required this.createdAt,
      required this.isShowMax,
      required this.initDateList})
      : super(key: key);

  @override
  State<DurationSelectorBottomSheet> createState() =>
      _DurationSelectorBottomSheetState();
}

class _DurationSelectorBottomSheetState
    extends State<DurationSelectorBottomSheet> {
  late String selectedStartMonth;
  late String selectedStartYear;
  late String selectedEndMonth;
  late String selectedEndYear;
  DateTime currentDate = DateTime.now();
  List selectedDateList = [];
  int? selectedValue;

  @override
  void initState() {
    selectedStartYear = currentDate.year.toString();
    selectedEndYear = currentDate.year.toString();
    selectedEndMonth = currentDate.month.toString();
    selectedStartMonth =
        DateTime(currentDate.year, currentDate.month - 1, currentDate.day)
            .month
            .toString();

    selectedDateList = widget.initDateList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = size.height;
    DateTime now = DateTime.now();
    double dropDownHeight = height < 700
        ? height * 0.75
        : height < 800
            ? height * .66
            : height * 0.62;

    //Date Range Picker
    Future<void> _showDateRangePicker() async {
      double popHeight = size.height * .28;
      await showModalBottomSheet(
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SingleChildScrollView(
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: height * .02),
                          child: Text(
                            'Select timeline',
                            style:
                                SubtitleHelper.h10.copyWith(color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * .01),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Start Date",
                                style: SubtitleHelper.h12
                                    .copyWith(color: appThemeColors?.primary)),
                            DropdownDatePicker(
                              showDay: false,
                              isDropdownHideUnderline: true,
                              isFormValidator: true,
                              startYear: 2018,
                              endYear: DateTime.now().year,
                              monthMenuMaxHeight: popHeight,
                              yearMenuMaxHeight: popHeight,
                              width: size.width * .2,
                              selectedMonth: int.parse(selectedStartMonth),
                              selectedYear: int.parse(selectedStartYear),
                              textStyle: SubtitleHelper.h10.copyWith(
                                  color: appThemeColors?.primary,
                                  fontWeight: FontWeight.normal),
                              inputDecoration: InputDecoration(
                                  hoverColor: appThemeColors?.primary,
                                  focusColor: appThemeColors?.primary,
                                  isDense: true),
                              onChangedMonth: (startMonth) =>
                                  selectedStartMonth = startMonth!,
                              onChangedYear: (startYear) =>
                                  selectedStartYear = startYear!,
                            ),
                          ],
                        ),
                        SizedBox(height: height * .05),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("End Date",
                                style: SubtitleHelper.h12
                                    .copyWith(color: appThemeColors?.primary)),
                            DropdownDatePicker(
                              showDay: false,
                              isDropdownHideUnderline: true,
                              isFormValidator: true,
                              startYear: 2018,
                              endYear: DateTime.now().year,
                              monthMenuMaxHeight: popHeight,
                              yearMenuMaxHeight: popHeight,
                              width: size.width * .2,
                              selectedMonth: int.parse(selectedEndMonth),
                              selectedYear: int.parse(selectedEndYear),
                              textStyle: SubtitleHelper.h10.copyWith(
                                color: appThemeColors?.primary,
                              ),
                              inputDecoration: InputDecoration(
                                  hoverColor: appThemeColors?.primary,
                                  focusColor: appThemeColors?.primary,
                                  isDense: true),
                              onChangedMonth: (endMonth) =>
                                  selectedEndMonth = endMonth!,
                              onChangedYear: (endYear) =>
                                  selectedEndYear = endYear!,
                            ),
                          ],
                        ),
                        SizedBox(height: height * .12),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          child: AppButton(
                              label: "Done",
                              verticalPadding: 15,
                              borderRadius: 4,
                              style:
                                  TitleHelper.h10.copyWith(color: Colors.white),
                              onTap: () {
                                DateTime stateDate = DateTime(
                                    int.parse(selectedStartYear),
                                    int.parse(selectedStartMonth),
                                    1);
                                DateTime endDate = DateTime(
                                    int.parse(selectedEndYear),
                                    int.parse(selectedEndMonth),
                                    DateTime(int.parse(selectedEndYear),
                                            int.parse(selectedEndMonth) + 1, 0)
                                        .day);
                                var dayDifference =
                                    endDate.difference(stateDate).inDays;
                                if (dayDifference <= 0) {
                                  Navigator.of(context).pop();
                                  showSnackBar(
                                      context: context,
                                      title:
                                          "End date can not be greater then start date");
                                } else {
                                  //: remove previous selected date
                                  selectedDateList.clear();
                                  selectedDateList
                                      .addAll([stateDate, endDate, 6]);
                                  widget.onChange(selectedDateList);
                                  Navigator.of(context).pop();
                                }
                              }),
                        )
                      ]),
                ),
              ]),
            ),
          );
        },
      );
    }

    //Duration Selector
    Future<void> _showDurationPicker() async {
      List<String> optionsList = [
        "7 Days",
        "1 Month",
        "6 Months",
        "Year to date",
        "1 Year",
        "Custom"
      ];
      if (widget.isShowMax) {
        optionsList.insert(5, "Max");
      }
      await showModalBottomSheet(
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              height: dropDownHeight,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              child: Column(
                children: [
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
                      widgetListTile(
                        options: optionsList,
                        onChanged: (index) {
                          setState(() {
                            selectedValue = index;
                          });
                          switch (selectedValue) {
                            case 0:
                              //: 7 Days
                              selectedDateList.clear();
                              selectedDateList.addAll([
                                Jiffy.now().subtract(days: 6).dateTime,
                                now,
                                index
                              ]);
                              widget.onChange(selectedDateList);
                              Navigator.of(context).pop();
                              break;
                            case 1:
                              //: 1 Month
                              selectedDateList.clear();
                              selectedDateList.addAll([
                                Jiffy.now().subtract(months: 1).dateTime,
                                now,
                                index
                              ]);
                              widget.onChange(selectedDateList);
                              Navigator.of(context).pop();
                              break;
                            case 2:
                              //: 6 Months
                              selectedDateList.clear();
                              selectedDateList.addAll([
                                Jiffy.now().subtract(months: 6).dateTime,
                                now,
                                index
                              ]);
                              widget.onChange(selectedDateList);
                              Navigator.of(context).pop();
                              break;
                            case 3:
                              //: Year to date
                              selectedDateList.clear();
                              selectedDateList.addAll(
                                  [DateTime(now.year, 1, 1), now, index]);
                              widget.onChange(selectedDateList);
                              Navigator.of(context).pop();
                              break;
                            case 4:
                              //: 1 Year
                              selectedDateList.clear();
                              selectedDateList.addAll([
                                Jiffy.now().subtract(years: 1).dateTime,
                                now,
                                index
                              ]);
                              widget.onChange(selectedDateList);
                              Navigator.of(context).pop();
                              break;
                            case 5:
                              //: Max
                              if (optionsList[5].toLowerCase() == "max") {
                                selectedDateList.clear();
                                DateTime createdDate =
                                    DateTime.parse(widget.createdAt);
                                selectedDateList.addAll([
                                  DateTime(createdDate.year, createdDate.month,
                                      createdDate.day),
                                  now,
                                  index
                                ]);
                                widget.onChange(selectedDateList);
                                Navigator.of(context).pop();
                              } else {
                                Navigator.of(context).pop();
                                _showDateRangePicker();
                              }
                              break;

                            default:
                              //: Custom
                              Navigator.of(context).pop();
                              _showDateRangePicker();
                              break;
                          }
                        },
                        selectedOption: selectedDateList.length == 3
                            ? selectedDateList[2]
                            : 1, // The index of the initially selected option
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    //Date Picker Widget
    return InkWell(
        onTap: () async {
          _showDurationPicker();
        },
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black38),
                borderRadius: BorderRadius.circular(4)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                  ),
                  child: Text(
                    "${dateFormatter.format((selectedDateList.isNotEmpty ? selectedDateList[0] : null) ?? widget.startDate)}  to ${dateFormatter.format((selectedDateList.isNotEmpty ? selectedDateList[1] : null) ?? widget.endDate)}",
                    style: SubtitleHelper.h11
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: appThemeColors?.primary,
                      borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(3))),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    "assets/icons/edit.png",
                    scale: 3,
                  ),
                )
              ],
            )));
  }
}

class widgetListTile extends StatefulWidget {
  final List<String> options;
  final Function(dynamic) onChanged;
  final dynamic selectedOption;
  final bool? isReturnValue;
  final bool? isDateFormatted;

  const widgetListTile({
    required this.options,
    required this.onChanged,
    required this.selectedOption,
    this.isReturnValue,
    this.isDateFormatted,
    Key? key,
  }) : super(key: key);

  @override
  _widgetListTileState createState() => _widgetListTileState();
}

class _widgetListTileState extends State<widgetListTile> {
  int? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        widget.options.length,
        (index) => InkWell(
          splashColor: appThemeColors?.primary?.withOpacity(.2),
          onTap: () {
            setState(() {
              _selectedOption = index;
              if (widget.isReturnValue ?? false) {
                widget.onChanged(widget.options[index]);
              } else {
                widget.onChanged(_selectedOption!);
              }
            });
          },
          child: Container(
            width: size.width,
            decoration: BoxDecoration(
                color:
                    _selectedOption == index ? appThemeColors?.primary : null),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Text(
              widget.isDateFormatted ?? false
                  ? dateFormatter14
                      .format(DateTime.parse(widget.options[index]))
                  : widget.options[index],
              style: SubtitleHelper.h10.copyWith(
                color: _selectedOption == index ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
