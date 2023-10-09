import 'package:wedge/core/common/data/datasource/common_datasource.dart';
import 'package:wedge/features/account/third_party_access/data/datasource/remote_data_third_party_access.dart';
import 'package:wedge/features/aggregation_results/data/datasource/local_results.dart';
import 'package:wedge/features/aggregation_results/data/datasource/remote_results.dart';
import 'package:wedge/features/all_accounts_types/data/data_sources/assets_liabilities_data_source.dart';
import 'package:wedge/features/all_accounts_types/data/data_sources/local_assets_liab_data_source.dart';
import 'package:wedge/features/app_passcode/create_passcode/data/datasource/remote_create_passcode_datasource.dart';
import 'package:wedge/features/assets/all_assets/data/data_sources/local_get_all_assets_data_source.dart';
import 'package:wedge/features/assets/assets_liablities_main/data/data_sources/local_get_all_assets_data_source.dart';
import 'package:wedge/features/assets/assets_liablities_main/data/data_sources/remote_get_all_assets_data_sorce.dart';
import 'package:wedge/features/assets/bank_account/add_bank_account/data/data_sources/get_provider_records_datasource.dart.dart';
import 'package:wedge/features/assets/bank_account/add_bank_manual/data/data_sources/add_manual_bank_data_source.dart';
import 'package:wedge/features/assets/bank_account/bank_accounts/data/data_sources/local_get_home_bankaccounts_source.dart';
import 'package:wedge/features/assets/bank_account/bank_accounts/data/data_sources/remote_bank_accounts_data_source.dart.dart';
import 'package:wedge/features/assets/bank_account/bank_success_screen/data/datasource/get_account_data_datasource.dart';
import 'package:wedge/features/assets/bank_account/main_bank_account/data/data_sources/local_get_bankaccounts_source.dart';
import 'package:wedge/features/assets/bank_account/main_bank_account/data/data_sources/remote_bank_accounts_data_source.dart.dart';
import 'package:wedge/features/assets/bank_account/userdata_summery/data/data_sources/hoxton_userdata_source.dart';
import 'package:wedge/features/assets/bank_account/yodlee_frame/data/data_sources/get_yodleee_token_datasource.dart';
import 'package:wedge/features/assets/crypto/add_crypto_manual/data/datasource/remote_add_crypto_datasource.dart';
import 'package:wedge/features/assets/crypto/crypto_main/data/datasource/local_cryto_datasource.dart';
import 'package:wedge/features/assets/crypto/crypto_main/data/datasource/remote_cryto_datasource.dart';
import 'package:wedge/features/assets/crypto/crypto_search/data/datasource/remote_search_crypto.dart';
import 'package:wedge/features/assets/custom_assets/add_custom_assets/data/data_sources/add_custom_assets_data_source.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_drop_down/data/datasource/remote_custom_assets_drop_down.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_main/data/data_sources/local_get_custom_assets_source.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_main/data/data_sources/remote_custom_assets_data_source.dart.dart';
import 'package:wedge/features/assets/invesntment/add_investment_manual/data/data_sources/add_investment_data_source.dart';
import 'package:wedge/features/assets/invesntment/investment_main/data/data_sources/local_get_investments_source.dart';
import 'package:wedge/features/assets/invesntment/investment_main/data/data_sources/remote_investments_data_source.dart';
import 'package:wedge/features/assets/pension/add_pension_manual/data/data%20source/add_manual_data.dart';
import 'package:wedge/features/assets/pension/pension_main/data/datasource/local_pensions_datasource.dart';
import 'package:wedge/features/assets/pension/pension_main/data/datasource/remote_pensions_datasource.dart';
import 'package:wedge/features/assets/pension_investment/pension_investments_main/data/data_sources/hoxton_userdata_source.dart';
import 'package:wedge/features/assets/properties/add_properties/data/data_sources/add_properties_data_source.dart';
import 'package:wedge/features/assets/properties/properties_main/data/data_sources/local_get_properties_source.dart';
import 'package:wedge/features/assets/properties/properties_main/data/data_sources/remote_properties_data_source.dart.dart';
import 'package:wedge/features/assets/stocks/add_stcoks/data/data_sources/add_stocks_data_source.dart';
import 'package:wedge/features/assets/stocks/search_stocks/data/datasource/remote_search_stocks.dart';
import 'package:wedge/features/assets/stocks/stocks_main/data/data_sources/local_get_stocks_source.dart';
import 'package:wedge/features/assets/stocks/stocks_main/data/data_sources/remote_stocks_data_source.dart.dart';
import 'package:wedge/features/assets/vehicle/add_vehicle/data/data_sources/add_vehicle_data_source.dart';
import 'package:wedge/features/assets/vehicle/vehicle_main/data/data_sources/local_get_vehicles_source.dart';
import 'package:wedge/features/assets/vehicle/vehicle_main/data/data_sources/remote_vehicles_data_source.dart';
import 'package:wedge/features/auth/create_password/data/datasource/create_password_datasource.dart';
import 'package:wedge/features/auth/hoxton_login/data/data_sources/local_login_data_source.dart';
import 'package:wedge/features/auth/hoxton_login/data/data_sources/login_data_source.dart';
import 'package:wedge/features/auth/terms_and_condition/data/datasource/remote_term_condition_datasource.dart';
import 'package:wedge/features/beneficiary/beneficiary_add/data/datasource/remote_add_edit_beneficiary_datasource.dart';
import 'package:wedge/features/beneficiary/beneficiary_trusted_main/data/datasource/remote_get_beneficiary_datasource.dart';
import 'package:wedge/features/beneficiary/trusted_add/data/datasource/remote_add_edit_trusted_member_datasource.dart';
import 'package:wedge/features/calculators/retirement_calculator/data/data_sources/get_calculator_insights_data_source.dart';
import 'package:wedge/features/change_passcode/data/datasource/change_passcode_datasource.dart';
import 'package:wedge/features/change_password/data/datasource/change_password_datasource.dart';
import 'package:wedge/features/home/data/data_source/remote_dashboard_datasource.dart';
import 'package:wedge/features/liabilities/add_liabilities_page/data/datasource/local_get_liabilites.dart';
import 'package:wedge/features/liabilities/credit_card/add_credit_card_debt/data/datasource/remote_add_update_credit_cards_.dart';
import 'package:wedge/features/liabilities/credit_card/credit_card_debt_main/data/datasource/local_credit_card_datasource.dart';
import 'package:wedge/features/liabilities/credit_card/credit_card_debt_main/data/datasource/remote_credit_card_datasource.dart';
import 'package:wedge/features/liabilities/mortgages/add_mortgages/data/datasource/add_update_mortgages_datasource.dart';
import 'package:wedge/features/liabilities/mortgages/mortgages_main/data/datasoource/local_main_mortage.dart';
import 'package:wedge/features/liabilities/mortgages/mortgages_main/data/datasoource/remote_main_mortage.dart';
import 'package:wedge/features/liabilities/other_liabilities/add_other_liabilities/data/datasource/remote_add_update_other_liabilities_datasource.dart';
import 'package:wedge/features/liabilities/other_liabilities/other_liabilities_main/data/datasource/local_main_other_liabilities.dart';
import 'package:wedge/features/liabilities/other_liabilities/other_liabilities_main/data/datasource/remote_main_other_liabilities.dart';
import 'package:wedge/features/liabilities/personal_loan/add_personal_loan/data/data_sources/add_personal_loan_data_source.dart';
import 'package:wedge/features/liabilities/personal_loan/personal_loan_main/data/datasource/local_get_personal_loan.dart';
import 'package:wedge/features/liabilities/personal_loan/personal_loan_main/data/datasource/remote_personal_loan.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/data/datasource/remote_add_vehicle_loans.dart';
import 'package:wedge/features/liabilities/vehicle_loan/vehicle_loan_main/data/datasource/local_main_vehicle_loans.dart';
import 'package:wedge/features/liabilities/vehicle_loan/vehicle_loan_main/data/datasource/remote_main_vehicle_loans.dart';
import 'package:wedge/features/support/data/datasource/remote_support_account_datasource.dart';
import 'package:wedge/features/user_services/generic_data/generic_remote_datasource.dart';
import 'package:wedge/features/user_services/uplead_documents/data/datasource/remote_upload_document_main_datasource.dart';
import 'package:wedge/features/wealth_vault/documents/data/data_sources/remote_document_datasource.dart';
import 'package:wedge/features/your_investments/data/datasource/remote_your_investment_datasource.dart';
import 'package:wedge/features/your_pensions/data/datasource/remote_your_pensions_datasource.dart';

