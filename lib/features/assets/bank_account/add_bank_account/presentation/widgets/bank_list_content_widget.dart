import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart' as filepath;
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/provider_records_entity.dart';
import 'package:wedge/features/assets/bank_account/yodlee_frame/presentation/pages/yodlee_frame_page.dart';

class BankListContent extends StatelessWidget {
  final List<ProviderRecordsEntity> providers;
  final Function(bool, {required String source}) successPopUps;

  const BankListContent({
    super.key,
    required this.providers,
    required this.successPopUps,
  });

  String _getExtension(url) {
    final extension = filepath.extension(url);
    return extension;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.only(top: 0),
      crossAxisCount: 2,
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      // to disable GridView's scrolling

      children: List.generate(providers.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (BuildContext context) => YodleeFramePage(
                            providerName: providers[index].integrator,
                            successPopUpp: (_, {required String source}) {
                              successPopUps(_, source: source);
                            },
                            institutionId: providers[index].institutionId,
                            institutelogo: providers[index].logo,
                          )));
            },
            child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5.0,
                      spreadRadius: 0.0,
                      offset: const Offset(1.0, 3.0),
                    ),
                  ],
                ),
                child: banksContainer(
                    image: providers[index].logo,
                    isSVG: _getExtension(providers[index].logo).toLowerCase() ==
                        ".svg",
                    title: providers[index].institution)),
          ),
        );
      }),
    );
  }

  banksContainer(
      {required String image, required String title, required bool isSVG}) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
            child: isSVG
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: SvgPicture.network(
                      image,
                      fit: BoxFit.contain,
                      placeholderBuilder: (e) {
                        return Image.asset(
                          "assets/icons/bankAccountMainContainer.png",
                          width: 40,
                          height: 40,
                        );
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: Image.network(
                      image,
                      fit: BoxFit.contain,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Image.asset(
                          "assets/icons/bankAccountMainContainer.png",
                          width: 40,
                          height: 40,
                        );
                      },
                    ),
                  ),
          ),
        ),
        // Spacer(),

        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: SubtitleHelper.h11,
        )
      ],
    );
  }
}
