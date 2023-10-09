import 'package:wedge/core/common/data/repository/common_repo_imp.dart';
import 'package:wedge/core/common/domain/repository/common_repository.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/account/third_party_access/data/repository/third_party_access_repo_imp.dart';
import 'package:wedge/features/account/third_party_access/domain/repository/third_party_access_repo.dart';
import 'package:wedge/features/aggregation_results/data/repository/aggregation_repo_imp.dart';
import 'package:wedge/features/aggregation_results/domain/repository/aggregation_repo.dart';
import 'package:wedge/features/all_accounts_types/data/repositories/get_assets_liabs_repo_impl.dart';
import 'package:wedge/features/all_accounts_types/domain/repositories/main_assets_liab_repo.dart';
import 'package:wedge/features/app_passcode/create_passcode/data/repository_imp/create_passcode_repo_imp.dart';
import 'package:wedge/features/app_passcode/create_passcode/domain/repository/create_passcode_repository.dart';
import 'package:wedge/features/assets/all_assets/data/repositories/get_all_assets_repo_impl.dart';
import 'package:wedge/features/assets/all_assets/domain/repositories/get_all_assets_repository.dart';
import 'package:wedge/features/assets/assets_liablities_main/data/repositories/get_all_assets_repo_impl.dart';
import 'package:wedge/features/assets/assets_liablities_main/domain/repositories/get_all_assets_repository.dart';
import 'package:wedge/features/assets/bank_account/add_bank_account/data/repositories/get_providers_repo_impl.dart';
import 'package:wedge/features/assets/bank_account/add_bank_account/domain/repositories/get_providers_repository.dart';
import 'package:wedge/features/assets/bank_account/add_bank_manual/data/repositories/add_manual_bank_repo_impl.dart';
import 'package:wedge/features/assets/bank_account/add_bank_manual/domain/repositories/add_manualbank_repository.dart';
import 'package:wedge/features/assets/bank_account/bank_accounts/data/repositories/get_home_bankaccounts_repo_impl.dart';
import 'package:wedge/features/assets/bank_account/bank_accounts/domain/repositories/get_home_bank_accounts_repository.dart';
import 'package:wedge/features/assets/bank_account/bank_success_screen/data/repository/get_account_data_repo_impl.dart';
import 'package:wedge/features/assets/bank_account/bank_success_screen/domain/repository/get_account_data_repository.dart';
import 'package:wedge/features/assets/bank_account/main_bank_account/data/repositories/get_all_assets_repo_impl.dart';
import 'package:wedge/features/assets/bank_account/main_bank_account/domain/repositories/get_bank_accounts_repository.dart';
import 'package:wedge/features/assets/bank_account/userdata_summery/data/repositories/hoxton_data_summery_repo_imp.dart';
import 'package:wedge/features/assets/bank_account/userdata_summery/domain/repositories/hoxton_data_summery_repository.dart';
import 'package:wedge/features/assets/bank_account/yodlee_frame/data/repositories/get_yodlee_token_repo_impl.dart';
import 'package:wedge/features/assets/bank_account/yodlee_frame/domain/repositories/get_yodlee_token_repo.dart';
import 'package:wedge/features/assets/crypto/add_crypto_manual/data/repository/add_cryto_repo_imp.dart';
import 'package:wedge/features/assets/crypto/add_crypto_manual/domain/repository/add_cryto_repository.dart';
import 'package:wedge/features/assets/crypto/crypto_main/data/repository/crypto_repo_impl.dart';
import 'package:wedge/features/assets/crypto/crypto_main/domain/repository/crypto_repository.dart';
import 'package:wedge/features/assets/crypto/crypto_search/data/repository/search_crypto_repo_imp.dart';
import 'package:wedge/features/assets/crypto/crypto_search/domain/repository/search_crypto_repo.dart';
import 'package:wedge/features/assets/custom_assets/add_custom_assets/data/repositories/add_custom_asset_repo_impl.dart';
import 'package:wedge/features/assets/custom_assets/add_custom_assets/domain/repositories/add_custom_assets_repository.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_drop_down/data/repository/custom_assets_repository_imp.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_drop_down/domain/repository/custom_assets_repository.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_main/data/repositories/custom_assets_repository.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_main/domain/repositories/custom_assets_repository.dart';
import 'package:wedge/features/assets/invesntment/add_investment_manual/data/repositories/add_investment_repo_impl.dart';
import 'package:wedge/features/assets/invesntment/add_investment_manual/domain/repositories/add_investment_repository.dart';
import 'package:wedge/features/assets/invesntment/investment_main/data/repositories/investments_repository_impl.dart';
import 'package:wedge/features/assets/invesntment/investment_main/domain/repositories/investments_repository.dart';
import 'package:wedge/features/assets/pension/add_pension_manual/data/repository/add_manual_pension_data_repo.dart';
import 'package:wedge/features/assets/pension/add_pension_manual/domain/repository/add_manual_pension_repo.dart';
import 'package:wedge/features/assets/pension/pension_main/data/repository/main_pensions_repo_impl.dart';
import 'package:wedge/features/assets/pension/pension_main/domain/repository/main_pensions_repository.dart';
import 'package:wedge/features/assets/pension_investment/pension_investments_main/data/repositories/hoxton_data_summery_repo_imp.dart';
import 'package:wedge/features/assets/pension_investment/pension_investments_main/domain/repositories/main_pension_investment_repository.dart';
import 'package:wedge/features/assets/properties/add_properties/data/repositories/add_property_repo_impl.dart';
import 'package:wedge/features/assets/properties/add_properties/domain/repositories/add_properties_repository.dart';
import 'package:wedge/features/assets/properties/properties_main/data/repositories/properties_repository_impl.dart';
import 'package:wedge/features/assets/properties/properties_main/domain/repositories/properties_repository.dart';
import 'package:wedge/features/assets/stocks/add_stcoks/data/repositories/add_stocks_repo_impl.dart';
import 'package:wedge/features/assets/stocks/add_stcoks/domain/repositories/add_stocks_repository.dart';
import 'package:wedge/features/assets/stocks/search_stocks/data/repository/search_stocks_repo_imp.dart';
import 'package:wedge/features/assets/stocks/search_stocks/domain/repository/search_stocks_repo.dart';
import 'package:wedge/features/assets/stocks/stocks_main/data/repositories/stocks_repository_impl.dart';
import 'package:wedge/features/assets/stocks/stocks_main/domain/repositories/stocks_repository.dart';
import 'package:wedge/features/assets/vehicle/add_vehicle/data/repositories/add_vehicle_repo_impl.dart';
import 'package:wedge/features/assets/vehicle/add_vehicle/domain/repositories/add_vehicle_repository.dart';
import 'package:wedge/features/assets/vehicle/vehicle_main/data/repositories/investments_repository_impl.dart';
import 'package:wedge/features/assets/vehicle/vehicle_main/domain/repositories/vehicles_repository.dart';
import 'package:wedge/features/auth/create_password/data/repository/create_password_repo_imp.dart';
import 'package:wedge/features/auth/create_password/domain/repository/create_password_repo.dart';
import 'package:wedge/features/auth/hoxton_login/data/repositories/login_repository_imp.dart';
import 'package:wedge/features/auth/hoxton_login/domain/repositories/login_repository.dart';
import 'package:wedge/features/auth/terms_and_condition/data/repository/term_condition_repo_imp.dart';
import 'package:wedge/features/auth/terms_and_condition/domain/repository/term_condition_repository.dart';
import 'package:wedge/features/beneficiary/beneficiary_add/data/repository/add_edit_beneficiary_repo_imp.dart';
import 'package:wedge/features/beneficiary/beneficiary_add/domain/respository/add_edit_beneficiary_repo.dart';
import 'package:wedge/features/beneficiary/beneficiary_trusted_main/data/repository/get_beneficiary_repo_imp.dart';
import 'package:wedge/features/beneficiary/beneficiary_trusted_main/domain/repository/get_beneficiary_repo.dart';
import 'package:wedge/features/beneficiary/trusted_add/data/repository/add_edit_trusted_member_repo_imp.dart';
import 'package:wedge/features/beneficiary/trusted_add/domain/repository/add_edit_trusted_member_repo.dart';
import 'package:wedge/features/calculators/retirement_calculator/data/repositories/calc_insights_repo_impl.dart';
import 'package:wedge/features/calculators/retirement_calculator/domain/repositories/calculator_insight_repository.dart';
import 'package:wedge/features/change_passcode/data/repository/change_passcode_repository_imp.dart';
import 'package:wedge/features/change_passcode/domain/repository/change_passcode_repository.dart';
import 'package:wedge/features/change_password/data/repository/change_password_repository_imp.dart';
import 'package:wedge/features/change_password/domain/repository/change_password_repository.dart';
import 'package:wedge/features/home/data/repository/dashboard_repo_imp.dart';
import 'package:wedge/features/home/data/repository/disconnected_accounts_repo_Imp.dart';
import 'package:wedge/features/home/domain/repository/dashboard_repo.dart';
import 'package:wedge/features/liabilities/add_liabilities_page/data/repository/add_liabilities_repo_imp.dart';
import 'package:wedge/features/liabilities/add_liabilities_page/domain/repository/add_liabilities_repository.dart';
import 'package:wedge/features/liabilities/credit_card/add_credit_card_debt/data/repository/add_update_credit_card_repo_imp.dart';
import 'package:wedge/features/liabilities/credit_card/add_credit_card_debt/domain/repository/add_update_credit_cards_repo.dart';
import 'package:wedge/features/liabilities/credit_card/credit_card_debt_main/data/repository/main_credit_card_repository_imp.dart';
import 'package:wedge/features/liabilities/credit_card/credit_card_debt_main/domain/repository/credit_card_repository.dart';
import 'package:wedge/features/liabilities/mortgages/add_mortgages/data/repository/add_update_mortgages_repo_imp.dart';
import 'package:wedge/features/liabilities/mortgages/add_mortgages/domain/repository/add_update_mortgages_repo.dart';
import 'package:wedge/features/liabilities/mortgages/mortgages_main/data/repository/main_mortgages_repo_imp.dart';
import 'package:wedge/features/liabilities/mortgages/mortgages_main/domain/repository/main_mortage_repo.dart';
import 'package:wedge/features/liabilities/other_liabilities/add_other_liabilities/data/repository/add_udpate_other_liabilities_repo_Imp.dart';
import 'package:wedge/features/liabilities/other_liabilities/add_other_liabilities/domain/repository/add_update_other_liabilities_repo.dart';
import 'package:wedge/features/liabilities/other_liabilities/other_liabilities_main/data/repository/main_other_liabilities_repo_imp.dart';
import 'package:wedge/features/liabilities/other_liabilities/other_liabilities_main/domain/repository/main_other_liabilities_repo.dart';
import 'package:wedge/features/liabilities/personal_loan/add_personal_loan/data/repositories/add_personal_loan_repo_impl.dart';
import 'package:wedge/features/liabilities/personal_loan/add_personal_loan/domain/repositories/add_personal_loan_repository.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/data/repository/add_vehicle_loans_repo_imp.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/domain/repository/add_vehicle_loans_repo.dart';
import 'package:wedge/features/liabilities/vehicle_loan/vehicle_loan_main/data/repository/main_vehicle_loans_repo_imp.dart';
import 'package:wedge/features/liabilities/vehicle_loan/vehicle_loan_main/domain/repository/main_vehicle_loans.dart';
import 'package:wedge/features/support/data/repository/support_account_repo_imp.dart';
import 'package:wedge/features/support/domain/repository/support_account.dart';
import 'package:wedge/features/user_services/generic_data/generic_repository_imp.dart';
import 'package:wedge/features/user_services/generic_domain/generic_repository/user_services_repository.dart';
import 'package:wedge/features/user_services/uplead_documents/data/repository/upload_document_main_repo_impl.dart';
import 'package:wedge/features/wealth_vault/documents/data/repositories/documents_repository.dart';
import 'package:wedge/features/wealth_vault/documents/domain/repositories/document_repository.dart';
import 'package:wedge/features/your_investments/data/repository/your_investment_repo_imp.dart';
import 'package:wedge/features/your_investments/domain/repository/your_investment_repo.dart';
import 'package:wedge/features/your_pensions/data/repository/pension_notes_repo_imp.dart';
import 'package:wedge/features/your_pensions/data/repository/your_pension_repo_imp.dart';
import 'package:wedge/features/your_pensions/domain/repository/your_pension_repo.dart';

