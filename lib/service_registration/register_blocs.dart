import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/account/my_account/presentation/cubit/enable_biometric_switch_cubit.dart';
import 'package:wedge/features/aggregation_results/presentation/cubit/aggregation_result_cubit.dart';
import 'package:wedge/features/aggregator_reconnect/presentation/cubit/aggregator_reconnect_cubit.dart';
import 'package:wedge/features/all_accounts_types/presentation/bloc/cubit/mainassetsliabilities_cubit.dart';
import 'package:wedge/features/app_passcode/ask_auth/cubit/ask_auth_cubit.dart';
import 'package:wedge/features/app_passcode/confirm_passcode/presentation/cubit/confirm_passcode_cubit.dart';
import 'package:wedge/features/app_passcode/create_passcode/presentation/cubit/create_passcode_cubit.dart';
import 'package:wedge/features/assets/all_assets/presentation/bloc/cubit/allassets_cubit.dart';
import 'package:wedge/features/assets/assets_liablities_main/presentation/bloc/cubit/assets_liabilities_main_cubit.dart';
import 'package:wedge/features/assets/bank_account/add_bank_account/presentation/bloc/cubit/get_providers_cubit.dart';
import 'package:wedge/features/assets/bank_account/add_bank_manual/presentation/bloc/cubit/add_manual_bank_cubit.dart';
import 'package:wedge/features/assets/bank_account/bank_accounts/presentation/bloc/cubit/bank_transaction_cubit.dart';
import 'package:wedge/features/assets/bank_account/bank_accounts/presentation/bloc/cubit/home_bank_accounts_cubit.dart';
import 'package:wedge/features/assets/bank_account/bank_success_screen/presentation/cubit/get_account_data_cubit.dart';
import 'package:wedge/features/assets/bank_account/main_bank_account/presentation/bloc/cubit/bank_accounts_cubit.dart';
import 'package:wedge/features/assets/bank_account/main_bank_account/presentation/bloc/cubit/cash_account_download_cubit.dart';
import 'package:wedge/features/assets/bank_account/userdata_summery/presentation/bloc/cubit/userdatasummery_cubit.dart';
import 'package:wedge/features/assets/bank_account/yodlee_frame/presentation/bloc/cubit/yodlee_intergration_cubit.dart';
import 'package:wedge/features/assets/crypto/add_crypto_manual/presentation/bloc/add_crypto_bloc_cubit.dart';
import 'package:wedge/features/assets/crypto/crypto_main/presentation/bloc/main_crypto_bloc_cubit.dart';
import 'package:wedge/features/assets/crypto/crypto_search/presentation/cubit/search_crypto_cubit.dart';
import 'package:wedge/features/assets/custom_assets/add_custom_assets/presentation/bloc/cubit/add_manual_bank_cubit.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_drop_down/presentation/cubit/custom_asset_drop_down_cubit.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_main/presentation/bloc/cubit/custom_assets_cubit.dart';
import 'package:wedge/features/assets/invesntment/add_investment_manual/presentation/bloc/cubit/add_investment_cubit.dart';
import 'package:wedge/features/assets/invesntment/investment_main/presentation/bloc/cubit/investments_cubit.dart';
import 'package:wedge/features/assets/pension/add_pension_manual/presentation/cubit/add_manual_pension_cubit.dart';
import 'package:wedge/features/assets/pension/pension_main/domain/usecases/delete_pension_usecase.dart';
import 'package:wedge/features/assets/pension/pension_main/presentation/bloc/pensionmaincubit_cubit.dart';
import 'package:wedge/features/assets/pension_investment/pension_investments_main/presentation/bloc/cubit/pension_investment_main_cubit.dart';
import 'package:wedge/features/assets/properties/add_properties/presentation/bloc/cubit/add_property_cubit.dart';
import 'package:wedge/features/assets/properties/properties_main/presentation/bloc/cubit/properties_cubit.dart';
import 'package:wedge/features/assets/stocks/add_stcoks/presentation/bloc/cubit/add_stocks_cubit.dart';
import 'package:wedge/features/assets/stocks/search_stocks/presentation/cubit/search_stocks_cubit.dart';
import 'package:wedge/features/assets/stocks/stocks_main/presentation/bloc/cubit/stocks_cubit.dart';
import 'package:wedge/features/assets/vehicle/add_vehicle/presentation/bloc/cubit/add_vehicle_cubit.dart';
import 'package:wedge/features/assets/vehicle/vehicle_main/presentation/bloc/cubit/vehicles_cubit.dart';
import 'package:wedge/features/auth/create_password/presentation/cubit/create_password_cubit.dart';
import 'package:wedge/features/auth/hoxton_login/presentation/bloc/cubit/forgotpassword_cubit.dart';
import 'package:wedge/features/auth/hoxton_login/presentation/bloc/cubit/login_cubit.dart';
import 'package:wedge/features/auth/hoxton_login/presentation/bloc/cubit/otp_cubit.dart';
import 'package:wedge/features/auth/terms_and_condition/presentation/cubit/terms_and_conditions_cubit.dart';
import 'package:wedge/features/beneficiary/beneficiary_add/presentation/cubit/beneficiary_add_cubit.dart';
import 'package:wedge/features/beneficiary/beneficiary_trusted_main/presentation/cubit/beneficiary_main_cubit.dart';
import 'package:wedge/features/beneficiary/beneficiary_trusted_main/presentation/cubit/trusted_main_cubit.dart';
import 'package:wedge/features/beneficiary/trusted_add/presentation/cubit/trusted_add_cubit.dart';
import 'package:wedge/features/calculators/retirement_calculator/cubit/chart_tool_tip_cubit.dart';
import 'package:wedge/features/calculators/retirement_calculator/presentation/bloc/cubit/calculator_insights_cubit.dart';
import 'package:wedge/features/change_passcode/presentation/cubit/change_passcode_cubit.dart';
import 'package:wedge/features/change_password/presentation/cubit/change_password_cubit.dart';
import 'package:wedge/features/home/presentation/cubit/dashboard_cubit.dart';
import 'package:wedge/features/liabilities/add_liabilities_page/presentation/bloc/add_liabilities_page_cubit.dart';
import 'package:wedge/features/liabilities/credit_card/add_credit_card_debt/presentation/cubit/add_credit_card_cubit.dart';
import 'package:wedge/features/liabilities/credit_card/credit_card_debt_main/presentation/cubit/creditcardexceldownload_cubit.dart';
import 'package:wedge/features/liabilities/credit_card/credit_card_debt_main/presentation/cubit/main_credit_card_cubit.dart';
import 'package:wedge/features/liabilities/mortgages/add_mortgages/presentation/cubit/add_mortgages_cubit.dart';
import 'package:wedge/features/liabilities/mortgages/mortgages_main/presentation/cubit/mortage_main_cubit.dart';
import 'package:wedge/features/liabilities/other_liabilities/add_other_liabilities/presentation/cubit/add_other_liabilities_cubit.dart';
import 'package:wedge/features/liabilities/other_liabilities/other_liabilities_main/presentation/cubit/main_other_liabilities_cubit.dart';
import 'package:wedge/features/liabilities/personal_loan/add_personal_loan/presentation/bloc/add_personal_loan_cubit.dart';
import 'package:wedge/features/liabilities/personal_loan/personal_loan_main/presentation/bloc/mainpersonalloan_cubit.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/presentation/pages/cubit/add_vehicle_loans_cubit.dart';
import 'package:wedge/features/liabilities/vehicle_loan/vehicle_loan_main/presentation/cubit/main_vehicle_loans_cubit.dart';
import 'package:wedge/features/support/presentation/cubit/support_account_cubit.dart';
import 'package:wedge/features/user_services/document_service/presentation/cubit/servicedocuments_cubit.dart';
import 'package:wedge/features/user_services/pension_report_service/presentation/cubit/pension_report_cubit.dart';
import 'package:wedge/features/user_services/user_services_advisor/presentation/cubit/useradvisor_cubit.dart';
import 'package:wedge/features/user_services/user_services_main/presentation/cubit/getservices_cubit.dart';
import 'package:wedge/features/wealth_vault/documents/presentation/bloc/cubit/document_cubit.dart';
import 'package:wedge/features/your_investments/presentation/cubit/your_investments_cubit.dart';
import 'package:wedge/features/your_pensions/presentation/cubit/your_pensions_cubit.dart';

