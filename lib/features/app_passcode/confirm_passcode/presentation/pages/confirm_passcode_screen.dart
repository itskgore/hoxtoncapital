import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/data_models/theme_model.dart';
import 'package:wedge/core/helpers/biometrics_auth.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/features/app_passcode/confirm_passcode/presentation/cubit/confirm_passcode_cubit.dart';

class ConfirmPasscodeScreen extends StatefulWidget {
  final String email;
  final bool? isFromSplash;
  final bool shouldShowBioMetric;
  final String userData;

  const ConfirmPasscodeScreen(
      {Key? key,
      required this.email,
      required this.shouldShowBioMetric,
      this.isFromSplash,
      required this.userData})
      : super(key: key);

  @override
  _ConfirmPasscodeScreenState createState() => _ConfirmPasscodeScreenState();
}

class _ConfirmPasscodeScreenState extends State<ConfirmPasscodeScreen> {
  ConfirmPasscodeCubit getBloc() => context.read<ConfirmPasscodeCubit>();

  List<String> passcode = [];
  int passCodeLength = 4;
  bool isConfirmPasscode = false;

  @override
  void initState() {
    getBloc().emit(ConfirmPasscodeInitial());
    super.initState();
  }

  addPasscode({required dynamic number, required bool isRemove}) {
    setState(() {
      if (isRemove) {
        passcode.removeLast();
      } else {
        passcode.add(number.toString());
      }
    });
  }

  onDone(Map<String, dynamic> data) {
    if (data['no'] == '<-') {
      addPasscode(number: data['no'], isRemove: true);
    } else if (data['no'] == "Done" || passcode.length == passCodeLength) {
      // log("Submit confirm");
      confirmPasscode();
    } else if (data['actions'] == "yes") {
      addPasscode(number: data['no'], isRemove: true);
    } else if (data['no'] == "Done" && passcode.length != passCodeLength) {
      showSnackBar(context: context, title: "Please enter passcode!");
    } else {
      if (passcode.length == passCodeLength) {
        // log("Submit confirm");
        confirmPasscode();
      } else {
        addPasscode(number: data['no'], isRemove: !data.containsKey("no"));
        if (passcode.length == passCodeLength) {
          // log("Submit confirm");
          confirmPasscode();
        }
      }
    }
  }

