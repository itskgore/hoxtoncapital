import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/features/assets/bank_account/main_bank_account/presentation/bloc/cubit/bank_accounts_cubit.dart';
import 'package:wedge/features/home/presentation/widgets/sub_widgets/section_titlebar.dart';

import '../../../assets/bank_account/main_bank_account/presentation/pages/bank_account_main.dart';
import 'sub_widgets/credit_card_widget.dart';

class BankAccountsHome extends StatefulWidget {
  const BankAccountsHome({Key? key}) : super(key: key);

  @override
  _BankAccountsHomeState createState() => _BankAccountsHomeState();
}

class _BankAccountsHomeState extends State<BankAccountsHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      color: kBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          children: [
            SectionTitleBarHome(
                title: BANK_ACCOUNTS,
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              BankAccountMain())).then((value) {
                    context.read<BankAccountsCubit>().getData();
                  });
                }),
            BlocBuilder<BankAccountsCubit, BankAccountsState>(
              bloc: context.read<BankAccountsCubit>().getData(),
              builder: (context, state) {
                if (state is BankAccountsLoading) {
                  return Center(
                    child: buildCircularProgressIndicator(width: 100),
                  );
                } else if (state is BankAccountsLoaded) {
                  final data = state.assets.bankAccounts;
                  return Container(
                    height: 200,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: CreditCardWidget(
                              index: index,
                              isYodlee:
                                  data[index].source!.toLowerCase() != "manual",
                              date: "${data[index].createdAt}",
                              country: "${data[index].country}",
                              accountNumber:
                                  "${data[index].aggregatorAccountNumber}",
                              bankName: "${data[index].name}",
                              image: "${data[index].aggregatorLogo}",
                              amount:
                                  "${data[index].currentAmount.currency} ${data[index].currentAmount.amount}",
                              backgroundColor:
                                  data[index].source!.toLowerCase() != "manual"
                                      ? kcreditCardColors[0]
                                      : kcreditCardColors[1],
                            ),
                          );
                        }),
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _bankAvatar() {
    return Container(
      height: 70,
      width: 70.0,
      decoration: BoxDecoration(
          border: Border.all(width: 0.2, color: Colors.grey),
          color: Colors.grey,
          shape: BoxShape.circle,
          image: const DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  "https://www.finextra.com/finextra-images/top_pics/xl/hsbc480x270.jpg"))),
    );
  }
}
