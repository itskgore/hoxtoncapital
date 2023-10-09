import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/assest_liabiltiy_onboarding_entity.dart';

import '../../../../../../../core/common/functions/common_functions.dart';

class AccountDetails extends StatelessWidget {
  const AccountDetails({
    Key? key,
    required this.entity,
  }) : super(key: key);

  final AssetLiabilityOnboardingEntity entity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  getAccountFormat(entity.aggregator.extra.accountNumber),
                  textAlign: TextAlign.left,
                  style: TextHelper.h5.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: Text(
                  "${entity.amount.currency} ${NumberFormat("00000.00").format(entity.amount.amount)}",
                  textAlign: TextAlign.right,
                  style: TextHelper.h5.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          Text(
            entity.aggregator.extra.accountName,
            textAlign: TextAlign.left,
            style: TextHelper.h6.copyWith(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
