import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/stocks_crypto_search_entity.dart';
import 'package:wedge/core/helpers/textfeild_validator.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/inputFields/custom_text_form_field.dart';
import 'package:wedge/features/assets/crypto/crypto_search/presentation/cubit/search_crypto_cubit.dart';

class SearchCryptoPage extends StatefulWidget {
  const SearchCryptoPage({Key? key}) : super(key: key);

  @override
  _SearchCryptoPageState createState() => _SearchCryptoPageState();
}

class _SearchCryptoPageState extends State<SearchCryptoPage> {
  final TextEditingController _nameContr = TextEditingController();
  TextFieldValidator validator = TextFieldValidator();

  void getCurrency(String symbol) {
    context.read<SearchCryptoCubit>().getCryptoCurrencyData(symbol);
  }

  SearchStocksCryptoEntity? selectedCrpto;
  String? searchText;

  @override
  void initState() {
    super.initState();
    clearValue();
  }

  clearValue() {
    BlocProvider.of<SearchCryptoCubit>(context, listen: false)
        .emit(SearchCryptoInitial());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameContr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);

    return Scaffold(
      backgroundColor: appThemeColors!.bg,
      appBar: wedgeAppBar(
          context: context,
          title: "${translate!.add} ${translate.cryptoCurrencies}"),
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
              autoFocused: true,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  searchText = value;
                  context.read<SearchCryptoCubit>().searchCrypto(value);
                }
              },
              hintText: NAME,
              inputType: TextInputType.text,
              textEditingController: _nameContr,
              validator: (value) => validator.validateName(value?.trim(), NAME),
            ),
            // SizedBox(
            //   height: 15,
            // ),
            BlocConsumer<SearchCryptoCubit, SearchCryptoState>(
              listener: (context, state) {
                if (state is SearchCryptoLoaded) {
                  if (state.dataCurrency.isNotEmpty) {
                    Future.delayed(const Duration(milliseconds: 400), () {
                      state.dataCurrency['price'] =
                          double.parse(state.dataCurrency['price'].toString());
                      Navigator.of(context).pop({
                        "currency": state.dataCurrency,
                        "crypto": selectedCrpto!.shortname,
                        "symbol": selectedCrpto!.symbol
                      });
                    });
                  }
                }
                if (state is SearchCryptoError) {
                  showSnackBar(context: context, title: state.errorMsg);
                }
              },
              builder: (context, state) {
                if (state is SearchCryptoLoading) {
                  return Center(
                    child: buildCircularProgressIndicator(),
                  );
                } else if (state is SearchCryptoLoaded) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: state.data.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(9),
                            child: Text("No Crypto found",
                                textAlign: TextAlign.center,
                                style: TitleHelper.h6),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.data.length,
                            itemBuilder: (con, index) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 18),
                                    child: InkWell(
                                      onTap: () {
                                        selectedCrpto = state.data[index];
                                        getCurrency(state.data[index].symbol);
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              state.data[index].shortname,
                                              style: SubtitleHelper.h10
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                          ),
                                          // Spacer(),
                                          Text(
                                            state.data[index].symbol,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: SubtitleHelper.h10,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  state.data.length > 1
                                      ? const Divider()
                                      : Container()
                                ],
                              );
                            }),
                  );
                } else if (state is SearchCryptoError) {
                  return Center(
                    child: Text(state.errorMsg),
                  );
                } else if (state is SearchCryptoInitial) {
                  return Center(
                    child: Text(
                      translate.pleaseEnterTheCryptoYouwanaSearch,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: kfontLarge, color: appThemeColors!.primary),
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