import '../core/common/line_performance_graph/data/repository/line_performance_graph_imp.dart';
import '../core/common/line_performance_graph/domain/repository/line_Performance_graph_repository.dart';
import '../features/account/my_account/data/repository/user_account_repo_imp.dart';
import '../features/account/my_account/domain/repository/user_account_repo.dart';
import '../features/auth/personal_details/data/repository/personal_details_repo_imp.dart';
import '../features/auth/personal_details/domain/repository/personal_details_repository.dart';
import '../features/auth/signup/data/repository/signup_repo_imp.dart';
import '../features/auth/signup/domain/repository/signup_details_repo.dart';
import '../features/home/domain/repository/dissconnect_accounts_repo.dart';
import '../features/invite_friends/data/repository/invite_friends_repo_imp.dart';
import '../features/invite_friends/domain/repository/invite_friends_repo.dart';
import '../features/liabilities/personal_loan/personal_loan_main/data/repository/main_personal_load_repo_imp.dart';
import '../features/liabilities/personal_loan/personal_loan_main/domain/repository/main_personal_loan_repo.dart';
import '../features/user_services/uplead_documents/data/repository/upload_document_repo_imp.dart';
import '../features/user_services/uplead_documents/data/repository/view_document_repository_impl.dart';
import '../features/user_services/uplead_documents/domain/repository/upload_document_main_repo.dart';
import '../features/user_services/uplead_documents/domain/repository/upload_document_repo.dart';
import '../features/user_services/uplead_documents/domain/repository/view_document_repository.dart';
import '../features/your_investments/data/repository/investmant_notes_repo_imp.dart';
import '../features/your_investments/domain/repository/investment_notes_repo.dart';
import '../features/your_pensions/domain/repository/pension_notes_repo.dart';

