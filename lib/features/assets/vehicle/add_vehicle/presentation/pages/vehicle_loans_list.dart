import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/vehicle_entity.dart';
import 'package:wedge/core/entities/vehicles_loans_entity.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/add_new_button.dart';
import 'package:wedge/features/assets/vehicle/vehicle_main/presentation/bloc/cubit/vehicles_cubit.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/presentation/pages/add_vehicle_loan_page.dart';
import 'package:wedge/features/liabilities/vehicle_loan/vehicle_loan_main/presentation/cubit/main_vehicle_loans_cubit.dart';

class VehicleLoanPage extends StatefulWidget {
  VehicleLoanPage({Key? key}) : super(key: key);

  @override
  _VehicleLoanPageState createState() => _VehicleLoanPageState();
}

class _VehicleLoanPageState extends State<VehicleLoanPage> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);

    return Scaffold(
      backgroundColor: appThemeColors!.bg,
      appBar: wedgeAppBar(context: context, title: translate!.addVehicleLoan),
      body: BlocConsumer<MainVehicleLoansCubit, MainVehicleLoansState>(
        bloc: context.read<MainVehicleLoansCubit>().getVehicleLoans(),
        listener: (context, state) {
          if (state is MainVehicleLoansError) {
            showSnackBar(context: context, title: state.errorMsg);
          }
        },
        builder: (context, state) {
          if (state is MainVehicleLoansLoaded) {
            // const vehicles = state.liabilitiesEntity.vehicleLoans.filter(v => v.vehicleLoans.find(o => o.id === VehicleLoanDetail.id))
            List<VehicleEntity> vehicles = RootApplicationAccess
                    .assetsEntity?.vehicles
                    .where((element) => element.vehicleLoans.isNotEmpty)
                    .toList() ??
                [];
            vehicles.forEach((element) {
              element.vehicleLoans.forEach((veh) {
                state.liabilitiesEntity.vehicleLoans
                    .removeWhere((loans) => loans.id == veh.id);
              });
            });
            final numFormatter = NumberFormat('#,###,###.##');

            return Column(
              children: [
                Container(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(translate.clickonTheVehicleLoanMessage,
                          style: SubtitleHelper.h11.copyWith(
                              color: appThemeColors!.disableText, height: 1.7)),
                    ],
                  ),
                )),
                SizedBox(
                  height: 15,
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: state.liabilitiesEntity.vehicleLoans.length,
                        itemBuilder: (con, index) {
                          final VehicleLoansEntity data =
                              state.liabilitiesEntity.vehicleLoans[index];

                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: Container(
                                    decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        new BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 9.9,
                                            spreadRadius: 0.5),
                                      ],
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context, data);
                                      },
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
                                                      style: SubtitleHelper.h10
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${data.provider}",
                                                          style: SubtitleHelper
                                                              .h11
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          "${data.country}",
                                                          style: SubtitleHelper
                                                              .h11
                                                              .copyWith(
                                                                  color: appThemeColors!
                                                                      .disableText),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                    "${data.outstandingAmount.currency} ${numFormatter.format(data.outstandingAmount.amount)}",
                                                    style: SubtitleHelper.h11
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Text(translate.totalOutstanding,
                                                    style: SubtitleHelper.h11
                                                        .copyWith(
                                                            color: appThemeColors!
                                                                .disableText)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          );
                        })),
                // AddMoreTextButton(
                //   page: AddVehicleLoanPage(),
                // ),
                AddNewButton(
                    text: translate.addMoreVehicleLoans,
                    onTap: () async {
                      var stocksdata = await Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  AddVehicleLoanPage(
                                    hideShowMore: true,
                                  )));
                      if (stocksdata != null) {
                        context.read<MainVehicleLoansCubit>().getVehicleLoans();
                      }
                    }),
                SizedBox(
                  height: 20,
                )
              ],
            );
          } else if (state is VehiclesLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MainVehicleLoansError) {
            return Center(
              child: Text(state.errorMsg),
            );
          } else {
            return Container();
          }
        },
      ),
      // bottomNavigationBar: BottomNavSingleButtonContainer(
      //   child: ElevatedButton(
      //     style: ElevatedButton.styleFrom(primary: kprimaryColor),
      //     onPressed: () {
      //       Navigator.pop(context, true);
      //     },
      //     child: Text(
      //       "Next",
      //       style: TextStyle(fontSize: kfontMedium, color: Colors.white),
      //     ),
      //   ),
      // )
    );
  }
}
