import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/features/assets/crypto/crypto_main/presentation/pages/crypto_main_page.dart';

class YodleeCryptoFramePage extends StatefulWidget {
  const YodleeCryptoFramePage({super.key});

  @override
  _YodleeCryptoFramePageState createState() => _YodleeCryptoFramePageState();
}

class _YodleeCryptoFramePageState extends State<YodleeCryptoFramePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Crypto Integrator Login Interface"),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const CryptoMainPage()));
                },
                child: const Text("next"))
          ],
        ),
      ),
    );
  }
}
