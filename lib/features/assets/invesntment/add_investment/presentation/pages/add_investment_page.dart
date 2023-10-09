import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/features/assets/invesntment/yodlee_investment_frame/presentation/pages/yodlee_investment_frame_page.dart';

class AddInvestmentPage extends StatefulWidget {
  const AddInvestmentPage({super.key});

  @override
  _AddInvestmentPageState createState() => _AddInvestmentPageState();
}

class _AddInvestmentPageState extends State<AddInvestmentPage> {
  bool textFieldClicked = false;

  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(translate!.addInvestmentPlatforms),
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
                    labelText: translate.searchYourInvestmentBroker,
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
                  translate.orSelectFromTheBrokersBelow,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: kfontMedium),
                ),
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
                                YodleeInvestmentFramePage()));
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      // border: Border.all(color: Colors.grey),
                      image: DecorationImage(
                        image: AssetImage("assets/images/hoxton_app_logo.png"),
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
              onPressed: () {},
              child: Text(
                translate.manuallyAddanInvestmentAccount,
                style:
                    const TextStyle(color: Colors.blue, fontSize: kfontMedium),
              )),
        ],
      ),
    );
  }
}