  confirmPasscode() {
    if (passcode.length == passCodeLength) {
      context.read<ConfirmPasscodeCubit>().confirmPasscode(
          widget.email, "", false,
          isOTPVerified: false,
          fromSplash: widget.isFromSplash ?? false,
          context: context,
          passcode: passcode.join(""));
    } else {
      showSnackBar(context: context, title: "Incorrect Passcode");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // height: popHeight,
        alignment: Alignment.bottomCenter,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        child: BlocConsumer<ConfirmPasscodeCubit, ConfirmPasscodeState>(
          listener: (context, state) {
            if (state is ConfirmPasscodeLoaded) {
              Future.delayed(const Duration(milliseconds: 300), () {
                if (widget.isFromSplash ?? false) {
                } else {
                  Navigator.pop(context);
                }
              });
            } else if (state is ConfirmPasscodeError) {
              // showSnackBar(context: context, title: state.errorMsg);
              setState(() {
                passcode.clear();
              });
            }
          },
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    flex: 0,
                    child: Container(
                      child: Column(
                        children: [
                          widget.shouldShowBioMetric
                              ? GestureDetector(
                                  onTap: () {
                                    BioMetricsAuth()
                                        .bioMetricsLogin(widget.userData);
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Text(
                                        translate!.tapToLoginWithBiometrics,
                                        style: SubtitleHelper.h11.copyWith(
                                            color: appThemeColors!.primary),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      SvgPicture.asset(
                                        BioMetricsAuth
                                            .biometricTypeImagePasscode,
                                        width: 40,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Divider(
                                        height: 1,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: widget.shouldShowBioMetric
                        ? size.height * 0.01
                        : size.height * 0.045,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      // color: Colors.blue,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                translate!.enterFourDigitPasscode(
                                    appTheme.clientName.toString()),
                                style: TitleHelper.h11.copyWith(
                                    color: appThemeColors!.textDark,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: widget.shouldShowBioMetric
                                ? size.height * 0.03
                                : size.height * 0.045,
                          ),
                          ShakeWidget(
                            key: state is ConfirmPasscodeError
                                ? UniqueKey()
                                : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(passCodeLength, (index) {
                                var passcodeBorderSelected = Border.all(
                                    color: appThemeColors!.primary!, width: 3);
                                var passcodeBorderUnselected = Border.all(
                                    color: appThemeColors!.primary!
                                        .withOpacity(0.15),
                                    width: 0);
                                var passcodeErrorBorderUnselected = Border.all(
                                    color: HexColor("#C4161C"), width: 2);
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: size.height * 0.03,
                                  height: size.height * 0.03,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: state is ConfirmPasscodeError
                                        ? passcodeErrorBorderUnselected
                                        : passcode.asMap().containsKey(index)
                                            ? passcodeBorderSelected
                                            : passcodeBorderUnselected,
                                    color: state is ConfirmPasscodeError
                                        ? HexColor("#C4161C")
                                        : passcode.asMap().containsKey(index)
                                            ? appThemeColors!.primary!
                                            : appThemeColors!.primary!
                                                .withOpacity(0.15),
                                  ),
                                );
                              }),
                            ),
                          ),
                          state is ConfirmPasscodeError
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        state.errorMsg,
                                        textAlign: TextAlign.center,
                                        style: TitleHelper.h12.copyWith(
                                          color: HexColor("#C4161C"),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(
                            height: 20,
                          ),
                          // TODO: FOR WEDGE LOGIC
                          state is ConfirmPasscodeError
                              ? const SizedBox.shrink()
                              : Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        RootApplicationAccess().navigateToLogin(
                                            context,
                                            forMPin: true,
                                            createNew: true);
                                      },
                                      child: Text(
                                        translate!.forgotYourPasscode(
                                            appTheme.clientName.toString()),
                                        style: isSmallDevice(context)
                                            ? SubtitleHelper.h12.copyWith(
                                                color: Colors.grey,
                                                letterSpacing: 0.8,
                                              )
                                            : SubtitleHelper.h11.copyWith(
                                                color: Colors.grey,
                                                letterSpacing: 0.8,
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: isSmallDevice(context) ? 8 : 16,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        RootApplicationAccess().navigateToLogin(
                                            context,
                                            navigatorType:
                                                NavigatorType.PUSHREMOVEUNTIL,
                                            fromLoginViaEmailButton: true);
                                      },
                                      child: Text(
                                        translate!.usePassword,
                                        style: isSmallDevice(context)
                                            ? TitleHelper.h12.copyWith(
                                                letterSpacing: 0.8,
                                                fontWeight: FontWeight.w500)
                                            : TitleHelper.h11.copyWith(
                                                letterSpacing: 0.8,
                                                fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          widget.shouldShowBioMetric ? 0 : 0,
                                    ),
                                  ],
                                )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      // color: Colors.amber,
                      child: Column(
                        children: [
                          state is ConfirmPasscodeLoading
                              ? passcodeLoader()
                              : GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: getBloc().numbers.length,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical:
                                          isSmallDevice(context) ? 10 : 15),
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing:
                                              isSmallDevice(context) ? 0 : 10,
                                          childAspectRatio: 1.8,
                                          crossAxisCount: 3),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        if (getBloc().numbers[index]['no'] !=
                                            "Done") {
                                          onDone(getBloc().numbers[index]);
                                        }
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: InkWell(
                                            child: getBloc().numbers[index]
                                                        ['no'] ==
                                                    "<-"
                                                ? Icon(
                                                    Icons.arrow_back,
                                                    color: appThemeColors!
                                                        .textDark,
                                                  )
                                                : Text(
                                                    "${getBloc().numbers[index]['no'] == "Done" ? "" : getBloc().numbers[index]['no']}",
                                                    style: TitleHelper.h5
                                                        .copyWith(
                                                            color:
                                                                appThemeColors!
                                                                    .textDark),
                                                  ),
                                          )),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

@immutable
class ShakeWidget extends StatelessWidget {
  final Duration duration;
  final double deltaX;
  final Widget child;
  final Curve curve;

  const ShakeWidget({
    Key? key,
    this.duration = const Duration(milliseconds: 500),
    this.deltaX = 20,
    this.curve = Curves.bounceOut,
    required this.child,
  }) : super(key: key);

  /// convert 0-1 to 0-1-0
  double shake(double animation) =>
      2 * (0.5 - (0.5 - curve.transform(animation)).abs());

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      builder: (context, animation, child) => Transform.translate(
        offset: Offset(deltaX * shake(animation), 0),
        child: child,
      ),
      child: child,
    );
  }
}
