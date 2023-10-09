import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/user_services_entity.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/user_services/document_service/presentation/pages/view_hoxton_documents.dart';

import '../../../../../core/contants/string_contants.dart';
import '../../../../../core/entities/user_services_document_entity.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/wedge_app_bar.dart';
import '../../../../../core/widgets/folder_tile.dart';
import '../../../generic_domain/generic_usecases/get_documents_usecase.dart';

class UserDocumentServicesPage extends StatefulWidget {
  RecordsEntity servicesRecord;

  UserDocumentServicesPage({Key? key, required this.servicesRecord})
      : super(key: key);

  @override
  State<UserDocumentServicesPage> createState() =>
      _UserDocumentServicesPageState();
}

class _UserDocumentServicesPageState extends State<UserDocumentServicesPage> {
  @override
  void initState() {
    super.initState();
    getData(urlParameters: "document/view/execute");
  }

  List<DocumentRecordsEntity> records = [];

  getData({String? urlParameters}) {
    final GetDocumentUsecase getDocumentUsecase =
        locator.get<GetDocumentUsecase>();
    final body = {"parentFolderId": ""};
    final result =
        getDocumentUsecase({"body": body, "paramerters": urlParameters});
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getData(urlParameters: urlParameters);
        } else {}
      }, (data) {
        records = data.records;
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);
    return Scaffold(
        backgroundColor: appThemeColors!.bg,
        appBar: wedgeAppBar(
            context: context, title: translate?.hoxtonDocuments ?? ''),
        body: records.isEmpty
            ? Center(
                child: buildCircularProgressIndicator(width: 90),
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: records
                                  .where((element) => element.hasFiles)
                                  .isEmpty
                              ? Center(
                                  child: Text(
                                    'No documents uplaoded',
                                    style: SubtitleHelper.h10,
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  itemCount: records.length,
                                  itemBuilder: (con, index) {
                                    return FolderTile(
                                      title: records[index].name == 'LOA'
                                          ? "Letter Of Authority (LOA)"
                                          : records[index].name,
                                      onTap: () async {
                                        // await getData(state
                                        //     .folders[index].id
                                        //     .toString());
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                ViewHoxtonDocuments(
                                              folderID: records[index].id,
                                            ),
                                          ),
                                        );
                                      },
                                      isSubtitleDate: true,
                                      subTitle: records[index].hasFiles
                                          ? dateFormatter.format(DateTime.parse(
                                              records[index].lastUpdatedAt))
                                          : null,
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ));
  }
}
