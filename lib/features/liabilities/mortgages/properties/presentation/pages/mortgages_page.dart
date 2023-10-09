import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/property_entity.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/widgets/buttons/add_new_button.dart';
import 'package:wedge/core/widgets/buttons/bottom_nav_single_button_container.dart';
import 'package:wedge/core/widgets/buttons/wedge_button.dart';
import 'package:wedge/features/assets/properties/add_properties/presentation/pages/add_property_page.dart';
import 'package:wedge/features/assets/properties/properties_main/presentation/bloc/cubit/properties_cubit.dart';

class MortgageAddProperties extends StatefulWidget {
  final List<dynamic> propertiesData;

  MortgageAddProperties({Key? key, required this.propertiesData})
      : super(key: key);

  @override
  _MortgageAddPropertiesState createState() => _MortgageAddPropertiesState();
}

class _MortgageAddPropertiesState extends State<MortgageAddProperties> {
  bool isChecked = false;

  List<PropertyEntity> properties = [];

  selectProperty(PropertyEntity propertyEntity) {
    setState(() {
      if (properties
          .where((element) => element.id == propertyEntity.id)
          .toList()
          .isNotEmpty) {
        properties.removeWhere((element) => element.id == propertyEntity.id);
      } else {
        properties.add(propertyEntity);
      }
    });
  }

  pop() {
    Navigator.pop(context, properties);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appThemeColors!.bg,
        appBar: wedgeAppBar(context: context, title: ADD_PROPERTY),
        body: Column(
          children: [
            Container(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Click on the properties you would like to associate this mortgage with or add a new property.",
                      style: SubtitleHelper.h11.copyWith(
                          color: appThemeColors!.disableText, height: 1.7)),
                ],
              ),
            )),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: BlocConsumer<PropertiesCubit, PropertiesState>(
                bloc: context.read<PropertiesCubit>().getData(),
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is PropertiesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is PropertiesLoaded) {
                    state.assets.properties.removeWhere((element) {
                      return widget.propertiesData
                          .where((e) => e.id == element.id)
                          .toList()
                          .isNotEmpty;
                    });
                    return state.assets.properties.isEmpty
                        ? Center(
                            child: Text(
                                "Looks like you have already added all the properties",
                                style: SubtitleHelper.h11),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.assets.properties.length,
                            itemBuilder: (context, index) {
                              final PropertyEntity data =
                                  state.assets.properties[index];
                              bool isChecked = properties
                                  .where((element) => element.id == data.id)
                                  .toList()
                                  .isNotEmpty;
                              return Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 15),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: [
                                          const BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 9.9,
                                              spreadRadius: 0.5),
                                        ],
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          selectProperty(data);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(15.0),
                                          // margin: const EdgeInsets.all(15.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${index + 1}",
                                                          style: SubtitleHelper
                                                              .h10
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                // width: 130,
                                                                child: Text(
                                                                  "${data.name}",
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: SubtitleHelper
                                                                      .h10
                                                                      .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Container(
                                                                // width: 130,
                                                                // color: Colors.red,
                                                                child: Text(
                                                                  "${data.country}",
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: SubtitleHelper
                                                                      .h11
                                                                      .copyWith(
                                                                          color:
                                                                              appThemeColors!.disableText),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      // width: 120,
                                                      child: Text(
                                                        "${data.currentValue.currency} ${data.currentValue.amount}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: SubtitleHelper
                                                            .h10
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text("Current value",
                                                        style: SubtitleHelper
                                                            .h11
                                                            .copyWith(
                                                                color: appThemeColors!
                                                                    .disableText))
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 50,
                                                child: Checkbox(
                                                  checkColor: Colors.white,
                                                  activeColor: lighten(
                                                      appThemeColors!.primary ??
                                                          Colors.green,
                                                      .3),
                                                  // focusColor: Colors.red,
                                                  // fillColor:
                                                  //     MaterialStateProperty.all(kgreen),
                                                  value: isChecked,
                                                  onChanged: (bool? value) {
                                                    selectProperty(data);
                                                    // setState(() {
                                                    //   isChecked = value!;
                                                    // });
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),

                                      // child: ListTile(
                                      //   onTap: () {
                                      //     if (isChecked) {
                                      //       setState(() {
                                      //         isChecked = false;
                                      //       });
                                      //     } else {
                                      //       setState(() {
                                      //         isChecked = true;
                                      //       });
                                      //     }
                                      //   },
                                      //   title: Text(
                                      //     "${data.name}",
                                      //   ),
                                      //   subtitle: Text("${data.country}"),
                                      //   trailing: SizedBox(
                                      //     width: 120,
                                      //     child: Row(
                                      //       children: [
                                      //         Column(
                                      //           crossAxisAlignment:
                                      //               CrossAxisAlignment.end,
                                      //           mainAxisAlignment:
                                      //               MainAxisAlignment.center,
                                      //           children: [
                                      //             Text(
                                      //               "${data.currentValue.amount}",
                                      //               style: TextStyle(
                                      //                   fontSize: kfontMedium,
                                      //                   fontWeight: FontWeight.w600),
                                      //             ),
                                      //             Text("value")
                                      //           ],
                                      //         ),
                                      //         Checkbox(
                                      //           checkColor: Colors.white,
                                      //           fillColor: MaterialStateProperty.all(
                                      //               Colors.blue),
                                      //           value: isChecked,
                                      //           onChanged: (bool? value) {
                                      //             setState(() {
                                      //               isChecked = value!;
                                      //             });
                                      //           },
                                      //         )
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                    ),
                                  ),
                                ],
                              );
                            },

                            // AddMoreTextButton(
                            //   page: AddPropertyePage(),
                            // )
                          );
                  } else if (state is PropertiesError) {
                    return Center(
                      child: Text(
                        "Something went wrong!",
                        style: SubtitleHelper.h11,
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
            AddNewButton(
              text: "Add more properties",
              onTap: () async {
                dynamic data;

                data = await Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (BuildContext context) => AddPropertyPage(
                              hideAddMore: true,
                            )
                        // AddBankAccountPage()
                        ));

                if (data != null) {
                  context.read<PropertiesCubit>().getData();
                }
              },
            )
          ],
        ),
        bottomNavigationBar: BottomNavSingleButtonContainer(
            child: WedgeSaveButton(
                onPressed: () {
                  pop();
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                title: "Add",
                isLoaing: false)));
  }
}
