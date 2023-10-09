import 'package:flutter/material.dart';

class BankDataPlaceHolder extends StatelessWidget {
  const BankDataPlaceHolder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 30),
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          height: 13,
          width: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(33),
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: List.generate(3, (index) => const AccountDataCard()),
        ),
      ],
    );
  }
}

class AccountDataCard extends StatelessWidget {
  const AccountDataCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  height: 13,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(33),
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 60),
              Expanded(
                flex: 2,
                child: Container(
                  height: 13,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(33),
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            height: 10,
            width: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(33),
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