import '../core/common/cubit/banner_notification_cubit.dart';
import '../core/common/line_performance_graph/presentation/cubit/line_peformance_cubit.dart';
import '../features/account/my_account/presentation/cubit/get_tenant_cubit.dart';
import '../features/account/my_account/presentation/cubit/push_notification_state_cubit.dart';
import '../features/account/my_account/presentation/cubit/user_account_cubit.dart';
import '../features/account/my_account/presentation/cubit/user_preferences_cubit.dart';
import '../features/account/third_party_access/presentation/cubit/third_party_cubit.dart';
import '../features/assets/assets_liablities_main/presentation/bloc/cubit/assets_and_liablities_cubit.dart';
import '../features/assets/bank_account/main_bank_account/presentation/bloc/cubit/cash_account_bar_performance_cubit.dart';
import '../features/assets/bank_account/main_bank_account/presentation/bloc/cubit/cash_account_pie_performance_cubit.dart';
import '../features/assets/bank_account/main_bank_account/presentation/bloc/cubit/credit_card_transaction_cubit.dart';
import '../features/assets/crypto/crypto_main/presentation/bloc/crypto_peformance_cubit.dart';
import '../features/assets/stocks/stocks_main/presentation/bloc/cubit/stocks_peformance_cubit.dart';
import '../features/auth/personal_details/presentation/cubit/personal_details_cubit.dart';
import '../features/auth/signup/presentaion/cubit/signup_cubit.dart';
import '../features/auth/signup/presentaion/cubit/validate_user_details_cubit.dart';
import '../features/home/presentation/cubit/disconnected_accounts_cubit.dart';
import '../features/invite_friends/presentation/cubit/invite_friends_cubit.dart';
import '../features/liabilities/credit_card/credit_card_debt_main/presentation/cubit/credit_card_pie_performance_cubit.dart';
import '../features/liabilities/credit_card/credit_card_debt_main/presentation/cubit/credit_card_transaction_cubit.dart';
import '../features/user_services/uplead_documents/presentation/cubit/document_screen_cubit.dart';
import '../features/user_services/uplead_documents/presentation/cubit/upload_document_cubit.dart';
import '../features/user_services/uplead_documents/presentation/cubit/upload_document_main_cubit.dart';
import '../features/your_investments/presentation/cubit/investment_notes_cubit.dart';
import '../features/your_investments/presentation/cubit/your_investment_peformance_cubit.dart';
import '../features/your_pensions/presentation/cubit/pension_notes_cubit.dart';
import '../features/your_pensions/presentation/cubit/your_pension_peformance_cubit.dart';

