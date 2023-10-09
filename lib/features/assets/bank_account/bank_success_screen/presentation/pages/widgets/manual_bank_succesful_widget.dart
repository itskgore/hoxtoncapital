import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/data_models/manual_bank_sucess_model.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/features/assets/bank_account/bank_success_screen/presentation/pages/widgets/bottom_navigation_buttons.dart';

// Success page when bank is added manually
class ManualBankSuccessWidget extends StatelessWidget {
  const ManualBankSuccessWidget({
    Key? key,
    required this.manualBankSuccessModel,
  }) : super(key: key);

  final ManualBankSuccessModel manualBankSuccessModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appThemeColors!.bg,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // SizedBox(height: size.height * 0.2),
              Container(
                decoration: BoxDecoration(
                    color: Colors.green.shade50, shape: BoxShape.circle),
                child: Image.asset(
                  "assets/images/success_tick.png",
                  width: 60,
                  height: 60,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                translate!.addedSuccessfully,
                textAlign: TextAlign.center,
                style: SubtitleHelper.h8
                    .copyWith(fontWeight: FontWeight.w600, color: Colors.black),
              ),
              const SizedBox(height: 20.0),
              Text(
                translate!.theAccountHasBeenLinkedSuccessfully,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            manualBankSuccessModel.bankName,
                            textAlign: TextAlign.left,
                            style: TextHelper.h5
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${manualBankSuccessModel.currency} ${NumberFormat("00000.00").format(double.parse(manualBankSuccessModel.currentAmount.isNotEmpty ? manualBankSuccessModel.currentAmount : "0"))}",
                            textAlign: TextAlign.right,
                            style: TextHelper.h5
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      getFullCountryNameFromISO3(
                          manualBankSuccessModel.location),
                      textAlign: TextAlign.left,
                      style:
                          TextHelper.h6.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )
            ]),
      ),
      bottomNavigationBar: const BankSuccessBottomNavigationButtons(),
    );
  }
}
