import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';

class WedgeCard extends StatelessWidget {
  final String value;
  final IconData icon;
  final Function onTap;
  const WedgeCard(
      {required this.value, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
        //  Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListTile(
                leading: Icon(
                  icon,
                  size: 30,
                  color: appThemeColors!.primary,
                ),
                title: Text(
                  value,
                  style: const TextStyle(fontSize: kfontLarge),
                ),
                subtitle: const Text(
                  "text",
                  style: TextStyle(fontSize: kfontMedium),
                ),
                trailing: const Icon(Icons.menu),
              )),
        ),
      ),
    );
  }
}
