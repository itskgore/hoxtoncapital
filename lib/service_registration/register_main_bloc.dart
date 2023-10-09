import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/common/cubit/banner_notification_cubit.dart';
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
import 'package:wedge/features/calculators/opportunity_cost_calculator/presentation/bloc/cubit/oppurtunity_calculator_cubit.dart';
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
import 'package:wedge/features/user_services/uplead_documents/presentation/cubit/document_screen_cubit.dart';
import 'package:wedge/features/user_services/user_services_advisor/presentation/cubit/useradvisor_cubit.dart';
import 'package:wedge/features/user_services/user_services_main/presentation/cubit/getservices_cubit.dart';
import 'package:wedge/features/wealth_vault/documents/presentation/bloc/cubit/document_cubit.dart';
import 'package:wedge/features/your_investments/presentation/cubit/your_investments_cubit.dart';
import 'package:wedge/features/your_pensions/presentation/cubit/your_pensions_cubit.dart';

import '../core/common/line_performance_graph/presentation/cubit/line_peformance_cubit.dart';
import '../dependency_injection.dart';
import '../features/account/my_account/presentation/cubit/get_tenant_cubit.dart';
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
import '../features/user_services/uplead_documents/presentation/cubit/upload_document_cubit.dart';
import '../features/user_services/uplead_documents/presentation/cubit/upload_document_main_cubit.dart';
import '../features/your_investments/presentation/cubit/investment_notes_cubit.dart';
import '../features/your_investments/presentation/cubit/your_investment_peformance_cubit.dart';
import '../features/your_pensions/presentation/cubit/pension_notes_cubit.dart';
import '../features/your_pensions/presentation/cubit/your_pension_peformance_cubit.dart';

