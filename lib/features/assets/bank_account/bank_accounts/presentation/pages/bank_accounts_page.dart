// Note : This Page is Removed Because New UI is Added

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:page_view_indicators/animated_circle_page_indicator.dart';
import 'package:wedge/core/common/functions/common_functions.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/data_models/yodlee_bank_transaction_model.dart';
import 'package:wedge/core/entities/manual_bank_accounts_entity.dart';
import 'package:wedge/core/helpers/firebase_analytics.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/add_new_button.dart';
import 'package:wedge/core/widgets/dashboard_value_container.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/dropdown/wedge_custom_dropdown.dart';
import 'package:wedge/features/aggregator_reconnect/presentation/pages/aggregator_reconnect_icon.dart';
import 'package:wedge/features/assets/bank_account/add_bank_account/presentation/pages/add_bank_page.dart';
import 'package:wedge/features/assets/bank_account/add_bank_manual/presentation/pages/add_bank_manual_page.dart';
import 'package:wedge/features/assets/bank_account/bank_accounts/presentation/bloc/cubit/bank_transaction_cubit.dart';
import 'package:wedge/features/assets/bank_account/bank_accounts/presentation/bloc/cubit/home_bank_accounts_cubit.dart';
import 'package:wedge/features/assets/bank_account/bank_accounts/presentation/widgets/update_manual_bank_account_balance.dart';
import 'package:wedge/features/assets/bank_account/main_bank_account/presentation/bloc/cubit/bank_accounts_cubit.dart';
import 'package:wedge/features/calculators/opportunity_cost_calculator/presentation/pages/opportunity_calculator_page.dart';
import 'package:wedge/features/home/presentation/widgets/sub_widgets/credit_card_widget.dart';

import '../../../../../../core/widgets/dialog/wedge_comfirm_dialog.dart';
import '../../../../../../dependency_injection.dart';

class BankAccountsPage extends StatefulWidget {
  BankAccountsPage({Key? key, this.id = ""}) : super(key: key);
  final String id;

  @override
  _BankAccountsPageState createState() => _BankAccountsPageState();
}

class _BankAccountsPageState extends State<BankAccountsPage> {
  final _currentPageNotifier = ValueNotifier<int>(0);
  PageController controller = PageController(
    viewportFraction: 0.9,
  );

  bool isLoading = false;

  _startLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  AppLocalizations? translate;

  @override
  void initState() {
    AppAnalytics().trackScreen(
        screenName: "Bank Accounts",
        parameters: {'screenName': 'Bank Accounts'});
    getBankDetails(isInitialLoad: true);
    getMonthsInYear(6);
    super.initState();
    // translate = translateStrings(context);
  }

  int selectedCardIndex = 0;

  setIndex() {
    if (widget.id.isNotEmpty) {
      selectedCardIndex = RootApplicationAccess.assetsEntity!.bankAccounts
          .indexWhere((element) => element.id == widget.id);
      if (selectedCardIndex > 0) {
        controller = PageController(
            viewportFraction: 0.9, initialPage: selectedCardIndex);
      }
    }
  }

  getBankDetails({bool? isUpdated, bool? isInitialLoad}) {
    context.read<HomeBankAccountsCubit>().getData(
        transactionUpdated: isUpdated ?? false,
        isInitial: isInitialLoad ?? false);
    // BlocProvider.of<HomeBankAccountsCubit>(context).listen((state) {
    //   // if (state is HomeBankAccountsLoaded) {
    //   //   Future.delayed(Duration(milliseconds: 300), () {
    //   //     if (!state.transactionUpdated!) {
    //   //       getTransactionsData(state.data.bankAccounts[0]);
    //   //       if (this.mounted) {
    //   //         setState(() {});
    //   //       }
    //   //     }
    //   //   });
    //   // }
    // }).onDone(() {
    //   log("DONE!!!");
    // });
  }

  int currentPage = 1;

