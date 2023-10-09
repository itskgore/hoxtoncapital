import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/support/presentation/cubit/support_account_cubit.dart';

class SupportAccount extends StatefulWidget {
  const SupportAccount({Key? key}) : super(key: key);

  @override
  State<SupportAccount> createState() => _SupportAccountState();
}

class _SupportAccountState extends State<SupportAccount> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _message = TextEditingController();

  Future<void> submitData(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<SupportAccountCubit>(context)
          .addSupport({"message": _message.text, "attachments": attachments});
    }
  }

  List<String> attachments = [];

  imagePicker(BuildContext context, {int? indexToBeAddedFrom}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile?>? image;
      image = await picker.pickMultiImage(
          imageQuality: 20, maxWidth: 500, maxHeight: 800);
      if (image.isNotEmpty) {
        if (indexToBeAddedFrom != null) {
          int remainingImagesCount = 2 - indexToBeAddedFrom;
          if (image.length <= remainingImagesCount) {
            for (var element in image) {
              Uint8List bytes = File(element!.path).readAsBytesSync();
              setState(() {
                attachments.add("data:image/png;base64,${base64Encode(bytes)}");
              });
            }
          } else {
            showSnackBar(
                context: context,
                title: translate!.youCanUploadMaxThreeScreenshots);
          }
        } else {
          if (image.isNotEmpty && image.length <= 3) {
            for (var element in image) {
              final validateSize =
                  File(element!.path).readAsBytesSync().lengthInBytes;
              Uint8List bytes = File(element.path).readAsBytesSync();
              setState(() {
                attachments.add("data:image/png;base64,${base64Encode(bytes)}");
              });
            }
          } else {
            showSnackBar(
                context: context,
                title: translate!.youCanUploadMaxThreeScreenshots);
          }
        }
      } else {
        showSnackBar(
            context: context, title: translate!.pleaseUploadTheScreenshots);
      }
    } catch (e) {
      if (e.toString().toLowerCase() ==
          "PlatformException(photo_access_denied, The user did not allow photo access., null, null)"
              .toLowerCase()) {
        requestAccess(context);
      }
    }
  }

  removeImage(int index) {
    setState(() {
      attachments.removeAt(index);
    });
  }

  Uint8List coverToMemoryImage(String image) {
    return base64Decode(image.replaceAll("data:image/png;base64,", ""));
  }

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: appThemeColors!.bg,
      appBar: wedgeAppBar(
        context: context,
        title: translate!.support,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 40,
            ),
            Image.asset(
              "${appIcons.supportPaths!.supportBanner}",
              // width: 100,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              translate!.supportDescription,
              style:
                  TextStyle(fontSize: appThemeHeadlineSizes!.h10, height: 1.5),
            ),
            const SizedBox(
              height: 30,
            ),
            Form(
                key: _formKey,
                child: TextFormField(
                    maxLines: 08,
                    maxLength: 250,
                    controller: _message,
                    validator: (_) {
                      if (_!.trim().isEmpty) {
                        return translate!.supportMsgValidation;
                      }
                    },
                    decoration: InputDecoration(
                        counterText: '',
                        fillColor: appThemeColors!.textLight,
                        filled: true,
                        hintText: translate!.supportMsgPlaceholder,
                        hintStyle: const TextStyle(color: Color(0xfffd6d6d6)),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: ktextfeildBorderRadius,
                            borderSide: BorderSide(color: Color(0xfffd6d6d6))),
                        border: const OutlineInputBorder(
                            borderRadius: ktextfeildBorderRadius,
                            borderSide: BorderSide(color: Color(0xfffd6d6d6)))),
                    keyboardType: TextInputType.multiline)),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    translate!.attachScreenshotTitle,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: appThemeHeadlineSizes!.h10, height: 1.5),
                  ),
                ),
                attachments.isEmpty || attachments.length == 3
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          // onTap();
                          imagePicker(context,
                              indexToBeAddedFrom: attachments.length - 1);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xfffeaebe1),
                                borderRadius: BorderRadius.circular(4.0)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Center(
                                  child: Text(
                                translate!.add,
                                style: TextStyle(
                                    fontSize: appThemeHeadlineSizes!.h12),
                              )),
                            )),
                      )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: attachments.isEmpty
                  ? GestureDetector(
                      onTap: () {
                        imagePicker(context);
                      },
                      child: Container(
                        width: 55,
                        height: 90,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 3,
                                blurRadius: 9,
                                offset: const Offset(
                                    0, 5), // changes position of shadow
                              ),
                            ],
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : Row(
                      children: List.generate(attachments.length, (index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 15),
                                width: 60,
                                height: 100,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 3,
                                      blurRadius: 9,
                                      offset: const Offset(
                                          0, 5), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: MemoryImage(
                                        coverToMemoryImage(attachments[index])),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 9,
                                top: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    removeImage(index);
                                  },
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.grey[300],
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                    ),
            ),
            const SizedBox(
              height: 30,
            ),
            BlocConsumer<SupportAccountCubit, SupportAccountState>(
              listener: (context, state) {
                if (state is SupportAccountLoaded) {
                  if (state.status) {
                    // success
                    _message.text = '';
                    locator.get<WedgeDialog>().success(
                        context: context,
                        info: "",
                        title: translate!.supportSuccessDiscrip,
                        onClicked: () {
                          FocusScope.of(context).requestFocus(FocusNode());

                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                  } else {
                    // failure
                    showSnackBar(context: context, title: state.message);
                  }
                } else if (state is SupportAccountError) {
                  showSnackBar(context: context, title: state.errorMsg);
                }
              },
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: appThemeColors!.primary,
                        shape: const RoundedRectangleBorder(
                            borderRadius: ktextfeildBorderRadius)),
                    onPressed: state is SupportAccountLoading
                        ? null
                        : () {
                            if (WidgetsBinding
                                    .instance.window.viewInsets.bottom >
                                0.0) {
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                            }

                            submitData(context);
                          },
                    child: state is SupportAccountLoading
                        ? buildCircularProgressIndicator()
                        : Text(
                            translate!.send,
                            style: TextStyle(
                                fontSize: appThemeHeadlineSizes!.h10,
                                color: appThemeColors!.textLight),
                          ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 30,
            ),
          ]),
        ),
      )),
    );
  }
}