class RegisterRepository {
  RegisterRepository() {
    locator.registerLazySingleton<LoginRepository>(
      () => LoginRepositoryImpl(
          loginDataSource: locator(), localLoginDataSource: locator()),
    );

    locator.registerLazySingleton<HoxtonDataSummeryRepository>(
      () => HoxtonDataSummeryRepositoryImpl(hoxtonUserDataSource: locator()),
    );
    locator.registerLazySingleton<AssetsLiabilitiesMainRepository>(
      () => GetAssetsLiabilitiesMainRepositoryImpl(
          assetsDatasorce: locator(),
          localassetsLiabilitiesDataSource: locator()),
    );
    locator.registerLazySingleton<GetAllAssetsRepository>(
      () => GetAllAssetsRepositoryImpl(localDataSource: locator()),
    );
    locator.registerLazySingleton<AddManualBankRepository>(
      () => AddManualBankRepositoryImpl(addManualBankDataSource: locator()),
    );
    locator.registerLazySingleton<MainBankAccountsRepository>(
      () => GetBankAccountsRepositoryImpl(
          localDataSource: locator(), remoteBankAccountDataSource: locator()),
    );
    locator.registerLazySingleton<CustomAssetsRepository>(
      () => CustomAssetsRepositoryImpl(
          localDataSource: locator(), remoteCustomAssetsDataSource: locator()),
    );

    locator.registerLazySingleton<AddCustomAssetsRepository>(
      () => AddCustomAssetsRepositoryImpl(
        addCustomAssetsDataSource: locator(),
      ),
    );

    locator.registerLazySingleton<PropertiesRepository>(
      () => PropertiesRepositoryImpl(
          assetsLiabilitiesdataSource: locator(),
          localAssetsLiabilitiesDataSource: locator(),
          localDataSource: locator(),
          remotePropertiesDataSource: locator()),
    );
    locator.registerLazySingleton<AddPropertiesRepository>(
      () => AddPropertyRepositoryImpl(
          dataSource: locator(),
          assetsLiabilitiesDataSource: locator(),
          localAssetsLiabilitiesDataSource: locator()),
    );
    locator.registerLazySingleton<AddStocksRepository>(
      () => AddStocksBondsRepositoryImpl(addStocksBondsDataSource: locator()),
    );
    locator.registerLazySingleton<StocksRepository>(
      () => StocksRepositoryImpl(
          remoteStocksDataSource: locator(), localDataSource: locator()),
    );
    locator.registerLazySingleton<AddInvestmentRepository>(
      () => AddInvestmentRepositoryImpl(
        addInvestmentDataSource: locator(),
      ),
    );
    locator.registerLazySingleton<InvestmentRepository>(
      () => InvestmentsRepositoryImpl(
          remoteStocksDataSource: locator(), localDataSource: locator()),
    );
    locator.registerLazySingleton<VehicleRepository>(
      () => VehiclesRepositoryImpl(
          assetsLiabilitiesdataSource: locator(),
          localAssetsLiabilitiesDataSource: locator(),
          remoteDataSource: locator(),
          localDataSource: locator()),
    );
    locator.registerLazySingleton<AddVehicleRepository>(
      () => AddVehicleRepositoryImpl(
        assetsLiabilitiesdataSource: locator(),
        localAssetsLiabilitiesDataSource: locator(),
        addVehicleDataSource: locator(),
      ),
    );
    locator.registerLazySingleton<AddPersonalLoanRepository>(
      () => AddPersonalLoanRepositoryImpl(
        addPersonalLoanDataSource: locator(),
      ),
    );
    locator.registerLazySingleton<AddManualPensionRepo>(
      () => AddManualPensionRepoImp(
        addManualPensionDataPension: locator(),
      ),
    );
    locator.registerLazySingleton<MainPensionsRepository>(
      () => MainPensionsRepositoryImp(
        localPensionsDataSource: locator(),
        remotePensionsDataSource: locator(),
      ),
    );
    locator.registerLazySingleton<InviteFriendsDataRepo>(
      () => InviteFriendsDataRepoImp(
        inviteFriendsDataSource: locator(),
      ),
    );
    locator.registerLazySingleton<AddLiabilitiesRepo>(
      () => AddLiabilitiesRepoImp(localGetLiabilities: locator()),
    );
    locator.registerLazySingleton<CryptoRepo>(
      () => CryptoCurrenciesRepoImp(
          localCryptoCurrenciesDataSource: locator(),
          remoteCryptoDataSrouce: locator()),
    );
    locator.registerLazySingleton<AddUpdateCryptoRepo>(
      () => AddUpdateCryptoRepoImp(remoteAddUpdateCryptoDataSource: locator()),
    );
    locator.registerLazySingleton<MainCreditCardRepo>(
      () => MainCreditCardRepoImp(
          localCreditCardDatasource: locator(),
          remoteCreditCardDatasource: locator()),
    );
    locator.registerLazySingleton<LinePerformanceGraphRepo>(
      () => LinePerformanceGraphRepoImp(
        remoteLinePerformanceGraphDatasource: locator(),
      ),
    );
    locator.registerLazySingleton<PersonalDetailsRepository>(
      () => PersonalDetailsRepositoryImp(
        personalDetailsSource: locator(),
      ),
    );
    locator.registerLazySingleton<SignUpRepository>(
      () => SignUpRepositoryImp(
        signUpSource: locator(),
      ),
    );
    locator.registerLazySingleton<UploadDocumentRepository>(
      () => UploadDocumentRepositoryImp(
        uploadDocumentSource: locator(),
      ),
    );
    locator.registerLazySingleton<AddUpdateCreditCardsRepo>(
      () => AddUpdateCreditCardsRepoImp(remoteAddUpadteCreditCards: locator()),
    );
    locator.registerLazySingleton<MainVehicleLoansRepo>(
      () => MainVehicleLoansRepoImp(
          localMainVehicleLoans: locator(),
          remoteVehicleLoans: locator(),
          assetsLiabilitiesdataSource: locator(),
          localAssetsLiabilitiesDataSource: locator()),
    );
    locator.registerLazySingleton<AddVehicleLoansRepo>(
      () => AddVehicleLoansRepoImp(remoteAddVehicleLoansDataSource: locator()),
    );
    locator.registerLazySingleton<MainMortageRepo>(
      () => MainMortageRepoImp(
          assetsLiabilitiesdataSource: locator(),
          localAssetsLiabilitiesDataSource: locator(),
          localMainMortage: locator(),
          remoteMortage: locator()),
    );
    locator.registerLazySingleton<AddUpdateMortgagesRepo>(
      () => AddUpdateMortgagesRepoImp(
          addUpdateMortgagesDataSource: locator(),
          assetsLiabilitiesdataSource: locator(),
          localAssetsLiabilitiesDataSource: locator()),
    );
    locator.registerLazySingleton<MainOtherRepositoryRepo>(
      () => MainOtherRepositoryRepoImp(
          localOtherLiabilitiesDatasource: locator(),
          remoteOtherLiabilitiesDatasource: locator()),
    );
    locator.registerLazySingleton<AddUpdateOtherLiabilitiesRepo>(() =>
        AddUpdateOtherLiabilitiesRepoImp(
            remoteAddUpdateOtherLiabilitiesDataSource: locator()));
    locator.registerLazySingleton<GetAllAssetsLiabilitiesRepository>(
      () => GetAllAssetsLiabilitiesRepositoryImpl(
          dataSource: locator(), localDatasource: locator()),
    );
    locator.registerLazySingleton<GetHomeBankAccountsRepository>(
      () => GetHomeBankAccountsRepositoryImpl(
          remoteBankAccountDataSource: locator(), localDataSource: locator()),
    );
    locator.registerLazySingleton<MainPensionInvestmentRepository>(
      () =>
          MainPensionInvestmentRepositoryImpl(hoxtonUserDataSource: locator()),
    );
    locator.registerLazySingleton<AddSupportAccontRepo>(
      () => AddSupportAccontRepoImp(remoteSupportAccountDataSource: locator()),
    );
    locator.registerLazySingleton<UserAccountRepo>(
      () => UserAccountRepoImp(remoteUserAccountData: locator()),
    );
    locator.registerLazySingleton<PensionNotesRepo>(
      () => PensionNotesRepoImp(remoteNotesDataSource: locator()),
    );
    locator.registerLazySingleton<InvestmentNotesRepo>(
      () => InvestmentNotesRepoImp(remoteNotesDataSource: locator()),
    );
    locator.registerLazySingleton<CustomAssetsDropDownRepo>(
        () => CustomAssetDropDownRepoImp(
              remoteCustomAssetsDropDown: locator(),
            ));
    locator.registerLazySingleton<SearchCryptoRepo>(
        () => SearchCryptoRepoImp(remoteSearchCrypto: locator()));
    locator.registerLazySingleton<SearchStocksRepo>(
        () => SearchStocksRepoImp(remoteSearchStocks: locator()));
    locator.registerLazySingleton<GetProvidersRepository>(
        () => GetProvidersRepositoryImpl(
              dataSource: locator(),
            ));
    locator.registerLazySingleton<GetYodleeTokenRepository>(
        () => GetYodleeTokenRepositoryImpl(
              dataSource: locator(),
            ));
    locator.registerLazySingleton<YourInvestmentRepo>(
        () => YourInvestmentRepoImp(remoteYourInvestment: locator()));
    locator.registerLazySingleton<CreatePasswordRepo>(
        () => CreatePasswordRepoImp(createPasswordDataSource: locator()));
    locator.registerLazySingleton<CalculatorInsightsRepository>(
        () => CalculatorInsightsRepoImpl(dataSource: locator()));
    locator.registerLazySingleton<DashboardDataRepo>(
        () => DashboardDataRepoImp(dashboardDataSource: locator()));

    locator.registerLazySingleton<DisconnectedAccountsRepo>(
        () => DisconnectedAccountsRepoImp(dashboardDataSource: locator()));
    locator.registerLazySingleton<GetBeneficiaryRepo>(
        () => GetBeneficiaryRepoImp(remoteGetBeneficiaryDataSource: locator()));
    locator.registerLazySingleton<AddEditTrustedMemberRepo>(() =>
        AddEditTrustedMemberRepoImp(remoteAddEditTrustedDataSource: locator()));
    locator.registerLazySingleton<AddEditBeneficiaryRepo>(() =>
        AddEditBeneficaryRepoImp(
            remoteAddEditBeneficairyDataSource: locator()));

    locator.registerLazySingleton<DocumentRepository>(
        () => DocumentRepositoryImpl(remoteDocumentDataSource: locator()));

    locator.registerLazySingleton<GenericUserServicesRepository>(
        () => GenericUserServicesRepositoryImp(dashboardDataSource: locator()));
    locator.registerLazySingleton<YourPensionRepo>(
        () => YourPensionRepoImp(remoteYourInvestment: locator()));
    locator.registerLazySingleton<AggregationResultRepo>(() =>
        AggregationResultRepoImp(
            localAggregationResults: locator(),
            remoteAggregationResults: locator()));
    locator.registerLazySingleton<CommonRepository>(
        () => CommonRepositoryImp(commonDataSource: locator()));
    locator.registerLazySingleton<TermConditionRepository>(
        () => TermConditionRepoImp(locator()));
    locator.registerLazySingleton<CreatePasscodeRepository>(
        () => CreatePasscodeRepositoryImp(locator()));
    locator.registerLazySingleton<ChangePasswordRepository>(
        () => ChangePasswordRepositoryImp(locator()));
    locator.registerLazySingleton<ChangePasscodeRepository>(
        () => ChangePasscodeRepositoryImp(locator()));
    locator.registerLazySingleton<ThirdPartyAccessRepo>(
        () => UserThirdPartyRepoImp(remoteThirdPartyAccessData: locator()));
    locator.registerLazySingleton<ViewDocumentRepository>(() =>
        ViewDocumentRepositoryImpl(
            remoteViewUploadedDocumentsDatasource: locator()));
    locator.registerLazySingleton<UploadDocumentMainRepository>(() =>
        UploadDocumentMainRepositoryImpl(
            remoteUploadDocumentMainDataSource: locator()));
    locator.registerLazySingleton<GetAccountDataRepository>(
        () => GetAccountDataRepositoryImpl(dataSource: locator()));
    locator.registerLazySingleton<MainPersonalRepository>(
      () => MainPersonalLoanRepoImp(
        localPersonalLoanDataSource: locator(),
        remoteMainPersonalLoanDataSource: locator(),
      ),
    );
  }
}