class RegisterBlocs {
  RegisterBlocs() {
    locator.registerFactory(
      () => LoginCubit(
          validateOTPUsecase: locator(),
          loginWithOTP: locator(),
          verifyEmail: locator(),
          userLogin: locator(),
          resetPassword: locator()),
    );

    locator.registerFactory(
      () => UserDataSummeryCubit(
          getHoxtonUserDataSummery: locator(), getUserDetails: locator()),
    );

    locator.registerFactory(
      () => MainAssetsLiabilitiesCubit(getAssetsLiabilities: locator()),
    );
    locator.registerFactory(
      () => AllAssetsCubit(getAllAssets: locator()),
    );

    locator.registerFactory(
      () => AddManualBankCubit(
          addManualBankAccount: locator(), updateManualBankAccount: locator()),
    );

    locator.registerFactory(() => GetAccountDataCubit(locator()));

    locator.registerFactory(
      () => AddPersonalLoanCubit(
          addPersonalLoanUseCase: locator(), updatePersonLoan: locator()),
    );

    locator.registerFactory(
      () => BankAccountsCubit(
          getBankAccounts: locator(), deleteBankAccounts: locator()),
    );

    locator.registerFactory(
      () => CashAccountPiePerformanceCubit(
          getCashAccountPiePerformance: locator()),
    );
    locator.registerFactory(
      () => CashAccountBarPerformanceCubit(
          getCashAccountBarPerformance: locator()),
    );

    locator.registerFactory(
      () => CashAccountTransactionCubit(getCashAccountTransaction: locator()),
    );

    locator.registerFactory(
      () => CustomAssetsCubit(
          getCustomAssets: locator(), deleteCustomAssets: locator()),
    );
    locator.registerFactory(
      () => AddCustomAssetsCubit(
          addCustomAssets: locator(), updateCustomAssets: locator()),
    );
    locator.registerFactory(
      () => PropertiesCubit(
          unlinkProperties: locator(),
          deleteProperties: locator(),
          getProperties: locator()),
    );
    locator.registerFactory(
      () => AddPropertyCubit(addProperty: locator(), updateProperty: locator()),
    );
    locator.registerFactory(
      () => AddStocksCubit(
          addStocksBonds: locator(), updateStocksBonds: locator()),
    );

    locator.registerFactory(
      () => StocksCubit(getStocks: locator(), deleteStocksBonds: locator()),
    );

    locator.registerFactory(
      () => InvestmentsCubit(
          getInvestments: locator(), deleteInvestments: locator()),
    );
    locator.registerFactory(
      () => AddInvestmentCubit(
          addInvestment: locator(), updateInvestment: locator()),
    );
    locator.registerFactory(
      () => VehiclesCubit(
          getVehicless: locator(),
          deleteVehicless: locator(),
          unlinkVehicleUsecase: locator()),
    );
    locator.registerFactory(
      () => AddVehicleCubit(addVehicle: locator(), updateVehicle: locator()),
    );
    locator.registerFactory(
      () => AddManualPensionCubit(
          addManualPensionUseCase: locator(),
          updateManualPensionsUseCase: locator()),
    );
    locator.registerFactory(() => PensionMaincubitCubit(
        deletePensionUsecase: locator(), getPensionsUseCase: locator()));
    locator.registerFactory(
      () => MainPersonalLoanCubit(
        commonRefreshAgreegatorAccountUsecase: locator(),
        deleteMainPersonalLoanUsecase: locator(),
        getMainPersonalLoanUsecase: locator(),
      ),
    );
    locator.registerFactory(
        () => AddLiabilitiesPageCubit(getLiabilities: locator()));
    locator.registerFactory(() => MainCryptoBlocCubit(
        deleteCryptoUsecase: locator(), getCryptoData: locator()));
    locator.registerFactory(() => AddCryptoBlocCubit(
        addCryptoUsecase: locator(), updateCryptoUsecase: locator()));
    locator.registerFactory(() => MainCreditCardCubit(
        commonRefreshAgreegatorAccountUsecase: locator(),
        mainCreditCardRepo: locator()));
    locator.registerFactory(() => AddCreditCardCubit(
        addCreditCardsUsecase: locator(), updateCreditCardsUsecase: locator()));
    locator.registerFactory(() => MainVehicleLoansCubit(
        unlinkVehicleLoans: locator(),
        deleteVehicleLoansUsecase: locator(),
        getVehicleLoansUsecase: locator()));
    locator.registerFactory(() => AddVehicleLoansCubit(
        addVehicleLoansUsecase: locator(),
        updateVehicleLoansUsecase: locator()));
    locator.registerFactory(() => MortageMainCubit(
        commonRefreshAgreegatorAccountUsecase: locator(),
        deleteMortageUsecase: locator(),
        getMortageUsecase: locator(),
        unlinkMortageUsecase: locator()));
    locator.registerFactory(() => AddMortgagesCubit(
        updateMortgagesUsecases: locator(), addMortgagesUsecases: locator()));
    locator.registerFactory(() => MainOtherLiabilitiesCubit(
        commonRefreshAgreegatorAccountUsecase: locator(),
        deleteOtherLiabilitiesUsecase: locator(),
        getOtherLiabilitiesUsecase: locator()));
    locator.registerFactory(() => AddOtherLiabilitiesCubit(
        addOtherLiabilitiesUsecase: locator(),
        updateOtherLiabilitiesUsecase: locator()));
    locator.registerFactory(() => AssetsLiabilitiesMainCubit(
        //assets main page from home page
        getAssets: locator(),
        getLiabilities: locator()));

    locator.registerFactory(() => AssetsAndLiabilitiesCubit(
          getAssetsLiabilities: locator(),
        ));

    locator.registerFactory(() => HomeBankAccountsCubit(
        //assets main page from home page
        getBankAccounts: locator()));

    locator.registerFactory(() => PensionInvestmentMainCubit(
        getMainPensionInvestmentsInsights: locator(),
        //assets main page from home page
        getMainPensionInvestments: locator()));
    locator
        .registerFactory(() => SupportAccountCubit(accountUsecase: locator()));
    locator.registerFactory(() => UserAccountCubit(
        getUserAccountUseCase: locator(), editUserAccountUseCase: locator()));
    locator.registerFactory(() => PushNotificationStateCubit());
    locator.registerFactory(
        () => CustomAssetDropDownCubit(getCustomAssetsDropDown: locator()));
    locator.registerFactory(() => SearchCryptoCubit(
        getCryptoCurrency: locator(), getCryptoData: locator()));
    locator.registerFactory(() => SearchStocksCubit(
        getStocksCurrency: locator(), getStocksData: locator()));

    locator.registerFactory(() => GetProvidersCubit(
          getProviders: locator(),
          getTopInstitute: locator(),
        ));
    locator.registerFactory(() => UserPreferencesCubit(
        editUserPreferencesUseCase: locator(),
        getUserPreferenceUseCase: locator()));

    locator.registerFactory(
        () => PensionNotesCubit(editPensionNoteUseCase: locator()));
    locator.registerFactory(
        () => InvestmentNotesCubit(editInvestmentNoteUseCase: locator()));

    locator.registerFactory(() => YodleeIntegrationCubit(
          getToken: locator(),
        ));
    locator.registerFactory(() => BankTransactionCubit(
        refreshAggregatorAccount: locator(),
        updateManualBalanceSheet: locator(),
        getManualBankTransaction: locator(),
        getYodleeBankTransaction: locator()));
    locator.registerFactory(() => YourInvestmentsCubit(
        commonRefreshAgreegatorAccountUsecase: locator(),
        getHoldings: locator(),
        deleteInvestments: locator()));
    locator.registerFactory(
        () => CreatePasswordCubit(createPasswordUsecase: locator()));
    locator.registerFactory(() => ChartToolTipCubit());
    locator.registerFactory(
        () => CalculatorInsightsCubit(getCalculatorInsights: locator()));

    locator.registerFactory(() => YourPensionsCubit(
          commonRefreshAggregatorAccountUseCase: locator(),
          getHoldings: locator(),
          deletePension: DeletePensionUsecase(locator()),
        ));

    locator.registerFactory(
      () => InviteFriendsCubit(
        getInviteFriendsDataUseCase: locator(),
      ),
    );
    locator.registerFactory(
      () =>
          DisconnectedAccountsCubit(getDisconnectedAccountsUseCase: locator()),
    );

    locator.registerFactory(
        () => YourPensionPerformanceCubit(getPensionPerformance: locator()));
    locator.registerFactory(
        () => PersonalDetailsCubit(personalDetailsUseCase: locator()));

    locator.registerFactory(
        () => LinePerformanceCubit(getLinePerformance: locator()));

    // locator.registerFactory(
    //     () => CreditCardPerformanceCubit(getCreditCardPerformance: locator()));
    locator.registerFactory(
        () => CreditCardTransactionCubit(getCreditCardTransaction: locator()));
    // locator.registerFactory(() => CreditCardTransactionDownloadCubit(
    //     getDownloadCreditCardTransaction: locator()));
    locator.registerFactory(() =>
        CreditCardPiePerformanceCubit(getCreditCardPiePerformance: locator()));

    locator.registerFactory(
        () => StocksPerformanceCubit(getStocksPerformance: locator()));
    locator.registerFactory(
        () => CryptoPerformanceCubit(getCryptoPerformance: locator()));

    locator.registerFactory(() =>
        YourInvestmentPerformanceCubit(getInvestmentPerformance: locator()));

    locator.registerFactory(
        () => DashboardCubit(getDashboardDataUseCase: locator()));
    locator.registerFactory(() => BeneficiaryMainCubit(
        getBeneficiaryDetailsUsecase: locator(),
        deleteBeneficiaryDetailsUsecase: locator()));
    locator.registerFactory(() => TrustedMainCubit(
        getTrustedDetailsUsecase: locator(),
        deleteTrustedDetailsUsecase: locator()));
    locator.registerFactory(() => BeneficiaryAddCubit(
        addBeneficiaryUsecase: locator(), editBeneficiaryUsecase: locator()));
    locator.registerFactory(() => TrustedAddCubit(
        addTrustedMemberScreen: locator(),
        editTrustedMemberUsecase: locator()));
    locator.registerFactory(
      () => DocumentCubit(
          deleteDocument: locator(),
          uploadDocument: locator(),
          getDocument: locator(),
          downloadDocument: locator()),
    );
    locator.registerFactory(
      () => ForgotpasswordCubit(locator()),
    );
    locator.registerFactory(
      () => GetservicesCubit(getPlugins: locator()),
    );
    locator.registerFactory(
      () => UseradvisorCubit(locator()),
    );

    locator.registerFactory(
      () => ServiceDocumentsCubit(locator(), locator()),
    );

    locator.registerFactory(
      () => PensionReportRecordsCubit(locator()),
    );
    locator.registerFactory(
      () =>
          OtpCubit(validateOTPUsecase: locator(), resendOTPusecase: locator()),
    );
    locator.registerFactory(
      () => AggregationResultCubit(locator()),
    );
    locator.registerFactory(
      () => AggregatorReconnectCubit(locator()),
    );
    locator.registerFactory(
      () => CreatePasscodeCubit(locator()),
    );
    locator.registerFactory(
      () => ConfirmPasscodeCubit(locator()),
    );
    locator.registerFactory(
      () => AskAuthCubit(),
    );
    locator.registerFactory(
      () => TermsAndConditionsCubit(locator()),
    );
    locator.registerFactory(
      () => GetTenantCubit(getTenantUseCase: locator()),
    );

    locator.registerFactory(
      () => ChangePasswordCubit(locator()),
    );
    locator.registerFactory(
      () => ChangePasscodeCubit(locator()),
    );
    locator.registerFactory(
      () => ThirdPartyCubit(locator()),
    );
    locator.registerFactory(
      () => CreditCardExcelDownloadCubit(locator()),
    );
    locator.registerFactory(
      () => CashAccountDownloadCubit(locator()),
    );
    locator.registerFactory(
      () => EnableBiometricSwitchCubit(),
    );
    locator.registerFactory(
        () => SignUpCubit(signUpUseCase: locator(), loginWithToken: locator()));
    locator.registerFactory(
        () => UploadDocumentCubit(uploadDocumentUseCase: locator()));
    locator.registerFactory(
        () => ValidateUserDetailsCubit(validateUserDetailsUseCase: locator()));
    locator.registerFactory(() => DocumentScreenCubit(
        getUploadedDocumentUsecase: locator(),
        downloadUploadedDocumentUsecase: locator()));
    locator.registerFactory(() =>
        UploadDocumentMainCubit(getUploadDocumentFoldersUsecase: locator()));
    locator
        .registerFactory(() => BannerNotificationCubit(locator(), locator()));
  }
}
