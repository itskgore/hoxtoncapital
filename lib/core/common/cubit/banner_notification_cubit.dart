import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/common/domain/usecases/get_notification_banner_usecase.dart';
import 'package:wedge/core/common/domain/usecases/update_notification_banner_usecase.dart';
import 'package:wedge/core/data_models/assets_model.dart';
import 'package:wedge/core/data_models/liabilities_model.dart';
import 'package:wedge/core/data_models/notification_model.dart';
import 'package:wedge/core/entities/investment_entity.dart';
import 'package:wedge/core/entities/pension_entity.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/home/data/model/banner_model.dart';

import '../../../app.dart';
import '../../../features/assets/bank_account/main_bank_account/presentation/pages/bank_account_summary.dart';
import '../../../features/assets/custom_assets/custom_assets_main/presentation/pages/custom_assets_main_page.dart';
import '../../../features/assets/properties/properties_main/presentation/pages/properties_main_page.dart';
import '../../../features/assets/vehicle/vehicle_main/presentation/pages/vehicles_main_page.dart';
import '../../../features/invite_friends/presentation/pages/invite_friends_screen.dart';
import '../../../features/liabilities/credit_card/credit_card_debt_main/presentation/pages/credit_card_account_summary.dart';
import '../../../features/liabilities/mortgages/mortgages_main/presentation/pages/mortgage_main_page.dart';
import '../../../features/liabilities/other_liabilities/other_liabilities_main/presentation/pages/other_liabilities_main_page.dart';
import '../../../features/liabilities/personal_loan/personal_loan_main/presentation/pages/personal_loan_main_page.dart';
import '../../../features/liabilities/vehicle_loan/vehicle_loan_main/presentation/pages/vehicle_loan_main_page.dart';
import '../../../features/your_investments/presentation/pages/your_investments_main.dart';
import '../../../features/your_pensions/presentation/pages/your_pensions_main.dart';
import '../../config/app_config.dart';
import '../../entities/credit_cards_entity.dart';
import '../../helpers/navigators.dart';
import 'banner_notification_state.dart';

class BannerNotificationCubit extends Cubit<BannerNotificationState> {
  GetNotificationAndBannerUseCase getNotificationAndBannerUseCase;
  UpdateNotificationAndBannerUseCase updateNotificationAndBannerUseCase;
  BannerNotificationCubit(this.getNotificationAndBannerUseCase,
      this.updateNotificationAndBannerUseCase)
      : super(BannerNotificationInitial());

  getBannerNotification(
      {required bool isNotificationLoading, bool? isInitial}) {
    if (isInitial ?? false) {
      emit(BannerNotificationInitialLoading());
    } else {
      emit(BannerNotificationLoading(
          isNotificationLoading: isNotificationLoading));
    }

    final result = getNotificationAndBannerUseCase(NoParams());
    result.then((value) => value.fold((l) {
          emit(BannerNotificationError(
              l.responseMsg ?? l.displayErrorMessage()));
        }, (r) {
          List<BannerModel> bannerModelList = [];
          List<NotificationModel> notificationModelList = [];
          for (var item in r) {
            if (item["displayAs"].toString().toLowerCase() == "banner") {
              BannerModel bannerModel = BannerModel.fromJson(item);
              bannerModelList.add(bannerModel);
            }
            if (item["displayAs"].toString().toLowerCase() == "notification") {
              NotificationModel notificationModel =
                  NotificationModel.fromJson(item);
              notificationModelList.add(notificationModel);
            }
          }
          emit(BannerNotificationLoaded(
              bannerModel: bannerModelList,
              notificationModel: notificationModelList));
        }));
  }

