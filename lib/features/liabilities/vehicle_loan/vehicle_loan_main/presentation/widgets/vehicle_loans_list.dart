import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/entities/vehicle_entity.dart';
import 'package:wedge/core/entities/vehicles_loans_entity.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/wedge_expension_tile.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/presentation/pages/add_vehicle_loan_page.dart';
import 'package:wedge/features/liabilities/vehicle_loan/vehicle_loan_main/presentation/cubit/main_vehicle_loans_cubit.dart';

import '../../../../../../core/widgets/dialog/wedge_comfirm_dialog.dart';

class VehicleLoanList extends StatefulWidget {
  final VehicleEntity? vehicleLoans;
  final Function? onDeleted;
  List<VehicleLoansEntity>? vehicleLoansEntity;

  VehicleLoanList(
      {Key? key, this.vehicleLoans, this.vehicleLoansEntity, this.onDeleted})
      : super(key: key);

  @override
  _VehicleLoanListState createState() => _VehicleLoanListState();
}

class _VehicleLoanListState extends State<VehicleLoanList> {
  AppLocalizations? translate;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainVehicleLoansCubit, MainVehicleLoansState>(
      listener: (context, state) {
        if (state is MainVehicleLoansUnlinked) {
          showSnackBar(context: context, title: "Vehicle loan is unlinked!");
          widget.onDeleted!();
        }
      },
      bloc: context.read<MainVehicleLoansCubit>().getVehicleLoans(),
      builder: (context, state) {
        if (state is MainVehicleLoansLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MainVehicleLoansLoaded) {
          if (widget.vehicleLoans != null &&
              widget.vehicleLoans!.vehicleLoans.isNotEmpty) {
            widget.vehicleLoansEntity = state.liabilitiesEntity.vehicleLoans;

            widget.vehicleLoansEntity!.removeWhere((element) =>
                element.id != widget.vehicleLoans!.vehicleLoans[0].id);
          }

          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                  widget.vehicleLoansEntity!.length,
                  (index) =>
                      _exptiles(widget.vehicleLoansEntity![index], index)));
        } else if (state is MainVehicleLoansUnlinked) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  Widget _exptiles(VehicleLoansEntity data, int index) {
    translate = translateStrings(context);
    return WedgeExpansionTile(
      index: index,
      leftSubtitle: data.country,
      leftTitle: data.provider,
      midWidget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(translateStrings(context)!.loan),
                const SizedBox(
                  height: 8.0,
                ),
                Text(translateStrings(context)!.interestRate),
                const SizedBox(
                  height: 8.0,
                ),
                data.vehicles.isEmpty
                    ? Container()
                    : Column(
                        children: [
                          Text(translateStrings(context)!.vehicle),
                          const SizedBox(
                            height: 8.0,
                          ),
                        ],
                      ),
                data.maturityDate.isEmpty
                    ? const SizedBox()
                    : Text(translateStrings(context)!.maturityDate),
                const SizedBox(
                  height: 8.0,
                ),
                Text(translateStrings(context)!.monthlyPayments),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(translateStrings(context)!.yes),
                const SizedBox(
                  height: 8.0,
                ),
                Text("${data.interestRate}%"),
                const SizedBox(
                  height: 8.0,
                ),
                data.vehicles.isEmpty
                    ? Container()
                    : Column(
                        children: [
                          Text(data.vehicles[0].name),
                          const SizedBox(
                            height: 8.0,
                          ),
                        ],
                      ),
                Visibility(
                  visible: data.maturityDate.isNotEmpty,
                  child: Text(translate!
                      .perMonthMaturity(getFormattedDate2(data.maturityDate))),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(translateStrings(context)!.perMonthCost(
                    "${data.monthlyPayment.currency} ${data.monthlyPayment.amount}")),
              ],
            ),
          ],
        ),
      ),
      isUnlink: true,
      onDeletePressed: () {
        locator.get<WedgeDialog>().confirm(
            context,
            WedgeConfirmDialog(
              title: translateStrings(context)!.unlinktheVehicle,
              subtitle: translateStrings(context)!.unlinkVehicleMessage,
              acceptText: translateStrings(context)!.yesUnlink,
              acceptedPress: () {
                showSnackBar(context: context, title: "Loading....");

                if (widget.vehicleLoans != null &&
                    widget.vehicleLoans!.vehicleLoans.isNotEmpty) {
                  BlocProvider.of<MainVehicleLoansCubit>(context)
                      .unlinkVehicleLoansData(UnlinkParams(
                          loanId: data.id, vehicleId: widget.vehicleLoans!.id));
                } else {
                  widget.onDeleted!();
                }

                Navigator.pop(context);
              },
              deniedText: translateStrings(context)!.noiWillKeepIt,
              deniedPress: () {
                Navigator.pop(context);
              },
            ));
      },
      onEditPressed: () async {
        var _result = await Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => AddVehicleLoanPage(
                      vehicleLoansEntity: data,
                      isFromLink: true,
                    )));
        if (_result != null) {
          context.read<MainVehicleLoansCubit>().getVehicleLoans();
          setState(() {});
        }
      },
      rightTitle:
          '${data.outstandingAmount.currency} ${data.outstandingAmount.amount}',
      rightSubTitle: translate!.outStanding,
    );
  }
}