  getTransactionsData(ManualBankAccountsEntity data,
      {int? page, String? date}) {
    if (data.source!.toLowerCase() != "manual") {
      // get fresh Data
      _startLoading(true);

      context.read<BankTransactionCubit>().getYodleeTransactions({
        "aggregatorAccountId": data.aggregatorId,
        "date": date ?? dateFormatter3.format(DateTime.now()),
        "page": "${page ?? 1}"
      });
    } else {
      // get fresh Data
      _startLoading(true);
      context.read<BankTransactionCubit>().getManualTransactions({
        "bankAccountId": data.id,
        "date": "${DateTime.now().year}-${DateTime.now().month}",
        "page": "1"
      }, false);
    }
  }

  bool isDeletingAccount = false;

  deleteManualbankAcc(ManualBankAccountsEntity data) {
    locator.get<WedgeDialog>().confirm(
        context,
        WedgeConfirmDialog(
            title: translate!.areYouSure,
            subtitle: data.source?.toLowerCase() == "saltedge"
                ? "All accounts related to this institution will be removed."
                : "Your account information contributes a lot to showcasing your net worth information and other financial insights",
            acceptText: translate!.areYouSure,
            deniedText: translate!.noiWillKeepIt,
            deniedPress: () {
              Navigator.pop(context);
            },
            acceptedPress: () {
              setState(() {
                isDeletingAccount = true;
              });
              showSnackBar(context: context, title: translate!.loading);
              context.read<BankAccountsCubit>().deleteBankAccount(data.id);
              BlocProvider.of<BankAccountsCubit>(context).listen((p0) {
                if (p0 is BankAccountsLoaded) {
                  if (p0.deleteMessageSent) {
                    getBankDetails();
                    _currentPageNotifier.value = 0;
                    controller.animateToPage(0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn);
                    showSnackBar(
                        context: context,
                        title:
                            "${translate!.bankAccount} ${translate!.removed}");
                    setState(() {
                      isDeletingAccount = false;
                    });
                  }
                } else if (p0 is BankAccountsError) {
                  setState(() {
                    isDeletingAccount = false;
                  });
                  showSnackBar(context: context, title: p0.errorMsg);
                }
              });
              Navigator.pop(context);
            }));
  }

  updateManualBankBalanceSheet(ManualBankAccountsEntity data) {
    showDialog(
        context: context,
        barrierColor: appThemeColors!.primary!.withOpacity(1),
        barrierDismissible: false,
        builder: (BuildContext context) {
          return UpdateManualBankBalance(
            currency: data.currentAmount,
            onTap: (value) {
              BlocProvider.of<BankTransactionCubit>(context)
                  .updateManualBankTransaction({
                "balance": {
                  "amount": "${value.amount}",
                  "currency": data.currentAmount.currency
                },
                "isDeleted": false,
                "bankAccountId": data.id
              }, data);
              Navigator.pop(context);
            },
          );
        });
  }

  List<String> itemDates = [];
  List<String> itemAPIDates = [];
  String selectedItem = "";

  void getMonthsInYear(int length) {
    int i = 0;
    final date = DateTime.now();
    while (i <= length) {
      final d = DateTime(date.year, date.month - i, date.day);
      itemDates.add(dateFormatter4.format(d));
      itemAPIDates.add(dateFormatter3.format(d));
      i++;
    }
    itemDates = itemDates.toSet().toList();
    selectedItem = itemDates[0];
  }

  final ScrollController _scrollController = ScrollController();

