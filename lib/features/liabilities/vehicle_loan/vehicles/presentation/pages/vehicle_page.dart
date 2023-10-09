import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/vehicle_entity.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/widgets/buttons/add_new_button.dart';
import 'package:wedge/features/assets/vehicle/add_vehicle/presentation/pages/add_vehicle_manual_page.dart';
import 'package:wedge/features/assets/vehicle/vehicle_main/presentation/bloc/cubit/vehicles_cubit.dart';

class VehiclePage extends StatefulWidget {
  const VehiclePage({Key? key}) : super(key: key);

  @override
  _VehiclePageState createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  bool isChecked = false;
  AppLocalizations? translate;

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);
    return Scaffold(
      backgroundColor: appThemeColors!.bg,
      appBar: wedgeAppBar(context: context, title: ADD_VEHICLE),
      body: BlocBuilder<VehiclesCubit, VehiclesState>(
        bloc: context.read<VehiclesCubit>().getData(),
        builder: (context, state) {
          if (state is VehiclesLoaded) {
            state.assets.vehicles.removeWhere((element) => element.hasLoan);
            return Column(
              children: [
                Container(
                    child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate!.vehiclesYouHaveAdded,
                        style: TitleHelper.h10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        translate!.clickTheVehicleMessage,
                        style: SubtitleHelper.h11.copyWith(height: 1.7),
                      ),
                    ],
                  ),
                )),
                //Vehicles you’ve added
                //Click on the vehicle you would like to associate this loan with or add a new vehicle.
                //Add more vehicle
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.assets.vehicles.length,
                      itemBuilder: (con, index) {
                        final VehicleEntity data = state.assets.vehicles[index];
                        return Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context, data);
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 9.9,
                                          spreadRadius: 0.5),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(22.0),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${index + 1}",
                                                    style: TitleHelper.h10,
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(data.name,
                                                          style:
                                                              TitleHelper.h10),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(data.country,
                                                          style: SubtitleHelper
                                                              .h11),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                    "${data.value.currency} ${numberFormat.format(data.value.amount)}",
                                                    style: TitleHelper.h10),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  translate!.currentValue,
                                                  style: SubtitleHelper.h11,
                                                ),
                                              ]),
                                        ]),
                                  )),
                            ),
                          ),
                        ]);
                      }),
                ),
                AddNewButton(
                    text: translate!.addMoreVehicle,
                    onTap: () async {
                      var stocksData = await Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  AddVehicleManualPage(
                                    hideShowMore: true,
                                  )));
                      if (stocksData != null) {
                        context.read<VehiclesCubit>().getData();
                      }
                    }),
                const SizedBox(
                  height: 30,
                )
              ],
            );
          } else if (state is VehiclesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is VehiclesError) {
            return Center(
              child: Text(state.errorMsg),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