import '../core/common/line_performance_graph/data/datasource/remote_line_performance_graph_datasource.dart';
import '../dependency_injection.dart';
import '../features/account/my_account/data/datasource/remote_user_account_data.dart';
import '../features/auth/personal_details/data/datasource/remote_personal_details_datasource.dart';
import '../features/auth/signup/data/datasource/remote_signup_datasource.dart';
import '../features/invite_friends/data/data_source/remote_invitr_friend_datasource.dart';
import '../features/user_services/uplead_documents/data/datasource/remote_upload_document_datasource.dart';
import '../features/user_services/uplead_documents/data/datasource/remote_view_uploaded_documents.dart';
import '../features/your_investments/data/datasource/remote_investment_notes_datasources.dart';
import '../features/your_pensions/data/datasource/remote_pension_notes_datasources.dart';

class RegisterDataSources {
  RegisterDataSources() {
    locator.registerLazySingleton<LoginDataSource>(
      () => LoginDataSourceImpl(),
    );
    locator.registerLazySingleton<LocalLoginDataSource>(
      () => LocalLoginDataSourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<HoxtonUserDataSource>(
      () => HoxtonUserDataSourceImpl(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<AssetsLiabilitiesdataSource>(
      () => AssetsLiabilitiesDataSourceImpl(),
    );

    locator.registerLazySingleton<LocalAssetsLiabilitiesDataSource>(
      () => LocalAssetsLiabilitiesDataSourceImp(sharedPreferences: locator()),
    );

    locator.registerLazySingleton<LocalAllAssetsDataSource>(
      () => LocalAllAssetsDataSourceSourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<AddManualBankDataSource>(
      () => AddManualBankDataSourceImpl(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<LocalBankAccountsDataSource>(
      () => LocalBankAccountsDataSourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<RemoteBankAccountDataSource>(
      () => RemoteBankAccountDataSourceImpl(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<LocalCustomAssetsDataSource>(
      () => LocalCustomAssetsDataSourceImp(sharedPreferences: locator()),
    );

    locator.registerLazySingleton<RemoteCustomAssetsSource>(
      () => RemoteCustomAssetsSourceImpl(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<AddCustomAssetsDataSource>(
      () => AddCustomAssetsDataSourceImpl(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<LocalPropertiesDataSource>(
      () => LocalPropertiesDataSourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<RemotePropertiesSource>(
      () => RemotePropertiesSourceImpl(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<AddPropertiesDataSource>(
      () => AddPropertiesDataSourceImpl(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<AddStocksDataSource>(
      () => AddStocksDataSourceImpl(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<LocalStocksDataSource>(
      () => LocalStocksDataSourceImp(sharedPreferences: locator()),
    );

    locator.registerLazySingleton<RemoteStocksSource>(
      () => RemoteStocksSourceImpl(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<RemoteInvestmentsSource>(
      () => RemoteInvestmentsSourceImpl(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<LocalInvestmentsDataSource>(
      () => LocalInvestmentsDataSourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<AddInvestmentDataSource>(
      () => AddInvestmentDataSourceImpl(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<LocalVehiclesDataSource>(
      () => LocalVehiclesDataSourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<RemoteVehiclesSource>(
      () => RemoteVehiclesSourceImpl(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<AddVehicleDataSource>(
      () => AddVehicleDataSourceImpl(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<AddPersonalLoanDataSource>(
      () => AddPersonalLoanDataSourceImpl(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<AddManualPensionDataSource>(
      () => AddManualPensionDataSourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<LocalPensionsDataSource>(
      () => LocalPensionsDataSourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<RemotePensionsDataSource>(
        () => RemotePensionsDataSourceImp(sharedPreferences: locator()));
    locator.registerLazySingleton<LocalPersonalLoanDataSource>(
      () => LocalPersonalLoanDataSourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<RemoteMainPersonalLoanDataSource>(
      () => RemoteMainPersonalLoanDataSourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<LocalGetLiabilities>(
      () => LocalGetLiabilitiesImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<LocalCryptoCurrenciesDataSource>(
      () => LocalCryptoCurrenciesDataSourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<RemoteCryptoDataSrouce>(
      () => RemoteCryptoDataSrouceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<RemoteAddUpdateCryptoDataSource>(
      () => RemoteAddUpdateCryptoDataSourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<RemoteCreditCardDatasource>(
      () => RemoteCreditCardDatasourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<RemoteLinePerformanceGraphDatasource>(
      () =>
          RemoteLinePerformanceGraphDatasourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<PersonalDetailsSource>(
      () => PersonalDetailsSourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<SignUpDataSource>(
      () => SignupSourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<UploadDocumentDataSource>(
      () => UploadDocumentSourceImp(),
    );
    locator.registerLazySingleton<LocalCreditCardDatasource>(
      () => LocalCreditCardDatasourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<RemoteAddUpadteCreditCards>(
      () => RemoteAddUpadteCreditCardsImp(sharedPreferences: locator()),
    );

    locator.registerLazySingleton<RemoteVehicleLoans>(
      () => RemoteVehicleLoansImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<LocalMainVehicleLoans>(
      () => LocalMainVehicleLoansImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<RemoteAddVehicleLoansDataSource>(
      () => RemoteAddVehicleLoansDataSourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<LocalMainMortage>(
      () => LocalMainMortageImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<RemoteMortage>(
      () => RemoteMortageImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<AddUpdateMortgagesDataSource>(
      () => AddUpdateMortgagesDataSourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<LocalOtherLiabilitiesDatasource>(
      () => LocalOtherLiabilitiesDatasourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<RemoteOtherLiabilitiesDatasource>(
      () => RemoteOtherLiabilitiesDatasourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<RemoteAddUpdateOtherLiabilitiesDataSource>(
        () => RemoteAddUpdateOtherLiabilitiesDataSourceImp(
            sharedPreferences: locator()));
    locator.registerLazySingleton<MainAssetsLiabilitiesdataSource>(
      () => MainAssetsLiabilitiesdataSourceImpl(),
    );

    locator.registerLazySingleton<MainLocalAssetsLiabilitiesDataSource>(
      () =>
          MainLocalAssetsLiabilitiesDataSourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<LocalHomeBankAccountsDataSource>(
      () => LocalHomeBankAccountsDataSourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<RemoteHomeBankAccountDataSource>(
      () => RemoteHomeBankAccountDataSourceImpl(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<MainPensionInvestmentDataSource>(
      () => MainPensionInvestmentDataSourceImpl(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<RemoteSupportAccountDataSource>(
      () => RemoteSupportAccountDataSourceImp(),
    );
    locator.registerLazySingleton<RemoteUserAccountData>(
      () => RemoteUserAccountDataImp(),
    );
    locator.registerLazySingleton<RemotePensionNotesDataSource>(
      () => RemotePensionNotesImp(),
    );
    locator.registerLazySingleton<RemoteInvestmentNotesDataSource>(
      () => RemoteInvestmentNotesImp(),
    );
    locator.registerLazySingleton<RemoteCustomAssetsDropDown>(
      () => RemoteCustomAssetsDropDownImp(),
    );
    locator.registerLazySingleton<RemoteSearchCrypto>(
      () => RemoteSearchCryptoImp(),
    );
    locator.registerLazySingleton<RemoteSearchStocks>(
      () => RemoteSearchStocksImp(),
    );
    locator.registerLazySingleton<GetProviderRecordsdataSource>(
      () => GetProviderRecordsdataSourceImpl(),
    );
    locator.registerLazySingleton<GetYodleeTokenDataSource>(
      () => GetYodleeTokenDataSourceImpl(),
    );
    locator.registerLazySingleton<RemoteYourInvestment>(
      () => RemoteYourInvestmentImp(),
    );
    locator.registerLazySingleton<CreatePasswordDataSource>(
      () => CreatePasswordDataSourceImp(),
    );
    locator.registerLazySingleton<CalculatorInsightsDataSource>(
      () => CalculatorInsightsDataSourceImpl(),
    );
    locator.registerLazySingleton<DashboardDataSource>(
      () => DashboardDataSourceImp(),
    );
    locator.registerLazySingleton<RemoteGetBeneficiaryDataSource>(
      () => RemoteGetBeneficiaryDataSourceImp(),
    );
    locator.registerLazySingleton<RemoteAddEditTrustedDataSource>(
      () => RemoteAddEditTrustedDataSourceImp(),
    );
    locator.registerLazySingleton<RemoteAddEditBeneficairyDataSource>(
      () => RemoteAddEditBeneficairyDataSourceImp(),
    );
    locator.registerLazySingleton<DocumentDataSource>(
      () => DocumentDataSourceImpl(),
    );

    locator.registerLazySingleton<GenericServicesDataSource>(
      () => GenericServicesDataSourceImp(),
    );
    locator.registerLazySingleton<RemoteYourPension>(
      () => RemoteYourPensionImp(),
    );
    locator.registerLazySingleton<LocalAggregationResults>(
      () => LocalAggregationResultsImp(),
    );
    locator.registerLazySingleton<RemoteAggregationResults>(
      () => RemoteAggregationResultsImp(),
    );
    locator.registerLazySingleton<CommonDataSource>(
      () => CommonDataSourceImp(sharedPreferences: locator()),
    );
    locator.registerLazySingleton<RemoteTermConditionDataSource>(
      () => RemoteTermConditionDataSourceImp(),
    );
    locator.registerLazySingleton<RemoteCreatePasscodeDatasource>(
      () => RemoteCreatePasscodeDatasourceImp(),
    );
    locator.registerLazySingleton<ChangePasswordDatasource>(
      () => ChangePasswordDatasourceImp(),
    );
    locator.registerLazySingleton<ChangePasscodeDatasource>(
      () => ChangePasscodeDatasourceImp(),
    );
    locator.registerLazySingleton<RemoteThirdPartyAccessData>(
      () => RemoteThirdPartyAccessDataImp(),
    );
    locator.registerLazySingleton<RemoteViewUploadedDocumentsDatasource>(
      () => RemoteViewUploadedDocumentsIpl(),
    );
    locator.registerLazySingleton<RemoteUploadDocumentMainDataSource>(
      () => RemoteUploadDocumentMainDataSourceImpl(),
    );
    locator.registerLazySingleton<GetAccountDataSource>(
      () => GetAccountDataSourceImpl(),
    );
    locator.registerLazySingleton<InviteFriendsDataSource>(
      () => InviterFriendsDataSourceImp(),
    );
  }
}