  updateNotificationBanner(
      {required bool isNotificationLoading,
      bool? isInitial,
      bool? isIndividual,
      NotificationModel? notificationModel,
      required List<Map<String, dynamic>> params}) {
    if (isNotificationLoading) {
      if (isIndividual ?? false) {
        // On notificationCard clicked push to Corresponding Screen
        cupertinoNavigator(
          context: navigatorKey.currentContext!,
          screenName: _getScreenName(notificationModel!),
          type: NavigatorType.PUSH,
        );
      }
    } else {
      // On banner click push to Invite Friends Screen
      cupertinoNavigator(
        context: navigatorKey.currentContext!,
        screenName: const InviteFriendsScreen(),
        type: NavigatorType.PUSH,
      );
    }

    if (isInitial ?? false) {
      emit(BannerNotificationInitialLoading());
    } else {
      emit(BannerNotificationLoading(
          isNotificationLoading: isNotificationLoading));
    }
    final result = updateNotificationAndBannerUseCase(params);
    result.then((value) => value.fold((l) {
          emit(BannerNotificationError(
              l.responseMsg ?? l.displayErrorMessage()));
        }, (r) {
          getBannerNotification(isNotificationLoading: isNotificationLoading);
        }));
  }

  _getScreenName(NotificationModel notificationModel) {
    if (notificationModel.extras?.type.toString().toLowerCase() ==
        'bankaccounts') {
      return BankAccountSummary(accountID: notificationModel.extras?.id ?? '');
    } else if (notificationModel.extras?.type.toString().toLowerCase() ==
        'properties') {
      return PropertiesMainPage(id: notificationModel.extras?.id ?? '');
    } else if (notificationModel.extras?.type.toString().toLowerCase() ==
        'otherassets') {
      return CustomAssetsMainPage(id: notificationModel.extras?.id ?? '');
    } else if (notificationModel.extras?.type.toString().toLowerCase() ==
        'vehicles') {
      return VehiclesMainPage(id: notificationModel.extras?.id ?? '');
    } else if (notificationModel.extras?.type.toString().toLowerCase() ==
        'personalloans') {
      return PersonalLoanMainPage(id: notificationModel.extras?.id ?? '');
    } else if (notificationModel.extras?.type.toString().toLowerCase() ==
        'mortgages') {
      return MortgageMainPage(id: notificationModel.extras?.id ?? '');
    } else if (notificationModel.extras?.type.toString().toLowerCase() ==
        'vehicleloans') {
      return VehicleLoanMainPage(id: notificationModel.extras?.id ?? '');
    } else if (notificationModel.extras?.type.toString().toLowerCase() ==
        'otherliabilities') {
      return OtherLiabilitiesMainPage(id: notificationModel.extras?.id ?? '');
    } else {
      // getting assets from local storage
      final data = jsonDecode(locator<SharedPreferences>()
              .getString(RootApplicationAccess.assetsPreference) ??
          '');
      AssetsModel assetsModel = AssetsModel.fromJson(data);

      // cases for navigation
      if (notificationModel.extras?.type.toString().toLowerCase() ==
          'pensions') {
        final pensionList = assetsModel.pensions;
        PensionsEntity pensionsEntity = pensionList.firstWhere(
            (element) => element.id == (notificationModel.extras?.id ?? ''));

        // returning screen
        return YourPensionsMain(pensionsEntity: pensionsEntity);
      } else if (notificationModel.extras?.type.toString().toLowerCase() ==
          'investments') {
        final investmentList = assetsModel.investments;
        InvestmentEntity investmentEntity = investmentList.firstWhere(
            (element) => element.id == (notificationModel.extras?.id ?? ''));

        // returning screen
        return YourInvestmentsMain(investmentEntity: investmentEntity);
      } else if (notificationModel.extras?.type.toString().toLowerCase() ==
          'creditcards') {
        // getting liabilities from local storage
        final data = jsonDecode(locator<SharedPreferences>()
            .getString(RootApplicationAccess.liabilitiesPreference)!);
        LiabilitiesModel liabilitiesModel = LiabilitiesModel.fromJson(data);

        // generating credit card entity
        final creditCardList = liabilitiesModel.creditCards;
        CreditCardsEntity creditCardsEntity = creditCardList.firstWhere(
            (element) => element.id == (notificationModel.extras?.id ?? ''));

        // returning screen
        return CreditCardAccountSummary(cardData: creditCardsEntity);
      }
    }
  }
}
