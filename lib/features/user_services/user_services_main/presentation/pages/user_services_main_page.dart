import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/entities/user_services_entity.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/features/user_services/pension_report_service/presentation/pages/pension_report_services_page.dart';
import 'package:wedge/features/user_services/uplead_documents/presentation/pages/upload_documents_main.dart';
import 'package:wedge/features/user_services/user_services_advisor/presentation/pages/user_adivsor_main.dart';
import 'package:wedge/features/user_services/user_services_main/presentation/cubit/getservices_cubit.dart';

import '../../../../../core/data_models/user_services_model.dart';
import '../../../document_service/presentation/pages/document_services_page.dart';

class UserServicesMainPage extends StatefulWidget {
  UserServicesMainPage({Key? key}) : super(key: key);

  @override
  State<UserServicesMainPage> createState() => _UserServicesMainPageState();
}

class _UserServicesMainPageState extends State<UserServicesMainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<GetservicesCubit>().getData(shouldLoad: true);
  }

  navigateToService(String code, RecordsEntity records) {
    if (code.toLowerCase() == "advisory-team") {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => UserAdvisorMainScreen(
                    servicesRecord: records,
                  )));
    } else if (code.toLowerCase() == "document") {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => UserDocumentServicesPage(
                    servicesRecord: records,
                  )));
    } else if (code.toLowerCase() == "upload-documents") {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => const UploadDocuments(),
        ),
      );
    } else if (code.toLowerCase() == "pensionreport") {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => PensionReportServicesPage(
                    servicesRecord: records,
                  )));
    }
  }

  final PageController _controller = PageController(
    initialPage: 0,
  );
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);

    return Scaffold(
      appBar: wedgeAppBar(context: context, title: translate!.services),
      backgroundColor: appThemeColors!.bg,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            BlocBuilder<GetservicesCubit, GetservicesState>(
              builder: (context, state) {
                if (state is GetservicesLoaded) {
                  ///Added document upload tab Manually
                  //Todo: Remove this once API is updated.
                  if (state.data.records.length == 5) {
                    state.data.records.insert(
                      2,
                      Records(
                        code: 'upload-documents',
                        name: 'Upload Documents',
                        isVisible: true,
                      ),
                    );
                  }
                  return Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children:
                          List.generate(state.data.records.length, (index) {
                        final data = state.data.records[index];
                        return data.isVisible
                            ? mainButtons(
                                title: data.name,
                                onTap: () {
                                  navigateToService(data.code, data);
                                })
                            : const SizedBox.shrink();
                      }),
                    ),
                  ));
                } else if (state is GetservicesLoding) {
                  return Expanded(
                      child: Center(
                    child: buildCircularProgressIndicator(width: 90),
                  ));
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Container mainButtons({
    required String title,
    required Function onTap,
  }) {
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: appThemeColors!.primary,
                borderRadius: BorderRadius.circular(10)),
            child: Icon(
              title.contains("Documents") ? Icons.folder : Icons.person,
              color: Colors.white,
              size: 20,
            ),
          ),
          onTap: () {
            onTap();
          },
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_right,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
