import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/mortgages_entity.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/add_new_button.dart';
import 'package:wedge/core/widgets/buttons/bottom_nav_single_button_container.dart';
import 'package:wedge/core/widgets/buttons/wedge_button.dart';
import 'package:wedge/features/assets/vehicle/vehicle_main/presentation/bloc/cubit/vehicles_cubit.dart';
import 'package:wedge/features/liabilities/mortgages/add_mortgages/presentation/pages/add_mortgages_page.dart';
import 'package:wedge/features/liabilities/mortgages/mortgages_main/presentation/cubit/mortage_main_cubit.dart';

class MortgagesListPage extends StatefulWidget {
  List<dynamic>? mortgages = [];

  MortgagesListPage({Key? key, this.mortgages}) : super(key: key);

  @override
  _MortgagesListPageState createState() => _MortgagesListPageState();
}

class _MortgagesListPageState extends State<MortgagesListPage> {
  bool isChecked = false;
  List<MortgagesEntity> properties = [];

  selectProperty(MortgagesEntity propertyEntity) {
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
        appBar: wedgeAppBar(context: context, title: ADD_MORTGAGE),
        body: BlocConsumer<MortageMainCubit, MortageMainState>(
          bloc: context.read<MortageMainCubit>().getMortgages(context),
          listener: (context, state) {
            if (state is MortageMainError) {
              showSnackBar(context: context, title: state.errorMsg);
            }
          },
          builder: (context, state) {
            if (state is MortageMainLoaded) {
              if (widget.mortgages != null) {
                widget.mortgages!.forEach((element) {
                  state.liabilitiesEntity.mortgages
                      .removeWhere((e) => e.id == element.id);
                });
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Click on the mortgages you would like to associate this property with or add a new mortgage.",
                            style: SubtitleHelper.h11.copyWith(
                                color: appThemeColors!.disableText,
                                height: 1.7)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  state.liabilitiesEntity.mortgages.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Text(
                                "Looks like you have already added all the mortgages",
                                style: SubtitleHelper.h11),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                              itemCount:
                                  state.liabilitiesEntity.mortgages.length,
                              itemBuilder: (con, index) {
                                final MortgagesEntity data =
                                    state.liabilitiesEntity.mortgages[index];
                                bool isChecked = properties
                                    .where((element) => element.id == data.id)
                                    .toList()
                                    .isNotEmpty;
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 8),
                                      child: GestureDetector(
                                        onTap: () {
                                          selectProperty(data);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 9.9,
                                                  spreadRadius: 0.5),
                                            ],
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(15.0),
                                            // margin: const EdgeInsets.all(15.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  // flex: 2,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                                                Text(
                                                                  data.provider,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: SubtitleHelper
                                                                      .h11
                                                                      .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Container(
                                                                  width: 130,
                                                                  child: Text(
                                                                    data.country,
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
                                                // Spacer(),
                                                Expanded(
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "${data.outstandingAmount.currency} ${numberFormat.format(data.outstandingAmount.amount)}",
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.end,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: SubtitleHelper
                                                              .h11
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          "Current outstanding",
                                                          style: SubtitleHelper
                                                              .h11
                                                              .copyWith(
                                                                  color: appThemeColors!
                                                                      .disableText),
                                                        )
                                                      ]),
                                                ),
                                                Container(
                                                  width: 50,
                                                  child: Checkbox(
                                                    checkColor: Colors.white,
                                                    activeColor: kgreen,
                                                    value: isChecked,
                                                    onChanged: (bool? value) {
                                                      selectProperty(data);
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              })),
                  // AddMoreTextButton(
                  //   page: AddMortgagesListPage(),
                  // ),
                  AddNewButton(
                      text: "Add more mortgages",
                      onTap: () async {
                        var stocksData = await Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    AddMortgagesPage(
                                      mortgages: const [],
                                      hideAddMore: true,
                                    )));
                        if (stocksData != null) {
                          context
                              .read<MortageMainCubit>()
                              .getMortgages(context);
                        }
                      }),
                  const SizedBox(
                    height: 20,
                  )
                ],
              );
            } else if (state is VehiclesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is VehiclesError) {
              return const Center(
                child: Text("Something went wrong"),
              );
            } else {
              return Container();
            }
          },
        ),
        bottomNavigationBar: BottomNavSingleButtonContainer(
            child: WedgeSaveButton(
                onPressed: () {
                  pop();
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                title: "Save",
                isLoaing: false)));
  }
}
