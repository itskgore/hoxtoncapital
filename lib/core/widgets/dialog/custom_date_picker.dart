import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';

import '../../contants/string_contants.dart';
import '../../helpers/textfeild_validator.dart';

class DatePickerTextField extends StatefulWidget {
  DatePickerTextField(
      {required this.hintText,
      required this.errorMsg,
      required this.date,
      required this.createAt,
      this.enabled,
      Key? key})
      : super(key: key);
  String hintText;
  String errorMsg;
  String createAt;
  TextEditingController date;
  bool? enabled;
  @override
  State<DatePickerTextField> createState() => _DatePickerTextFieldState();
}

class _DatePickerTextFieldState extends State<DatePickerTextField> {
  TextFieldValidator validator = TextFieldValidator();
  String currentDate = "";
  DateTime intialDate = DateTime.now();

  @override
  void initState() {
    if (widget.date.text.isNotEmpty) {
      try {
        String date = dateFormatter2
            .format(DateTime.parse("${widget.date.text} 00:00:00"));
        _dateController.text = date;
      } catch (e) {
        _dateController.text = widget.date.text;
      }
    }
    super.initState();
  }

  Future<dynamic> showDatePickerData({required BuildContext context}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: intialDate,
      firstDate: intialDate,
      //  DateTime.parse(widget.createAt),
      lastDate: DateTime(DateTime.now().year + 50, DateTime.now().month),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
                primary: lighten(
                    appThemeColors!.primary!, .2), // header background color
                onPrimary: appThemeColors!.textLight!, // header text color
                onSurface: Colors.black // body text color
                ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.black, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != intialDate) {
      setState(() {
        intialDate = picked;
        _dateController.text = dateFormatter2.format(picked);
        widget.date.text = dateFormatter5.format(picked);
      });
    }
  }

  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    widget.date.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 73,
      padding: const EdgeInsets.only(bottom: 17, top: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              enabled: widget.enabled ?? true,
              validator: (value) {
                if (value!.isEmpty) {
                  return widget.errorMsg;
                }
              },
              controller: _dateController,
              onTap: () {
                showDatePickerData(context: context);
              },
              readOnly: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12),
                suffixIcon: GestureDetector(
                    onTap: () async {
                      showDatePickerData(context: context);
                    },
                    child: const Icon(
                      Icons.event,
                      size: 30,
                    )),
                fillColor: Colors.white,
                filled: true,
                enabledBorder: ktextFeildOutlineInputBorder,
                focusedBorder: ktextFeildOutlineInputBorderFocused,
                border: ktextFeildOutlineInputBorder,
                labelText: widget.hintText,
                labelStyle: labelStyle,
                suffixStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: appThemeHeadlineFont,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
