import 'dart:developer';

import 'package:wedge/core/contants/enums.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';

bool isAggregatorExpired({required dynamic data}) {
  bool isSaltedge = data.source.toLowerCase() ==
      AggregatorProvider.Saltedge.name.toLowerCase();
  bool isYodlee = data.source!.toLowerCase() ==
      AggregatorProvider.Yodlee.name.toLowerCase();
  if (isSaltedge) {
    if (data.aggregator?.status != "success") {
      //refresh the bank
      return true;
    } else if (data.aggregator!.consentExpireAt.isNotEmpty) {
      if (DateTime.parse(data.aggregator!.consentExpireAt)
          .isBefore(DateTime.now())) {
        return true;
      }
    }
    return false;
  } else if (isYodlee) {
    if (data.aggregator?.status != "success") {
      return true;
    }
    bool yodleeResult =
        data != null ? (data.aggregator!.isRealTimeMFA ?? false) : false;
    return yodleeResult;
  } else {
    return false;
  }
}

String aggregatorExpireMessage({dynamic data}) {
  bool isYodlee = data.source!.toLowerCase() ==
      AggregatorProvider.Yodlee.name.toLowerCase();
  bool isSaltedge = data.source.toLowerCase() ==
      AggregatorProvider.Saltedge.name.toLowerCase();
  if (isYodlee) {
    if (data.aggregator?.status != "success" ||
            data.aggregator?.isRealTimeMFA ??
        false) {
      return 'Lost connection!';
    } else {
      return '';
    }
  } else if (isSaltedge) {
    if (data.aggregator.consentExpireAt.isEmpty) {
      if (data.aggregator?.status != "success") {
        return 'Lost connection!';
      }
      return '';
    } else {
      DateTime expireDate = DateTime.parse(data.aggregator.consentExpireAt);
      int expireIn = expireDate.difference(DateTime.now()).inDays;
      log(expireIn.toString(), name: 'Expire in days');
      if (expireIn < 0) {
        return 'The connection authorisation has expired!';
      } else if (expireIn >= 0 && expireIn <= 14) {
        if (data.aggregator?.status != "success") {
          return 'Lost connection!';
        }
        return 'The connection authorisation’s duration will end ${expireIn == 0 ? 'today' : 'in $expireIn days'}!';
      } else {
        if (data.aggregator?.status != "success") {
          return 'Lost connection!';
        }
        return 'The connection authorisation will expire on ${dateFormatter6.format(expireDate)}!';
      }
    }
  } else {
    return '';
  }
}

String? aggregatorPopupMessage({dynamic data}) {
  bool isYodlee = data.source!.toLowerCase() ==
      AggregatorProvider.Yodlee.name.toLowerCase();
  bool isSaltedge = data.source.toLowerCase() ==
      AggregatorProvider.Saltedge.name.toLowerCase();
  if (isYodlee &&
      (data.aggregator?.status != "success" ||
          data.aggregator?.isRealTimeMFA)) {
    return translate
        ?.lostConnectionReconnectYourAccountToAccessTheLatestTransactions;
  } else if (isSaltedge) {
    if (data.aggregator.consentExpireAt.isEmpty) {
      if (data.aggregator?.status != "success") {
        return 'Lost connection! Reconnect your account to access the latest transactions';
      }
    } else {
      DateTime expireDate = DateTime.parse(data.aggregator.consentExpireAt);
      int expireIn = expireDate.difference(DateTime.now()).inDays;
      // log(expireIn.toString(), name: 'Expire in days');
      if (expireIn < 0) {
        return 'The connection authorisation has elapsed. Re-establish the account connection to receive the latest transaction updates.';
      } else if (expireIn >= 0 && expireIn <= 14) {
        if (data.aggregator?.status != "success") {
          return 'Lost connection! Reconnect your account to access the latest transactions';
        }
        return 'The connection authorisation will expire ${expireIn == 0 ? "today" : "in $expireIn days"}. Please reconnect your account now to ensure you continue receiving updated transactions.';
      } else if (data.aggregator?.status != "success") {
        return 'Lost connection! Reconnect your account to access the latest transactions';
      }
    }
  }
}

String getAccountFormat(dynamic number) {
  String accountNumber = number.toString();
  int length = accountNumber.length;
  if (length >= 4) {
    String lastFourDigits = accountNumber.substring(length - 4);
    int restOfTheLength = length - 4;
    for (int i = 0; i < restOfTheLength; i++) {
      lastFourDigits = "X$lastFourDigits";
    }
    return lastFourDigits;
  } else {
    int restOfTheLength = 4 - length;
    String copiedAccountNumber = accountNumber;
    for (int i = 0; i < restOfTheLength; i++) {
      copiedAccountNumber = "X$copiedAccountNumber";
    }
    return copiedAccountNumber;
  }
}

String getPopUpDescription(String source) {
  if (source.toLowerCase() == AggregatorProvider.Saltedge.name.toLowerCase()) {
    return translate!.saltedgeBody;
  } else if (source.toLowerCase() ==
      AggregatorProvider.Yodlee.name.toLowerCase()) {
    return translate!.yodleeBody;
  } else {
    // dummy default case
    return translate!.yodleeBody;
  }
}
