import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/assets/pension/add_pension_manual/presentation/pages/add_pension_manual_page.dart';
import 'package:wedge/features/assets/pension/yodlee_pension_frame/presentation/pages/yodlee_pension_frame_page.dart';

import '../../../../../../core/widgets/dialog/wedge_comfirm_dialog.dart';

class AddPensionPage extends StatefulWidget {
  const AddPensionPage({super.key});

  @override
  _AddPensionPageState createState() => _AddPensionPageState();
}

class _AddPensionPageState extends State<AddPensionPage> {
  bool textFieldClicked = false;

  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("${translate!.add} ${translate.pensions}"),
      ),
      backgroundColor: kBackgroundColor,
      body: ListView(
        children: [
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text("Here is the summery of information from the records"),
                TextField(
                  onTap: () {},
                  onChanged: (val) {
                    if (val.isNotEmpty) {
                      setState(() {
                        textFieldClicked = true;
                      });
                    } else {
                      setState(() {
                        textFieldClicked = false;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(
                        borderRadius: ktextfeildBorderRadius,
                        borderSide: BorderSide(color: Colors.grey)),
                    prefixIcon: const Icon(Icons.search),
                    labelText: translate.searchYourPensionProvider,
                    prefixText: ' ',
                    // suffixStyle: const TextStyle(color: Colors.green)
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Visibility(
                  visible: textFieldClicked,
                  child: Container(
                    color: Colors.white,
                    height: 300,
                    child: MediaQuery.removePadding(
                      removeTop: true,
                      removeBottom: true,
                      context: context,
                      child: ListView.builder(
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            return const Column(
                              children: [
                                ListTile(
                                  title: Text("Emirates NBD"),
                                ),
                                Divider()
                              ],
                            );
                          }),
                    ),
                  ),
                ),
                Text(
                  translate.orSelectFromthePensionProvidersBelow,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: kfontMedium),
                ),
                // SizedBox(
                //   height: 10,
                // ),
                // Divider(
                //   height: 1,
                // )
              ],
            ),
          ),
          GridView.count(
            padding: const EdgeInsets.only(top: 0),
            crossAxisCount: 3,
            crossAxisSpacing: 0.0,
            mainAxisSpacing: 0.0,
            shrinkWrap: true,
            children: List.generate(7, (index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                YodleePensionFramePage()));
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      // border: Border.all(color: Colors.grey),
                      image: DecorationImage(
                        image: AssetImage("assets/images/logo_dark.png"),
                        // NetworkImage(
                        //     'https://www.fintechfutures.com/files/2016/06/emirates-nbd.jpg'),
                        fit: BoxFit.contain,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(16.0),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (BuildContext context) =>
                            AddPensionManualPage()));
              },
              child: Text(
                translate.addaPensionManually,
                style:
                    const TextStyle(color: Colors.blue, fontSize: kfontMedium),
              )),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: SizedBox(
            height: 20,
            child: OutlinedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))),
              ),
              onPressed: () {
                locator.get<WedgeDialog>().confirm(
                      context,
                      WedgeConfirmDialog(
                        title: translate.itJustTakesaMinute,
                        subtitle: translate.remeberMoreAccurateMessage,
                        acceptText: ADD_BANK_ACCOUNT,
                        acceptedPress: () {
                          Navigator.pop(context);
                        },
                        deniedText: SKIP_ANYWAY,
                        deniedPress:
                            () {}, //TODO : @shahbaz why that button is not doing anything
                      ),
                    );
              },
              child: const Text(
                SKIP,
                style: TextStyle(
                    color: kfontColorDark,
                    fontSize: kfontMedium,
                    fontFamily: kfontFamily),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
