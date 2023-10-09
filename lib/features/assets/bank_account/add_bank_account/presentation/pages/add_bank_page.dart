import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/footer_single_button.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/assets/bank_account/add_bank_account/presentation/bloc/cubit/get_providers_cubit.dart';
import 'package:wedge/features/assets/bank_account/add_bank_account/presentation/widgets/bank_list_content_widget.dart';
import 'package:wedge/features/assets/bank_account/yodlee_frame/presentation/pages/yodlee_frame_page.dart';

class AddBankAccountPage extends StatefulWidget {
  const AddBankAccountPage({
    Key? key,
    required this.title,
    this.subtitle,
    required this.placeholder,
    required this.manualAddButtonTitle,
    required this.manualAddButtonAction,
    required this.successPopUp,
    this.isAppBar,
  }) : super(key: key);
  final String title;
  final String? subtitle;
  final String placeholder;
  final String manualAddButtonTitle;
  final Function manualAddButtonAction;
  final Function(bool, {required String source}) successPopUp;
  final bool? isAppBar;

  @override
  State<AddBankAccountPage> createState() => _AddBankAccountPageState();
}

class _AddBankAccountPageState extends State<AddBankAccountPage> {
  final TextEditingController searchTextField = TextEditingController();
  late bool isUserInOnBoardingState;
  // popping
  Future<bool> popScreen() async {
    if (searchTextField.text.isNotEmpty) {
      searchTextField.text = "";
      context.read<GetProvidersCubit>().searchData("", false);
      FocusManager.instance.primaryFocus?.unfocus();
      return false;
    } else {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
        return true;
      } else {
        return false;
      }
    }
  }

  String getCountryCode() {
    return locator<SharedPreferences>()
            .getString(RootApplicationAccess.countryOfResident) ??
        '';
  }

  bool isAssetAndLiabilityNotAdded =
      (RootApplicationAccess.assetsEntity?.summary.types == 0 ||
              RootApplicationAccess.assetsEntity?.summary.types == null) &&
          (RootApplicationAccess.liabilitiesEntity?.summary.types == 0 ||
              RootApplicationAccess.liabilitiesEntity?.summary.types == null);

  @override
  void initState() {
    context.read<GetProvidersCubit>().getData(getCountryCode());
    isUserInOnBoardingState = getIsUserInOnBoardingState();
    super.initState();
  }

  @override
  void dispose() {
    searchTextField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isUserInOnBoardingState
          ? null
          : widget.isAppBar ?? false
              ? wedgeAppBar(context: context, title: widget.title)
              : null,
      backgroundColor: appThemeColors!.bg,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: WillPopScope(
          onWillPop: () async {
            return popScreen();
          },
          child: BlocConsumer<GetProvidersCubit, GetProvidersState>(
            listener: (context, state) {
              if (state is GetProvidersError) {
                showSnackBar(context: context, title: state.errorMsg);
              }
            },
            builder: (context, state) {
              if (state is GetProvidersLoaded) {
                return GestureDetector(
                  onTap: () {
                    context.read<GetProvidersCubit>().searchData("", false);
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isUserInOnBoardingState
                          ? !isAssetAndLiabilityNotAdded
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0, left: 16.0),
                                  child: Text(
                                    '${translate?.add} ${translate?.account}',
                                    textAlign: TextAlign.left,
                                    style: TitleHelper.h8.copyWith(
                                        color: appThemeColors!.primary),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0, left: 16.0),
                                  child: Text(
                                    translate!.letsGetStarted,
                                    textAlign: TextAlign.left,
                                    style: TitleHelper.h8.copyWith(
                                        color: appThemeColors!.primary),
                                  ),
                                )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.subtitle != null
                                ? Text(
                                    widget.subtitle ?? '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: appThemeSubtitleFont,
                                        fontSize: appThemeSubtitleSizes!.h10),
                                  )
                                : const SizedBox(),
                            const SizedBox(height: 15),
                            TextField(
                              // onTap: () {},
                              controller: searchTextField,
                              onChanged: (val) {
                                if (val.isNotEmpty) {
                                  context
                                      .read<GetProvidersCubit>()
                                      .searchData(val, true);
                                } else {
                                  context
                                      .read<GetProvidersCubit>()
                                      .searchData(val, false);
                                }
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 12),
                                enabledBorder: ktextFeildOutlineInputBorder,
                                focusedBorder:
                                    ktextFeildOutlineInputBorderFocused,
                                border: ktextFeildOutlineInputBorder,
                                labelStyle: labelStyle.copyWith(
                                    fontFamily: appThemeSubtitleFont),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey[900],
                                ),
                                labelText: widget.placeholder,
                                prefixText: ' ',
                              ),
                            ),
                            //
                            Visibility(
                              visible: state.textFieldClicked,
                              child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 9.9,
                                          spreadRadius: 0.5),
                                    ],
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(kborderRadius)),
                                child: MediaQuery.removePadding(
                                  removeTop: true,
                                  removeBottom: true,
                                  context: context,
                                  child: state.searchData.records.isNotEmpty
                                      ? SizedBox(
                                          height:
                                              state.searchData.records.length >=
                                                      7
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.50
                                                  : null,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Column(
                                                  children: List.generate(
                                                      state.searchData.records
                                                          .length, (index) {
                                                    return Column(
                                                      children: [
                                                        ListTile(
                                                          visualDensity:
                                                              const VisualDensity(
                                                                  horizontal: 0,
                                                                  vertical: -4),
                                                          onTap: () {
                                                            cupertinoNavigator(
                                                              context: context,
                                                              screenName:
                                                                  YodleeFramePage(
                                                                providerName: state
                                                                    .searchData
                                                                    .records[
                                                                        index]
                                                                    .integrator,
                                                                successPopUpp: (_,
                                                                    {required String
                                                                        source}) {
                                                                  widget.successPopUp(
                                                                      _,
                                                                      source:
                                                                          source);
                                                                },
                                                                institutionId: state
                                                                    .searchData
                                                                    .records[
                                                                        index]
                                                                    .institutionId,
                                                                institutelogo: state
                                                                    .searchData
                                                                    .records[
                                                                        index]
                                                                    .logo,
                                                              ),
                                                              type:
                                                                  NavigatorType
                                                                      .PUSH,
                                                              then: (p0) {
                                                                context
                                                                    .read<
                                                                        GetProvidersCubit>()
                                                                    .searchData(
                                                                        '',
                                                                        false);
                                                                searchTextField
                                                                    .clear();
                                                              },
                                                            );
                                                          },
                                                          subtitle: Text(
                                                            state
                                                                .searchData
                                                                .records[index]
                                                                .country,
                                                            style: TextStyle(
                                                                color:
                                                                    appThemeColors!
                                                                        .textDark,
                                                                fontFamily:
                                                                    appThemeSubtitleFont),
                                                          ),
                                                          title: Text(
                                                              state
                                                                  .searchData
                                                                  .records[
                                                                      index]
                                                                  .institution,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      appThemeSubtitleFont,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                        ),
                                                        state.searchData.records
                                                                        .length -
                                                                    1 ==
                                                                index
                                                            ? Container()
                                                            : const Divider()
                                                      ],
                                                    );
                                                  }),
                                                ),
                                                ListTile(
                                                    title: Row(
                                                  children: [
                                                    Text(
                                                      translate!.notListed,
                                                      style: SubtitleHelper.h10,
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          widget
                                                              .manualAddButtonAction();
                                                        },
                                                        child: Text(
                                                          translate!
                                                              .addManually,
                                                          style: TitleHelper.h10
                                                              .copyWith(
                                                            color:
                                                                appThemeColors!
                                                                    .outline,
                                                          ),
                                                        ))
                                                  ],
                                                )),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Column(
                                          children: [
                                            ListTile(
                                              title: Row(
                                                children: [
                                                  Text(
                                                    translate!.notListed,
                                                    style: SubtitleHelper.h10,
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      widget
                                                          .manualAddButtonAction();
                                                    },
                                                    child: Text(
                                                      translate!.addManually,
                                                      style: TitleHelper.h10
                                                          .copyWith(
                                                        color: appThemeColors!
                                                            .outline,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: BankListContent(
                                successPopUps: (_, {required String source}) {
                                  try {
                                    widget.successPopUp(_, source: source);
                                  } catch (e) {
                                    // print(e.toString());
                                  }
                                },
                                providers: state.data.records,
                              ),
                            ),
                            const SizedBox(height: 35),
                          ],
                        ),
                      ),
                      Container(
                        // height: 170,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(.5),
                              blurRadius: 5.0,
                              spreadRadius: 2.0,
                              offset: const Offset(1.0, 0.0),
                            ),
                          ],
                        ),
                        width: double.infinity,
                        child: FooterButton(
                          text: widget.manualAddButtonTitle,
                          onTap: () {
                            widget.manualAddButtonAction();
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is GetProvidersLoading) {
                return Center(
                  child: buildCircularProgressIndicator(width: 200),
                );
              } else if (state is GetProvidersError) {
                return Center(
                  child: Text(
                    state.errorMsg,
                    style: TextStyle(fontFamily: appThemeSubtitleFont),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