  addCashAccounts() {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (BuildContext context) => AddBankAccountPage(
                  isAppBar: true,
                  successPopUp: (_, {required String source}) async {
                    if (_) {
                      // success
                      await RootApplicationAccess().storeAssets();
                      await RootApplicationAccess().storeLiabilities();
                      locator.get<WedgeDialog>().success(
                          context: context,
                          title: translate?.accountLinkedSuccessfully ?? "",
                          info: getPopUpDescription(source),
                          buttonLabel: translate?.continueWord ?? "",
                          onClicked: () async {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            getBankDetails();
                          });
                    } else {
                      // exited
                      Navigator.pop(context);
                    }
                  },
                  subtitle: translate!.selectBankSubtitle,
                  manualAddButtonAction: () async {
                    final data = await Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                AddBankManualPage(
                                  isFromDashboard: true,
                                )));
                    setState(() {
                      getBankDetails();
                    });
                  },
                  manualAddButtonTitle: translate!.addManually,
                  placeholder: "${translate!.add} ${translate!.cashAccounts}",
                  title: "${translate!.add} ${translate!.cashAccounts}",
                ))).then((value) {
      getBankDetails();
    });
  }

  refreshSaltedgeAccount(ManualBankAccountsEntity data) {
    context.read<BankTransactionCubit>().refreshSaltedgeAccount(data);
  }

  bool isLinkedAccount(String data) {
    if (data == "manual") {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: appThemeColors!.bg,
        appBar: wedgeAppBar(
            context: context,
            title: translate!.cashAccounts,
            leadingIcon: getLeadingIcon(context, true),
            actions: IconButton(
                onPressed: () {
                  addCashAccounts();
                },
                icon: Icon(
                  Icons.add,
                  color: appThemeColors!.primary!,
                ))),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              BlocConsumer<HomeBankAccountsCubit, HomeBankAccountsState>(
                listener: (context, state) {
                  if (state is HomeBankAccountsLoaded) {
                    // Future.delayed(Duration(milliseconds: 300), () {
                    if (!state.transactionUpdated!) {
                      if (state.data.bankAccounts.isNotEmpty) {
                        getTransactionsData(state.data.bankAccounts[0]);
                      }
                      if (this.mounted) {
                        setState(() {});
                      }
                    }
                    // });
                  }
                  if (state is HomeBankAccountsError) {
                    showSnackBar(context: context, title: state.errorMsg);
                  }
                },
                builder: (context, state) {
                  if (state is HomeBankAccountsLoaded) {
                    final data = state.data.bankAccounts;

                    return data.isEmpty
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              DashboardValueContainer(
                                  mainValue:
                                      "${state.data.summary.bankAccounts.currency} ${state.data.summary.bankAccounts.amount}",
                                  mainTitle: translate!.totalCashBalance,
                                  leftValue:
                                      "${state.data.bankAccounts.length} ",
                                  leftTitle: translate!.cashAccounts,
                                  leftImage:
                                      "assets/icons/bankAccountMainContainer.png",
                                  rightTitle: translate!.countries,
                                  rightvalue:
                                      "${state.data.summary.bankAccounts.countryCount}"),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: AddNewButton(
                                    text: translate!.addNewBankAccount,
                                    onTap: () async {
                                      addCashAccounts();
                                    }),
                              ),
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.all(kpadding),
                            child: Column(
                              children: [
                                DashboardValueContainer(
                                    mainValue:
                                        "${state.data.summary.bankAccounts.currency} ${state.data.summary.bankAccounts.amount}",
                                    mainTitle: translate!.totalCashBalance,
                                    leftImage:
                                        "assets/icons/bankAccountMainContainer.png",
                                    leftValue:
                                        "${state.data.bankAccounts.length} ",
                                    leftTitle: translate!.cashAccounts,
                                    rightTitle: translate!.countries,
                                    rightvalue:
                                        "${state.data.summary.bankAccounts.countryCount}"),
                                SizedBox(
                                  height: 220,
                                  child: PageView.builder(
                                      physics: isLoading
                                          ? const NeverScrollableScrollPhysics()
                                          : const ClampingScrollPhysics(),
                                      // padEnds: false,
                                      controller: controller,
                                      scrollDirection: Axis.horizontal,
                                      onPageChanged: (_) {
                                        _currentPageNotifier.value = _;
                                        currentPage = 1;
                                        getTransactionsData(data[_]);
                                        setState(() {});
                                      },
                                      itemCount: data.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: CreditCardWidget(
                                            index: index,
                                            date: data[index]
                                                        .source!
                                                        .toLowerCase() !=
                                                    "manual"
                                                ? data[index].updatedAt!.isEmpty
                                                    ? "${data[index].createdAt}"
                                                    : "${data[index].updatedAt}"
                                                : data[index].updatedAt !=
                                                            null ||
                                                        data[index]
                                                            .updatedAt!
                                                            .isNotEmpty
                                                    ? "${data[index].updatedAt}"
                                                    : "${data[index].createdAt}",
                                            country: data[index].country,
                                            accountNumber:
                                                "${data[index].aggregatorAccountNumber}",
                                            bankName: data[index]
                                                        .source!
                                                        .toLowerCase() !=
                                                    "manual"
                                                ? data[index].name.isEmpty
                                                    ? "${data[index].providerName}"
                                                    : data[index].name
                                                : data[index].name,
                                            image:
                                                "${data[index].aggregatorLogo}",
                                            isYodlee: data[index]
                                                    .source!
                                                    .toLowerCase() !=
                                                "manual",
                                            amount:
                                                "${data[index].currentAmount.currency} ${data[index].currentAmount.amount}",
                                            backgroundColor: appThemeColors!
                                                .creditCards![index % 4],
                                          ),
                                        );
                                      }),
                                ),
                                Center(
                                  child: AnimatedCirclePageIndicator(
                                    itemCount: state.data.bankAccounts.length,
                                    currentPageNotifier: _currentPageNotifier,
                                    borderWidth: 1,
                                    borderColor: appThemeColors!.primary!,
                                    spacing: 6,
                                    radius: 5,
                                    activeRadius: 4,
                                    activeColor: appThemeColors!.primary!,
                                    fillColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                BlocConsumer<BankTransactionCubit,
                                    BankTransactionState>(
                                  listener: (context, trans) {
                                    if (trans is BankTransactionLoaded) {
                                      if (trans.didPageUpdate != null) {
                                        if (!trans.didPageUpdate!) {
                                          showSnackBar(
                                              context: context,
                                              title: translate!.noDataFound);
                                        }

                                        // Future.delayed(Duration(milliseconds: 500), () {
                                        //   _scrollController.animateTo(
                                        //       _scrollController
                                        //           .position.maxScrollExtent,
                                        //       duration: Duration(milliseconds: 400),
                                        //       curve: Curves.ease);
                                        // });
                                      }

                                      if (trans.isUpdated ?? false) {
                                        getBankDetails(isUpdated: true);
                                      }
                                      _startLoading(false);
                                    } else if (trans is BankTransactionError) {
                                      showSnackBar(
                                          context: context,
                                          title: trans.message);
                                      _startLoading(false);
                                    }
                                  },
                                  builder: (context, trans) {
                                    if (trans is BankTransactionLoading) {
                                      return Center(
                                        child: buildCircularProgressIndicator(
                                            width: 200),
                                      );
                                    } else if (trans is BankTransactionLoaded) {
                                      final bankData = state.data.bankAccounts[
                                          _currentPageNotifier.value];

                                      if (bankData.source!.toLowerCase() !=
                                          "manual") {
                                        num inFlow = 0;
                                        String inFlowCurrency = "";
                                        num outFlow = 0;
                                        String outFlowCurrency = "";
                                        final debitList = trans
                                            .yodleeTransactionsData
                                            .where((e) =>
                                                e.baseType.toUpperCase() ==
                                                "DEBIT")
                                            .toList();
                                        final creditList = trans
                                            .yodleeTransactionsData
                                            .where((e) =>
                                                e.baseType.toUpperCase() ==
                                                "CREDIT")
                                            .toList();
                                        creditList.forEach((e) {
                                          inFlow = inFlow + e.amount.amount;
                                          inFlowCurrency = e.amount.currency;
                                        });
                                        debitList.forEach((e) {
                                          outFlow = outFlow + e.amount.amount;
                                          outFlowCurrency = e.amount.currency;
                                        });

                                        // View full transaction disable
                                        bool disableViewFullTransaction = false;

                                        double totalPage =
                                            YodleeBankTransactionModel
                                                    .cursor['totalRecords'] /
                                                YodleeBankTransactionModel
                                                    .cursor['perPage'];
                                        disableViewFullTransaction =
                                            currentPage == totalPage.ceil();
                                        if (trans
                                            .yodleeTransactionsData.isEmpty) {
                                          disableViewFullTransaction = true;
                                        }
                                        return Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Column(
                                            // shrinkWrap: true,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20, top: 20),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                bankData.name
                                                                        .isEmpty
                                                                    ? "${bankData.providerName}"
                                                                    : bankData
                                                                        .name,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TitleHelper
                                                                        .h10,
                                                              ),
                                                            ),
                                                            isAggregatorExpired(
                                                                    data:
                                                                        bankData)
                                                                ? ReconnectIcon(
                                                                    isButton:
                                                                        false,
                                                                    data:
                                                                        bankData,
                                                                    onComplete:
                                                                        (val) {
                                                                      if (val) {
                                                                        getBankDetails(
                                                                            isUpdated:
                                                                                true);
                                                                      }
                                                                    })
                                                                : const SizedBox(),
                                                            isDeletingAccount
                                                                ? Container()
                                                                : Container(
                                                                    child:
                                                                        Theme(
                                                                      data: Theme.of(
                                                                              context)
                                                                          .copyWith(
                                                                        dividerTheme:
                                                                            const DividerThemeData(
                                                                          color:
                                                                              Color(0xfffD6D6D6),
                                                                        ),
                                                                        iconTheme:
                                                                            const IconThemeData(color: Colors.black),
                                                                        textTheme:
                                                                            const TextTheme().apply(bodyColor: Colors.black),
                                                                      ),
                                                                      child: PopupMenuButton<
                                                                          int>(
                                                                        padding:
                                                                            const EdgeInsets.only(left: 15),
                                                                        shape:
                                                                            const RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                            Radius.circular(10.0),
                                                                          ),
                                                                        ),
                                                                        onSelected:
                                                                            (_) {
                                                                          if (_ ==
                                                                              1) {
                                                                            deleteManualbankAcc(bankData);
                                                                          }
                                                                        },
                                                                        icon: const Icon(
                                                                            Icons.more_vert),
                                                                        color: Colors
                                                                            .white,
                                                                        itemBuilder:
                                                                            (context) =>
                                                                                [
                                                                          PopupMenuItem(
                                                                            height:
                                                                                36,
                                                                            value:
                                                                                1,
                                                                            child:
                                                                                popUpItem(
                                                                              translate!.removeBank,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                            const SizedBox(
                                                              width: 10,
                                                            )
                                                          ],
                                                        ),
                                                        // SizedBox(
                                                        //   height: 5,
                                                        // ),
                                                        Text(
                                                          "${translate!.accountNo}: ${bankData.aggregatorId}",
                                                          style: TextStyle(
                                                              fontSize:
                                                                  appThemeSubtitleSizes!
                                                                      .h12,
                                                              color: appThemeColors!
                                                                  .disableText,
                                                              fontFamily:
                                                                  appThemeSubtitleFont),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Divider(),
                                                  Container(
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                                    child: Text(
                                                        translate!
                                                            .latestTransactions,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize:
                                                                appThemeSubtitleSizes!
                                                                    .h10,
                                                            fontFamily:
                                                                appThemeSubtitleFont,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                                    child: WedgeCustomDropDown(
                                                        items: itemDates,
                                                        value: selectedItem,
                                                        onChanged: (i) {
                                                          selectedItem = i;
                                                          currentPage = 1;
                                                          int counter =
                                                              itemDates.indexOf(
                                                                  selectedItem);
                                                          getTransactionsData(
                                                              bankData,
                                                              date:
                                                                  itemAPIDates[
                                                                      counter]);
                                                        }),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        top: BorderSide(
                                                          color: kDividerColor,
                                                          width: 1.0,
                                                        ),
                                                        bottom: BorderSide(
                                                          color: kDividerColor,
                                                          width: 1.0,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        getCashFlow(
                                                            amount:
                                                                "$inFlowCurrency ${numberFormat.format(YodleeBankTransactionModel.summary['totalDebitAmount'])}",
                                                            icon: Icons
                                                                .arrow_downward_outlined,
                                                            title:
                                                                "Current month in-flow"),

                                                        getCashFlow(
                                                            amount:
                                                                "$outFlowCurrency ${numberFormat.format(YodleeBankTransactionModel.summary['totalCreditAmount'])}",
                                                            icon: Icons
                                                                .arrow_upward_outlined,
                                                            title:
                                                                "Current month out-flow"),
                                                        // Container(color: Colors.grey[200], width: 1.0, height: 50),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                  children: List.generate(
                                                      trans
                                                          .yodleeTransactionsData
                                                          .length, (index) {
                                                final yodlee = trans
                                                        .yodleeTransactionsData[
                                                    index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 15,
                                                          ),
                                                          Image.asset(
                                                            yodlee.baseType
                                                                        .toUpperCase() ==
                                                                    "DEBIT"
                                                                ? "${appIcons.assetsPaths!.debitIcon}"
                                                                : "${appIcons.assetsPaths!.creditIcon}",
                                                            width: 15,
                                                          ),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Expanded(
                                                              child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                yodlee.category,
                                                                maxLines: 1,
                                                                style:
                                                                    SubtitleHelper
                                                                        .h11,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                dateFormatter7.format(
                                                                    DateTime.parse(
                                                                        yodlee
                                                                            .transactionDate)),
                                                                style: SubtitleHelper.h12.copyWith(
                                                                    color: appThemeColors!
                                                                        .disableText,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                              ),
                                                            ],
                                                          )),
                                                          // Spacer(),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              "${yodlee.amount.currency} ${numberFormat.format(yodlee.amount.amount)}",
                                                              style:
                                                                  SubtitleHelper
                                                                      .h11,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          PopupMenuButton<int>(
                                                              onSelected: (_) {
                                                                if (_ == 1) {
                                                                  Navigator.push(
                                                                      context,
                                                                      CupertinoPageRoute(
                                                                          builder: (BuildContext context) => OpportunityCalculatorPage(
                                                                                transactions: "${yodlee.amount.amount}",
                                                                              )));
                                                                }
                                                              },
                                                              shape:
                                                                  const RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0),
                                                                ),
                                                              ),
                                                              icon: const Icon(
                                                                  Icons
                                                                      .more_vert),
                                                              color:
                                                                  Colors.white,
                                                              itemBuilder:
                                                                  (context) => [
                                                                        PopupMenuItem(
                                                                          height:
                                                                              36,
                                                                          padding:
                                                                              EdgeInsets.zero,
                                                                          value:
                                                                              1,
                                                                          child:
                                                                              popUpItem(translate!.calculateOpportunityCost),
                                                                        ),
                                                                        // New Feature
                                                                        // PopupMenuDivider(
                                                                        //   height:
                                                                        //       1,
                                                                        // ),
                                                                        // PopupMenuItem(
                                                                        //   child:
                                                                        //       popUpItem("Delete update"),
                                                                        //   value:
                                                                        //       2,
                                                                        // ),
                                                                      ])
                                                        ],
                                                      ),
                                                    ),
                                                    if (index !=
                                                            trans.yodleeTransactionsData
                                                                    .length -
                                                                1 ||
                                                        !disableViewFullTransaction)
                                                      const Divider()
                                                    else
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                    // Divider()
                                                  ],
                                                );
                                              })),
                                              !disableViewFullTransaction
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SizedBox(
                                                        height: 36,
                                                        width: double.infinity,
                                                        child: TextButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary: Colors
                                                                      .white),
                                                          onPressed: () {
                                                            if (!disableViewFullTransaction) {
                                                              currentPage += 1;
                                                              int counter =
                                                                  itemDates.indexOf(
                                                                      selectedItem);
                                                              getTransactionsData(
                                                                  bankData,
                                                                  page:
                                                                      currentPage,
                                                                  date: itemAPIDates[
                                                                      counter]);
                                                            }

                                                            // Navigator.push(
                                                            //     context,
                                                            //     CupertinoPageRoute(
                                                            //         builder: (BuildContext context) => AddAssetSuccessPage()
                                                            //         // AddBankAccountPage()
                                                            //         ));
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .arrow_downward,
                                                                color: disableViewFullTransaction
                                                                    ? appThemeColors!
                                                                        .disableText
                                                                    : appThemeColors!
                                                                        .outline,
                                                              ),
                                                              Text(
                                                                translate!
                                                                    .viewFullTransactions,
                                                                style: SubtitleHelper.h10.copyWith(
                                                                    color: disableViewFullTransaction
                                                                        ? appThemeColors!
                                                                            .disableText
                                                                        : appThemeColors!
                                                                            .outline),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Column(
                                              children: [
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 20),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                bankData.name,
                                                                style: SubtitleHelper
                                                                    .h10
                                                                    .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                  "${translate!.accountNo} : XXXX XXXX XXXX",
                                                                  style: SubtitleHelper
                                                                      .h12
                                                                      .copyWith(
                                                                          color:
                                                                              appThemeColors!.disableText)),
                                                            ],
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        isDeletingAccount
                                                            ? Container()
                                                            : Container(
                                                                child: Theme(
                                                                  data: Theme.of(
                                                                          context)
                                                                      .copyWith(
                                                                    dividerTheme:
                                                                        const DividerThemeData(
                                                                      color: Color(
                                                                          0xfffD6D6D6),
                                                                    ),
                                                                    iconTheme: const IconThemeData(
                                                                        color: Colors
                                                                            .black),
                                                                    textTheme: const TextTheme().apply(
                                                                        bodyColor:
                                                                            Colors.black),
                                                                  ),
                                                                  child:
                                                                      PopupMenuButton<
                                                                          int>(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                    shape:
                                                                        const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            10.0),
                                                                      ),
                                                                    ),
                                                                    onSelected:
                                                                        (_) {
                                                                      if (_ ==
                                                                          1) {
                                                                        Navigator.push(
                                                                            context,
                                                                            CupertinoPageRoute(
                                                                                builder: (BuildContext context) => AddBankManualPage(
                                                                                      fromHome: true,
                                                                                      manualBankData: bankData,
                                                                                    ))).then((value) {
                                                                          // locator<AllAssetsCubit>().getData();
                                                                          getBankDetails();
                                                                        });
                                                                      } else if (_ ==
                                                                          2) {
                                                                        deleteManualbankAcc(
                                                                            bankData);
                                                                      }
                                                                    },
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .more_vert),
                                                                    color: Colors
                                                                        .white,
                                                                    itemBuilder:
                                                                        (context) =>
                                                                            [
                                                                      PopupMenuItem(
                                                                        height:
                                                                            36,
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                        value:
                                                                            1,
                                                                        child: popUpItem(
                                                                            translate!.editBankDetails),
                                                                      ),
                                                                      const PopupMenuDivider(
                                                                        height:
                                                                            1,
                                                                      ),
                                                                      PopupMenuItem(
                                                                        height:
                                                                            36,
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                        value:
                                                                            2,
                                                                        child: popUpItem(
                                                                            translate!.removeBank),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    const Divider(),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20,
                                                          vertical: 10),
                                                      child: Container(
                                                        width: double.infinity,
                                                        child: Text(
                                                          translate!
                                                              .updatesHistory,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: SubtitleHelper
                                                              .h10
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Divider(),
                                                Column(
                                                  children: List.generate(
                                                      trans
                                                          .manualTransactionData
                                                          .length, (index) {
                                                    return Column(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 10),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                dateFormatter2.format(
                                                                    DateTime.parse(trans
                                                                        .manualTransactionData[
                                                                            index]
                                                                        .createdAt)),
                                                                style:
                                                                    SubtitleHelper
                                                                        .h11,
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                "${trans.manualTransactionData[index].balance.currency} ${numberFormat.format(
                                                                  trans
                                                                      .manualTransactionData[
                                                                          index]
                                                                      .balance
                                                                      .amount,
                                                                )}",
                                                                maxLines: 1,
                                                                style:
                                                                    SubtitleHelper
                                                                        .h11,
                                                              ),
                                                              const SizedBox(
                                                                width: 15,
                                                              ),
                                                              Container(
                                                                width: 20,
                                                                child: Theme(
                                                                  data: Theme.of(
                                                                          context)
                                                                      .copyWith(
                                                                    dividerTheme:
                                                                        const DividerThemeData(
                                                                      color: Color(
                                                                          0xfffD6D6D6),
                                                                    ),
                                                                    iconTheme: const IconThemeData(
                                                                        color: Colors
                                                                            .black),
                                                                    textTheme: const TextTheme().apply(
                                                                        bodyColor:
                                                                            Colors.black),
                                                                  ),
                                                                  child: PopupMenuButton<
                                                                          int>(
                                                                      onSelected:
                                                                          (_) {
                                                                        if (_ ==
                                                                            1) {
                                                                          Navigator.push(
                                                                              context,
                                                                              CupertinoPageRoute(
                                                                                  builder: (BuildContext context) => OpportunityCalculatorPage(
                                                                                        transactions: "${trans.manualTransactionData[index].balance.amount}",
                                                                                      )));
                                                                        }
                                                                      },
                                                                      shape:
                                                                          const RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(
                                                                          Radius.circular(
                                                                              10.0),
                                                                        ),
                                                                      ),
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .more_vert),
                                                                      color: Colors
                                                                          .white,
                                                                      itemBuilder:
                                                                          (context) =>
                                                                              [
                                                                                PopupMenuItem(
                                                                                  height: 40,
                                                                                  padding: EdgeInsets.zero,
                                                                                  value: 1,
                                                                                  child: popUpItem(translate!.calculateOpportunityCost),
                                                                                ),
                                                                                // New Feature
                                                                                // PopupMenuDivider(
                                                                                //   height:
                                                                                //       1,
                                                                                // ),
                                                                                // PopupMenuItem(
                                                                                //   child:
                                                                                //       popUpItem("Delete update"),
                                                                                //   value:
                                                                                //       2,
                                                                                // ),
                                                                              ]),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        const Divider(),
                                                      ],
                                                    );
                                                  }),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    height: 36,
                                                    width: double.infinity,
                                                    child: TextButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  Colors.white),
                                                      onPressed: () {
                                                        log("bankData.id ${bankData.id}");
                                                        updateManualBankBalanceSheet(
                                                            bankData);
                                                      },
                                                      child: Text(
                                                        translate!
                                                            .updateYourCurrentBalance,
                                                        style: SubtitleHelper
                                                            .h10
                                                            .copyWith(
                                                                color:
                                                                    appThemeColors!
                                                                        .outline),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ));
                                      }
                                    }
                                    {
                                      return Container();
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 30,
                                )
                              ],
                            ),
                          );
                  } else if (state is HomeBankAccountsLoading) {
                    return Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.40,
                          ),
                          buildCircularProgressIndicator(width: 200),
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Align popUpItem(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 15,
        ),
        child: Text(
          title,
          textAlign: TextAlign.right,
          style: TextStyle(color: appThemeColors!.outline),
        ),
      ),
    );
  }

// Widget
}

Widget getCashFlow(
    {required IconData icon, required String title, required String amount}) {
  return Expanded(
    child: Container(
      // height: 50,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: kDividerColor,
            width: title.contains("out-flow") ? 0.0 : 1.0,
          ),
        ),
      ),
      padding: EdgeInsets.only(left: title.contains("out-flow") ? 12 : 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: title.contains("out-flow")
                          ? Colors.red
                          : Colors.green),
                  child: Center(
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                Container(
                  // width: double.infinity,
                  child: Text(
                    amount.length > 10
                        ? "${amount.substring(0, 9)}..."
                        : amount,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TitleHelper.h10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6.0),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: SubtitleHelper.h11,
            ),
          ],
        ),
      ),
    ),
  );
}
