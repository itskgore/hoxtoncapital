import 'package:flutter/material.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/widgets/inputFields/currency_text_feild.dart';

class UpdateManualBankBalance extends StatefulWidget {
  Function(ValueEntity) onTap;
  ValueEntity currency;

  UpdateManualBankBalance(
      {Key? key, required this.onTap, required this.currency})
      : super(key: key);

  @override
  State<UpdateManualBankBalance> createState() =>
      _UpdateManualBankBalanceState();
}

class _UpdateManualBankBalanceState extends State<UpdateManualBankBalance> {
  final _formKey = GlobalKey<FormState>();
  GlobalKey<CurrencyTextFieldState> globalKey = GlobalKey();

  ValueEntity? currentValue;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)), //this right here
        child: Container(
            width: double.infinity,
            height: 330,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Text("Update bank balance", style: TitleHelper.h9),
                  const SizedBox(
                    height: 40,
                  ),
                  Form(
                    key: _formKey,
                    child: CurrencyTextField(
                      key: globalKey,
                      hintText: "New bank balance",
                      errorMsg: "New bank balance is required",
                      currencyModel: currentValue,
                      isFromUpdateBalance: true,
                      disableCurrency: true,
                      currencyString: widget.currency.currency,
                      onChange: (value) {
                        widget.currency = value;
                      },
                    ),
                  ),
                  const Spacer(),
                  const Divider(
                    color: Color(0xfffE5E5E5),
                  ),
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        widget.onTap(widget.currency);
                      }
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        width: double.infinity,
                        child:
                            Text("Update balance", style: SubtitleHelper.h11)),
                  ),
                  const Divider(
                    color: Color(0xfffE5E5E5),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: Text("Cancel", style: SubtitleHelper.h11))),
                ],
              ),
            )));
  }
}
