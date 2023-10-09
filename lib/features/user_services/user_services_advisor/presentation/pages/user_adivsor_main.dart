import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/user_services_entity.dart';
import 'package:wedge/core/helpers/textfeild_validator.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/widgets/wedge_app_bar.dart';
import 'package:wedge/features/user_services/user_services_advisor/presentation/cubit/useradvisor_cubit.dart';

class UserAdvisorMainScreen extends StatefulWidget {
  RecordsEntity servicesRecord;

  UserAdvisorMainScreen({Key? key, required this.servicesRecord})
      : super(key: key);

  @override
  _UserAdvisorMainScreenState createState() => _UserAdvisorMainScreenState();
}

class _UserAdvisorMainScreenState extends State<UserAdvisorMainScreen> {
  late TemplatesEntity templatesEntity;

  @override
  void initState() {
    widget.servicesRecord.templates?.forEach((element) {
      if (element.name.toLowerCase() == "list-mobile") {
        templatesEntity = element;
      }
    });
    getServices();
    super.initState();
  }

  ServicesEntity? services;

  getServices() {
    widget.servicesRecord.services?.forEach((element) {
      if (element.description.contains("advisory-team")) {
        services = element;
      }
    });
    getAdvisor(services);
  }

  getAdvisor(ServicesEntity? services) {
    if (services != null) {
      context.read<UseradvisorCubit>().getAdvisors({},
          "${services.description}/${services.code}/execute",
          widget.servicesRecord);
    }
  }

  TextFieldValidator validator = TextFieldValidator();

  assignStyle(int index) {
    switch (index) {
      case 0:
        return SubtitleHelper.h10.copyWith(fontWeight: FontWeight.w600);
      case 1:
        return TitleHelper.h9;
      default:
        return SubtitleHelper.h10.copyWith(
            fontWeight: FontWeight.w400, color: appThemeColors!.textDark);
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  urlLuncher(String data, bool isEmail) async {
    if (isEmail) {
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: '$data',
        query: encodeQueryParameters(<String, String>{
          'subject': 'Example Subject & Symbols are allowed!'
        }),
      );
      await launchUrl(emailLaunchUri);
    } else {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: data,
      );
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appThemeColors!.bg,
      appBar: WedgeAppBar(
        heading: widget.servicesRecord.name,
      ),
      body: BlocBuilder<UseradvisorCubit, UseradvisorState>(
        builder: (context, state) {
          if (state is UseradvisorLoading) {
            return Center(
              child: buildCircularProgressIndicator(width: 100),
            );
          } else if (state is UseradvisorLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  state.userAdvisor.length == 0
                      ? Center(
                          child: Text(
                          "No Data Found!",
                          style: SubtitleHelper.h10,
                        ))
                      : Column(
                          children:
                              List.generate(state.userAdvisor.length, (index) {
                            String image =
                                state.userAdvisor[index]['imageUrl'] ?? "";
                            final data = state.userAdvisor[index];
                            data.removeWhere((key, value) => key == "imageUrl");
                            data.removeWhere((key, value) => value == null);
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 9.9,
                                        spreadRadius: 0.5),
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // isImage
                                  Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          color: appThemeColors!.primary,
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: image.isNotEmpty
                                                  ? NetworkImage(
                                                      image,
                                                    )
                                                  : const AssetImage(
                                                      "assets/images/hoxtonlogo_light.png",
                                                    ) as ImageProvider))),

                                  const SizedBox(
                                    width: 15,
                                  ),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(data.length, (i) {
                                        final value = data.values.toList()[i];
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Row(
                                            children: [
                                              validator.checkIfEmail("$value")
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        urlLuncher(value, true);
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 6),
                                                        child: CircleAvatar(
                                                            radius: 15,
                                                            backgroundColor:
                                                                appThemeColors!
                                                                    .outline,
                                                            child: const Icon(
                                                              Icons
                                                                  .mail_outline,
                                                              size: 18,
                                                            )),
                                                      ),
                                                    )
                                                  : Container(),
                                              validator.isNumeric("$value")
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        urlLuncher(
                                                            value, false);
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 6),
                                                        child: CircleAvatar(
                                                            radius: 15,
                                                            backgroundColor:
                                                                appThemeColors!
                                                                    .outline,
                                                            child: const Icon(
                                                              Icons.call,
                                                              size: 15,
                                                            )),
                                                      ),
                                                    )
                                                  : Container(),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (validator.checkIfEmail(
                                                        value ?? "")) {
                                                      urlLuncher(value, true);
                                                    } else if (validator
                                                        .isNumeric(
                                                            value ?? "")) {
                                                      urlLuncher(value, false);
                                                    }
                                                  },
                                                  child: Text(
                                                    value ?? "",
                                                    style: assignStyle(i),
                                                    overflow:
                                                        TextOverflow.visible,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                        ),
                ],
              ),
            );
          } else if (state is UseradvisorError) {
            return Center(
              child: Text(state.error, style: TitleHelper.h9),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
