import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/stocks_crypto_search_entity.dart';
import 'package:wedge/core/helpers/textfeild_validator.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/inputFields/custom_text_form_field.dart';
import 'package:wedge/features/assets/stocks/search_stocks/presentation/cubit/search_stocks_cubit.dart';

class SearchStocksPage extends StatefulWidget {
  const SearchStocksPage({Key? key}) : super(key: key);

  @override
  _SearchStocksPageState createState() => _SearchStocksPageState();
}

class _SearchStocksPageState extends State<SearchStocksPage> {
  final TextEditingController _nameContr = TextEditingController();
  TextFieldValidator validator = TextFieldValidator();

  void getCurrency(String symbol) {
    context.read<SearchStocksCubit>().getCryptoCurrencyData(symbol);
  }

  SearchStocksCryptoEntity? stocks;
  AppLocalizations? translate;

  // String selectedCrpto = "";

  @override
  void initState() {
    super.initState();
    clearValue();
  }

  clearValue() {
    BlocProvider.of<SearchStocksCubit>(context, listen: false)
        .emit(SearchStocksInitial());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameContr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);
    return Scaffold(
      backgroundColor: appThemeColors!.bg,
      appBar: wedgeAppBar(
          context: context,
          title: "${translate!.add} ${translate!.stocksBonds}"),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            CustomFormTextField(
              paddingBottom: 5,
              onChanged: (_) {
                if (_.length > 0) {
                  context.read<SearchStocksCubit>().searchCrypto(_);
                }
              },
              autoFocused: true,
              hintText: NAME,
              inputType: TextInputType.text,
              textEditingController: _nameContr,
              validator: (value) => validator.validateName(value?.trim(), NAME),
            ),
            // SizedBox(
            //   height: 15,
            // ),
            BlocConsumer<SearchStocksCubit, SearchStocksState>(
              listener: (context, state) {
                if (state is SearchStocksLoaded) {
                  if (state.dataCurrency.isNotEmpty) {
                    Future.delayed(const Duration(milliseconds: 400), () {
                      state.dataCurrency['price'] =
                          double.parse(state.dataCurrency['price'].toString());
                      Navigator.of(context).pop({
                        "currency": state.dataCurrency,
                        "symbol": stocks!.symbol,
                        "crypto": stocks!.shortname
                      });
                    });
                  }
                }
                if (state is SearchStocksError) {
                  showSnackBar(context: context, title: state.errorMsg);
                }
              },
              builder: (context, state) {
                if (state is SearchStocksLoading) {
                  return Center(
                    child: buildCircularProgressIndicator(),
                  );
                } else if (state is SearchStocksLoaded) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: state.data.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(9),
                            child: Text(translate!.noStocksBondsFound,
                                textAlign: TextAlign.center,
                                style: SubtitleHelper.h8
                                    .copyWith(color: appThemeColors!.primary)),
                          )
                        : ListView.builder(
                            itemCount: state.data.length,
                            shrinkWrap: true,
                            itemBuilder: (con, index) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 16),
                                    child: InkWell(
                                      onTap: () {
                                        stocks = state.data[index];
                                        getCurrency(state.data[index].symbol);
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              state.data[index].shortname,
                                              style: SubtitleHelper.h11
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                            //  Column(
                                            //   crossAxisAlignment:
                                            //       CrossAxisAlignment.start,
                                            //   children: [
                                            //     Text(
                                            //       state.data[index].shortname,
                                            //       style: TextStyle(
                                            //           fontSize: 14,
                                            //           fontWeight: FontWeight.w600),
                                            //     ),
                                            //     SizedBox(
                                            //       height: 5,
                                            //     ),
                                            //     Text(
                                            //       state.data[index].longname,
                                            //       maxLines: 1,
                                            //       overflow: TextOverflow.ellipsis,
                                            //     ),
                                            //   ],
                                            // ),
                                          ),
                                          // Spacer(),
                                          Container(
                                            width: 100,
                                            margin:
                                                const EdgeInsets.only(right: 5),
                                            child: Text(
                                              "${state.data[index].symbol}",
                                              textAlign: TextAlign.end,
                                              maxLines: 1,
                                              style: SubtitleHelper.h11,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  state.data.length > 1
                                      ? index == state.data.length - 1
                                          ? Container()
                                          : const Divider()
                                      : Container()
                                ],
                              );
                            }),
                  );
                } else if (state is SearchStocksError) {
                  return Center(
                    child: Text(state.errorMsg),
                  );
                } else if (state is SearchStocksInitial) {
                  return Center(
                    child: Text(
                      translate!.pleaseEnterTheStocksMessage,
                      textAlign: TextAlign.center,
                      style: SubtitleHelper.h8
                          .copyWith(color: appThemeColors!.primary),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
      )),
    );
  }
}
