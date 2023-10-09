import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as filepath;
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/data_models/manual_bank_sucess_model.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/features/assets/bank_account/bank_success_screen/presentation/cubit/get_account_data_cubit.dart';
import 'package:wedge/features/assets/bank_account/bank_success_screen/presentation/pages/widgets/account_data_widget.dart';
import 'package:wedge/features/assets/bank_account/bank_success_screen/presentation/pages/widgets/bank_success_note_widget.dart';
import 'package:wedge/features/assets/bank_account/bank_success_screen/presentation/pages/widgets/bottom_navigation_buttons.dart';
import 'package:wedge/features/assets/bank_account/bank_success_screen/presentation/pages/widgets/manual_bank_succesful_widget.dart';

// Bank Success Page in the onboarding flow
class BankSuccessPage extends StatefulWidget {
  const BankSuccessPage(
      {super.key,
      this.instituteId,
      required this.isManuallyAdded,
      this.manualBankSuccessModel,
      this.showSaltedgeConcernedNote});

  // No need to pass showSaltedgeConcernedNote when passing isManuallyAdded = true

  @override
  State<BankSuccessPage> createState() => _BankSuccessPageState();
  final dynamic instituteId;
  final bool isManuallyAdded;
  final bool? showSaltedgeConcernedNote;
  final ManualBankSuccessModel? manualBankSuccessModel;
}

class _BankSuccessPageState extends State<BankSuccessPage> {
  bool isSVG(String url) {
    return filepath.extension(url).toLowerCase() == ".svg";
  }

  final formatter = NumberFormat("00000.00");

  @override
  void initState() {
    if (!widget.isManuallyAdded) {
      context.read<GetAccountDataCubit>().getData(widget.instituteId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isManuallyAdded
        ? ManualBankSuccessWidget(
            manualBankSuccessModel: widget.manualBankSuccessModel!)
        : BlocConsumer<GetAccountDataCubit, GetAccountDataState>(
            listener: (context, state) {
              if (state is GetAccountDataError) {
                showSnackBar(context: context, title: state.errorMsg);
              }
            },
            builder: (context, state) {
              return Scaffold(
                backgroundColor: appThemeColors!.bg,
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          (state is GetAccountDataLoadedButEmpty)
                              ? SizedBox(height: size.height * 0.35)
                              : SizedBox(height: size.height * 0.055),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                shape: BoxShape.circle),
                            child: Image.asset(
                              "assets/images/success_tick.png",
                              width: size.height * 0.14,
                              height: size.width * 0.14,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            translate!.linkedSuccessfully,
                            textAlign: TextAlign.center,
                            style: SubtitleHelper.h8
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            translate!.theAccountHasBeenLinkedSuccessfully,
                            textAlign: TextAlign.center,
                            style: SubtitleHelper.h10.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
                          ),
                          if (state is GetAccountDataLoaded) ...[
                            SizedBox(height: size.height * 0.025),
                            isSVG(state
                                    .data
                                    .assetLiabilityOnboardingEntityList[0]
                                    .aggregatorLogo)
                                ? SizedBox(
                                    height: 60,
                                    child: SvgPicture.network(
                                      state
                                          .data
                                          .assetLiabilityOnboardingEntityList[0]
                                          .aggregatorLogo,
                                      fit: BoxFit.contain,
                                      placeholderBuilder: (e) {
                                        return Image.asset(
                                          "assets/icons/bankAccountMainContainer.png",
                                          width: 40,
                                          height: 40,
                                        );
                                      },
                                    ),
                                  )
                                : SizedBox(
                                    height: 60,
                                    child: Image.network(
                                      state
                                          .data
                                          .assetLiabilityOnboardingEntityList[0]
                                          .aggregatorLogo,
                                      fit: BoxFit.contain,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return Image.asset(
                                          "assets/icons/bankAccountMainContainer.png",
                                          width: 40,
                                          height: 40,
                                        );
                                      },
                                    ),
                                  ),
                            SizedBox(height: size.height * 0.025),
                            widget.showSaltedgeConcernedNote ?? false
                                ? BankSuccessNoteWidget(
                                    noteBody: translate!
                                        .theConnectionAuthorisationWillLapseAfter90Days)
                                : const SizedBox.shrink(),
                            SizedBox(height: size.height * 0.025),
                            Text(
                              state.data.assetLiabilityOnboardingEntityList[0]
                                  .providerName,
                              textAlign: TextAlign.center,
                              style: SubtitleHelper.h9.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2B2B2B)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: state
                                    .data.assetLiabilityOnboardingEntityList
                                    .map((e) => AccountDetails(entity: e))
                                    .toList(),
                              ),
                            ),
                          ] else if (state is GetAccountDataLoadedButEmpty) ...[
                            SizedBox(height: size.height * 0.04),
                            BankSuccessNoteWidget(
                              noteBody: translate!.thereIsSomeDelayInRetrieving,
                            ),
                          ] else ...[
                            bankAccountDataLoader(),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: Opacity(
                  opacity: (state is GetAccountDataLoading) ? 0.2 : 1.0,
                  child: const BankSuccessBottomNavigationButtons(),
                ),
              );
            },
          );
  }
}
