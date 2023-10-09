import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/wedge_app_bar.dart';
import 'package:wedge/features/wealth_vault/documents/presentation/pages/my_documents_page.dart';

import '../../../../../core/config/app_config.dart';
import '../../../../../core/contants/string_contants.dart';
import '../bloc/cubit/document_cubit.dart';

class WealthValtMainPage extends StatefulWidget {
  const WealthValtMainPage({Key? key}) : super(key: key);

  @override
  State<WealthValtMainPage> createState() => _WealthValtMainPageState();
}

class _WealthValtMainPageState extends State<WealthValtMainPage> {
  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    context.read<DocumentCubit>().getData();
    super.initState();
  }

  @override
  void dispose() {
    //
    _controller.dispose();
    super.dispose();
  }

  //My Documents
  //Wealth Vault
  //Your Secure vault
  //Safely store important files & documents such as your will, insurance, investments, property details etc.
  //Add Beneficiary
  //Add a beneficiary and a trusted person to contact and pass on your financial information to in your absence. .
  //Beneficiary
  //rename
  //download
  //delete
  //Upload a new file

  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);
    return Scaffold(
      backgroundColor: appThemeColors!.bg,
      appBar: WedgeAppBar(heading: translate!.wealthVault),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: isSmallDevice(context)
                    ? MediaQuery.of(context).size.height / 1.6
                    : MediaQuery.of(context).size.height / 2.1,
                child: PageView(
                    controller: _controller,
                    onPageChanged: (int index) {
                      setState(() {
                      });
                    },
                    children: [
                      pageViewContainers(
                          image: 'assets/icons/wealth_vault_dark.svg',
                          title: translate.yourSecureVault,
                          subTitle: translate.documentStoreMessage),
                    ]),
              ),
              BlocConsumer<DocumentCubit, DocumentState>(
                listener: (context, state) {
                  if (state is DocumentError) {
                    showSnackBar(context: context, title: state.errorMsg);
                  }
                },
                builder: (context, state) {
                  if (state is DocumentLoading) {
                    return Center(child: buildCircularProgressIndicator());
                  } else if (state is DocumentLoaded) {
                    return mainButtons(
                        title:
                            "${translate.myDocuments} (${state.docs.length})",
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (BuildContext context) =>
                                      MyDocumentsPage()));
                        },
                        image: Icons.description);
                  } else {
                    return Container();
                  }
                },
              ),
              // mainButtons(
              //     title: translate.beneficiary,
              //     onTap: () {
              //       Navigator.push(
              //           context,
              //           CupertinoPageRoute(
              //               builder: (BuildContext context) =>
              //                   BeneficiaryMainScreen()));
              //     },
              //     image: Icons.people)
            ],
          ),
        ),
      ),
    );
  }

  Widget pageViewContainers(
      {required String image,
      required String title,
      required String subTitle}) {
    return Column(children: [
      const SizedBox(
        height: 20,
      ),
      SvgPicture.asset(
        image,
        width: size.height * .18,
        color: appThemeColors!.primary!,
      ),
      const Spacer(),
      Text(
        title,
        style: TitleHelper.h9,
      ),
      const SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          subTitle,
          textAlign: TextAlign.center,
          style: isSmallDevice(context)
              ? SubtitleHelper.h11.copyWith(height: 1.6)
              : SubtitleHelper.h10.copyWith(height: 1.6),
        ),
      ),
      const SizedBox(
        height: 30,
      ),
    ]);
  }

  Container mainButtons(
      {required String title,
      required Function onTap,
      required IconData image}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: appThemeColors!.textLight,
        boxShadow: [
          BoxShadow(
              color: appThemeColors!.textDark!.withOpacity(0.122),
              blurRadius: 10.0,
              spreadRadius: 1.5),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListTile(
          leading: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: appThemeColors!.primary,
                  borderRadius: BorderRadius.circular(5)),
              child: Icon(image, color: Colors.white)
              // Image.asset(
              //   "assets/icons/$image",
              //   width: 20,
              //   height: 20,
              // ),
              ),
          onTap: () {
            onTap();
          },
          title: Text(title, style: TitleHelper.h9),
          trailing: const Icon(
            Icons.arrow_right,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