List<BlocProvider> providers = [
  BlocProvider<LoginCubit>(
    create: (BuildContext context) => locator<LoginCubit>(),
  ),
  BlocProvider<UserDataSummeryCubit>(
    create: (BuildContext context) => locator<UserDataSummeryCubit>(),
  ),
  BlocProvider<MainAssetsLiabilitiesCubit>(
    create: (BuildContext context) => locator<MainAssetsLiabilitiesCubit>(),
  ),
  BlocProvider<AllAssetsCubit>(
    create: (BuildContext context) => locator<AllAssetsCubit>(),
  ),
  BlocProvider<AddManualBankCubit>(
    create: (BuildContext context) => locator<AddManualBankCubit>(),
  ),
  BlocProvider<AddPersonalLoanCubit>(
    create: (BuildContext context) => locator<AddPersonalLoanCubit>(),
  ),
  BlocProvider<BankAccountsCubit>(
    create: (BuildContext context) => locator<BankAccountsCubit>(),
  ),
  BlocProvider<CashAccountPiePerformanceCubit>(
    create: (BuildContext context) => locator<CashAccountPiePerformanceCubit>(),
  ),
  BlocProvider<CashAccountBarPerformanceCubit>(
    create: (BuildContext context) => locator<CashAccountBarPerformanceCubit>(),
  ),
  BlocProvider<CashAccountTransactionCubit>(
    create: (BuildContext context) => locator<CashAccountTransactionCubit>(),
  ),
  BlocProvider<CustomAssetsCubit>(
    create: (BuildContext context) => locator<CustomAssetsCubit>(),
  ),
  BlocProvider<AddCustomAssetsCubit>(
    create: (BuildContext context) => locator<AddCustomAssetsCubit>(),
  ),
  BlocProvider<PropertiesCubit>(
    create: (BuildContext context) => locator<PropertiesCubit>(),
  ),
  BlocProvider<AddPropertyCubit>(
    create: (BuildContext context) => locator<AddPropertyCubit>(),
  ),
  BlocProvider<AddStocksCubit>(
    create: (BuildContext context) => locator<AddStocksCubit>(),
  ),
  BlocProvider<StocksCubit>(
    create: (BuildContext context) => locator<StocksCubit>(),
  ),
  BlocProvider<InvestmentsCubit>(
    create: (BuildContext context) => locator<InvestmentsCubit>(),
  ),
  BlocProvider<AddInvestmentCubit>(
    create: (BuildContext context) => locator<AddInvestmentCubit>(),
  ),
  BlocProvider<VehiclesCubit>(
    create: (BuildContext context) => locator<VehiclesCubit>(),
  ),
  BlocProvider<AddVehicleCubit>(
    create: (BuildContext context) => locator<AddVehicleCubit>(),
  ),
  BlocProvider<AddManualPensionCubit>(
    create: (BuildContext context) => locator<AddManualPensionCubit>(),
  ),
  BlocProvider<PensionMaincubitCubit>(
      create: (BuildContext context) => locator<PensionMaincubitCubit>()),
  BlocProvider<MainPersonalLoanCubit>(
    create: (BuildContext context) => locator<MainPersonalLoanCubit>(),
  ),
  BlocProvider<InviteFriendsCubit>(
    create: (BuildContext context) => locator<InviteFriendsCubit>(),
  ),
  BlocProvider<DisconnectedAccountsCubit>(
    create: (BuildContext context) => locator<DisconnectedAccountsCubit>(),
  ),

  BlocProvider<AddLiabilitiesPageCubit>(
    create: (BuildContext context) => locator<AddLiabilitiesPageCubit>(),
  ),
  BlocProvider<MainCryptoBlocCubit>(
    create: (BuildContext context) => locator<MainCryptoBlocCubit>(),
  ),
  BlocProvider<AddCryptoBlocCubit>(
    create: (BuildContext context) => locator<AddCryptoBlocCubit>(),
  ),
  BlocProvider<MainCreditCardCubit>(
    create: (BuildContext context) => locator<MainCreditCardCubit>(),
  ),
  BlocProvider<AddCreditCardCubit>(
    create: (BuildContext context) => locator<AddCreditCardCubit>(),
  ),
  BlocProvider<MainVehicleLoansCubit>(
    create: (BuildContext context) => locator<MainVehicleLoansCubit>(),
  ),
  BlocProvider<AddVehicleLoansCubit>(
    create: (BuildContext context) => locator<AddVehicleLoansCubit>(),
  ),
  BlocProvider<MortageMainCubit>(
    create: (BuildContext context) => locator<MortageMainCubit>(),
  ),
  BlocProvider<AddMortgagesCubit>(
    create: (BuildContext context) => locator<AddMortgagesCubit>(),
  ),
  BlocProvider<MainOtherLiabilitiesCubit>(
    create: (BuildContext context) => locator<MainOtherLiabilitiesCubit>(),
  ),
  BlocProvider<AddOtherLiabilitiesCubit>(
    create: (BuildContext context) => locator<AddOtherLiabilitiesCubit>(),
  ),
  BlocProvider<AssetsLiabilitiesMainCubit>(
    create: (context) => locator<AssetsLiabilitiesMainCubit>(),
  ),
  BlocProvider<AssetsAndLiabilitiesCubit>(
    create: (context) => locator<AssetsAndLiabilitiesCubit>(),
  ),
  BlocProvider<HomeBankAccountsCubit>(
    create: (context) => locator<HomeBankAccountsCubit>(),
  ),
  BlocProvider<PensionInvestmentMainCubit>(
    create: (context) => locator<PensionInvestmentMainCubit>(),
  ),
  BlocProvider<SupportAccountCubit>(
    create: (context) => locator<SupportAccountCubit>(),
  ),
  BlocProvider<UserAccountCubit>(
    create: (context) => locator<UserAccountCubit>(),
  ),
  BlocProvider<CustomAssetDropDownCubit>(
    create: (context) => locator<CustomAssetDropDownCubit>(),
  ),
  BlocProvider<SearchCryptoCubit>(
    create: (context) => locator<SearchCryptoCubit>(),
  ),
  BlocProvider<SearchStocksCubit>(
    create: (context) => locator<SearchStocksCubit>(),
  ),
  BlocProvider<GetProvidersCubit>(
    create: (context) => locator<GetProvidersCubit>(),
  ),
  BlocProvider<UserPreferencesCubit>(
    create: (context) => locator<UserPreferencesCubit>(),
  ),
  BlocProvider<PensionNotesCubit>(
    create: (context) => locator<PensionNotesCubit>(),
  ),
  BlocProvider<InvestmentNotesCubit>(
    create: (context) => locator<InvestmentNotesCubit>(),
  ),
  BlocProvider<YodleeIntegrationCubit>(
    create: (context) => locator<YodleeIntegrationCubit>(),
  ),
  BlocProvider<OppurtunityCalculatorCubit>(
    create: (context) => OppurtunityCalculatorCubit(),
  ),
  BlocProvider<BankTransactionCubit>(
    create: (context) => locator<BankTransactionCubit>(),
  ),
  BlocProvider<YourInvestmentsCubit>(
    create: (context) => locator<YourInvestmentsCubit>(),
  ),
  BlocProvider<CreatePasswordCubit>(
    create: (context) => locator<CreatePasswordCubit>(),
  ),
  BlocProvider<ChartToolTipCubit>(
    create: (context) => locator<ChartToolTipCubit>(),
  ),
  BlocProvider<CalculatorInsightsCubit>(
    create: (context) => locator<CalculatorInsightsCubit>(),
  ),
  BlocProvider<YourPensionsCubit>(
    create: (context) => locator<YourPensionsCubit>(),
  ),
  BlocProvider<YourPensionPerformanceCubit>(
    create: (context) => locator<YourPensionPerformanceCubit>(),
  ),
  BlocProvider<PersonalDetailsCubit>(
    create: (context) => locator<PersonalDetailsCubit>(),
  ),
  BlocProvider<LinePerformanceCubit>(
    create: (context) => locator<LinePerformanceCubit>(),
  ),
  // BlocProvider<CreditCardPerformanceCubit>(
  //   create: (context) => locator<CreditCardPerformanceCubit>(),
  // ),
  BlocProvider<CreditCardTransactionCubit>(
    create: (context) => locator<CreditCardTransactionCubit>(),
  ),
  // BlocProvider<CreditCardTransactionDownloadCubit>(
  //   create: (context) => locator<CreditCardTransactionDownloadCubit>(),
  // ),
  BlocProvider<CreditCardPiePerformanceCubit>(
    create: (context) => locator<CreditCardPiePerformanceCubit>(),
  ),
  BlocProvider<StocksPerformanceCubit>(
    create: (context) => locator<StocksPerformanceCubit>(),
  ),
  BlocProvider<CryptoPerformanceCubit>(
    create: (context) => locator<CryptoPerformanceCubit>(),
  ),
  BlocProvider<YourInvestmentPerformanceCubit>(
    create: (context) => locator<YourInvestmentPerformanceCubit>(),
  ),
  BlocProvider<DashboardCubit>(
    create: (context) => locator<DashboardCubit>(),
  ),
  BlocProvider<BeneficiaryMainCubit>(
    create: (context) => locator<BeneficiaryMainCubit>(),
  ),
  BlocProvider<TrustedAddCubit>(
    create: (context) => locator<TrustedAddCubit>(),
  ),
  BlocProvider<BeneficiaryAddCubit>(
    create: (context) => locator<BeneficiaryAddCubit>(),
  ),
  BlocProvider<TrustedMainCubit>(
    create: (context) => locator<TrustedMainCubit>(),
  ),
  BlocProvider<DocumentCubit>(
    create: (context) => locator<DocumentCubit>(),
  ),
  BlocProvider<ForgotpasswordCubit>(
    create: (context) => locator<ForgotpasswordCubit>(),
  ),
  BlocProvider<GetservicesCubit>(
    create: (context) => locator<GetservicesCubit>(),
  ),
  BlocProvider<UseradvisorCubit>(
    create: (context) => locator<UseradvisorCubit>(),
  ),
  BlocProvider<ServiceDocumentsCubit>(
    create: (context) => locator<ServiceDocumentsCubit>(),
  ),
  BlocProvider<PensionReportRecordsCubit>(
    create: (context) => locator<PensionReportRecordsCubit>(),
  ),
  BlocProvider<OtpCubit>(
    create: (context) => locator<OtpCubit>(),
  ),
  BlocProvider<AggregationResultCubit>(
    create: (context) => locator<AggregationResultCubit>(),
  ),
  BlocProvider<AggregatorReconnectCubit>(
    create: (context) => locator<AggregatorReconnectCubit>(),
  ),
  BlocProvider<CreatePasscodeCubit>(
    create: (context) => locator<CreatePasscodeCubit>(),
  ),
  BlocProvider<ConfirmPasscodeCubit>(
    create: (context) => locator<ConfirmPasscodeCubit>(),
  ),
  BlocProvider<AskAuthCubit>(
    create: (context) => locator<AskAuthCubit>(),
  ),
  BlocProvider<TermsAndConditionsCubit>(
    create: (context) => locator<TermsAndConditionsCubit>(),
  ),
  BlocProvider<GetTenantCubit>(
    create: (context) => locator<GetTenantCubit>(),
  ),
  BlocProvider<ChangePasswordCubit>(
    create: (context) => locator<ChangePasswordCubit>(),
  ),
  BlocProvider<ChangePasscodeCubit>(
    create: (context) => locator<ChangePasscodeCubit>(),
  ),
  BlocProvider<ThirdPartyCubit>(
    create: (context) => locator<ThirdPartyCubit>(),
  ),
  BlocProvider<CreditCardExcelDownloadCubit>(
    create: (context) => locator<CreditCardExcelDownloadCubit>(),
  ),
  BlocProvider<CashAccountDownloadCubit>(
    create: (context) => locator<CashAccountDownloadCubit>(),
  ),
  BlocProvider<EnableBiometricSwitchCubit>(
    create: (context) => locator<EnableBiometricSwitchCubit>(),
  ),
  BlocProvider<SignUpCubit>(
    create: (context) => locator<SignUpCubit>(),
  ),
  BlocProvider<UploadDocumentCubit>(
    create: (context) => locator<UploadDocumentCubit>(),
  ),
  BlocProvider<ValidateUserDetailsCubit>(
    create: (context) => locator<ValidateUserDetailsCubit>(),
  ),
  BlocProvider<DocumentScreenCubit>(
      create: (context) => locator<DocumentScreenCubit>()),
  BlocProvider<UploadDocumentMainCubit>(
      create: (context) => locator<UploadDocumentMainCubit>()),
  BlocProvider<GetAccountDataCubit>(
      create: (context) => locator<GetAccountDataCubit>()),
  BlocProvider<BannerNotificationCubit>(
      create: (context) => locator<BannerNotificationCubit>()),
];
