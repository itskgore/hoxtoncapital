import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/features/assets/crypto/add_crypto_manual/presentation/pages/add_crypto_manual_page.dart';
import 'package:wedge/features/assets/crypto/yodlee_crypto_frame/presentation/pages/yodlee_crypto_frame_page.dart';

class AddCryptoPage extends StatefulWidget {
  // AddCryptoPage({Key key}) : super(key: key);

  @override
  _AddCryptoPageState createState() => _AddCryptoPageState();
}

class _AddCryptoPageState extends State<AddCryptoPage> {
  bool textfieldClicked = false;

  // = WedgeDialog();
  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(translate!.linkYourCryptoExchange),
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
                        textfieldClicked = true;
                      });
                    } else {
                      setState(() {
                        textfieldClicked = false;
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
                    labelText: translate.searchYourCryptoExchange,
                    prefixText: ' ',
                    // suffixStyle: const TextStyle(color: Colors.green)
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Visibility(
                  visible: textfieldClicked,
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
                  translate.orSelectFromtheExchangesBelow,
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
                                YodleeCryptoFramePage()));
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
                            const AddCryptoManualPage()));
              },
              child: Text(
                translate.manuallyAddCryptoCurrencies,
                style:
                    const TextStyle(color: Colors.blue, fontSize: kfontMedium),
              )),
        ],
      ),
    );
  }
}
