import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shimmer/shimmer.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/features/app_passcode/create_passcode/presentation/cubit/create_passcode_cubit.dart';

class CreatePasscodeScreen extends StatefulWidget {
  final bool showBackButton;
  final bool isFromSplash;
  Function()? onSubmit;

  CreatePasscodeScreen(
      {Key? key,
      required this.showBackButton,
      required this.isFromSplash,
      this.onSubmit})
      : super(key: key);

  @override
  _CreatePasscodeScreenState createState() => _CreatePasscodeScreenState();
}

class _CreatePasscodeScreenState extends State<CreatePasscodeScreen> {
  CreatePasscodeCubit getBloc() => context.read<CreatePasscodeCubit>();

  List<String> passcode = [];
  List<String> confirmPasscode = [];
  int passCodeLength = 4;
  bool isConfirmPasscode = false;

  addPasscode({required dynamic number, required bool isRemove}) {
    setState(() {
      if (isRemove) {
        if (isConfirmPasscode) {
          confirmPasscode.removeLast();
        } else {
          passcode.removeLast();
        }
      } else {
        if (isConfirmPasscode) {
          confirmPasscode.add(number.toString());
        } else {
          passcode.add(number.toString());
        }
      }
    });
  }

  switchToConfirmPasscode() {
    setState(() {
      isConfirmPasscode = !isConfirmPasscode;
      if (!isConfirmPasscode) {
        confirmPasscode.clear();
        passcode.clear();
      }
    });
  }

  createPasscode() {
    Function eq = const ListEquality().equals;
    if (eq(confirmPasscode, passcode)) {
      getBloc().createPasscode({
        "passCode": passcode.join(""),
        "confirmedPasscode": passcode.join(""),
      });
    } else {
      setState(() {
        confirmPasscode.clear();
      });
      showSnackBar(context: context, title: "Passcode does not match");
    }
  }

  onDone(Map<String, dynamic> data) {
    if (isConfirmPasscode) {
      if (data['no'] == '<-') {
        addPasscode(number: data['no'], isRemove: true);
      } else if (data['no'] == "Done" ||
          confirmPasscode.length == passCodeLength) {
        // log("Submit confirm");
        createPasscode();
      } else if (data['actions'] == "yes") {
        addPasscode(number: data['no'], isRemove: true);
      } else if (data['no'] == "Done" &&
          confirmPasscode.length != passCodeLength) {
        showSnackBar(context: context, title: "Please enter passcode!");
      } else {
        if (confirmPasscode.length == passCodeLength) {
          // log("Submit confirm");
          createPasscode();
        } else {
          addPasscode(number: data['no'], isRemove: !data.containsKey("no"));
          if (confirmPasscode.length == passCodeLength) {
            // log("Submit confirm");
            createPasscode();
          }
        }
      }
    } else {
      if (data['no'] == "Done" && passcode.length == passCodeLength) {
        switchToConfirmPasscode();
      } else if (data['actions'] == "yes") {
        addPasscode(number: data['no'], isRemove: true);
      } else if (data['no'] == "Done" && passcode.length != passCodeLength) {
        showSnackBar(context: context, title: "Please enter passcode!");
      } else {
        if (passcode.length == passCodeLength) {
          switchToConfirmPasscode();
        } else {
          addPasscode(number: data['no'], isRemove: !data.containsKey("no"));
          if (passcode.length == passCodeLength) {
            switchToConfirmPasscode();
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: BlocConsumer<CreatePasscodeCubit, CreatePasscodeState>(
          listener: (context, state) {
            if (state is CreatePasscodeLoaded) {
              showSnackBar(context: context, title: "New passcode created");
              Future.delayed(const Duration(seconds: 1), () {
                if (!widget.isFromSplash) {
                  Navigator.of(context).pop();
                }
                if (widget.onSubmit != null) {
                  widget.onSubmit!();
                }
              });
            } else if (state is CreatePasscodeError) {
              showSnackBar(context: context, title: state.errorMsg);
            }
          },
          builder: (context, state) {
            return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isConfirmPasscode
                                ? GestureDetector(
                                    onTap: () {
                                      switchToConfirmPasscode();
                                    },
                                    child: const Icon(
                                      Icons.arrow_back_ios,
                                      size: 15,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              isConfirmPasscode
                                  ? "Confirm the passcode"
                                  : "Create a new passcode",
                              style: TitleHelper.h10,
                            ),
                          ],
                        ),
                      ),
                      // Spacer(),
                      state is CreatePasscodeLoading || !widget.showBackButton
                          ? const SizedBox.shrink()
                          : GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.close),
                            )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "The passcode will help you to keep your data private",
                    style: SubtitleHelper.h12,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(passCodeLength, (index) {
                      var passcodeBorderSelected =
                          Border.all(color: appThemeColors!.primary!, width: 3);
                      var passcodeBorderUnselected =
                          Border.all(color: appThemeColors!.primary!, width: 2);
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 18,
                        height: 18,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: isConfirmPasscode
                              ? confirmPasscode.asMap().containsKey(index)
                                  ? passcodeBorderSelected
                                  : passcodeBorderUnselected
                              : passcode.asMap().containsKey(index)
                                  ? passcodeBorderSelected
                                  : passcodeBorderUnselected,
                          color: isConfirmPasscode
                              ? confirmPasscode.asMap().containsKey(index)
                                  ? appThemeColors!.primary!
                                  : appThemeColors!.textLight!
                              : passcode.asMap().containsKey(index)
                                  ? appThemeColors!.primary!
                                  : appThemeColors!.textLight!,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  state is CreatePasscodeLoading
                      ? passcodeLoader()
                      : Expanded(
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: getBloc().numbers.length,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 1.7,
                                    crossAxisCount: 3),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  onDone(getBloc().numbers[index]);
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(6)),
                                    child: InkWell(
                                      child: Text(
                                        "${getBloc().numbers[index]['no']}",
                                        style: TitleHelper.h8,
                                      ),
                                    )),
                              );
                            },
                          ),
                        ),
                ]));
          },
        ),
      ),
    );
  }
}
