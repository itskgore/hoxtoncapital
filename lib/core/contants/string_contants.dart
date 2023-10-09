import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

const String DEFAULT_COUNTRY_CODE = "44";
const String DEFAULT_CURRENCY = "GBP";

//login
const String HOXTON_USER_LOGIN = "Hoxton Capital User Login";
const String HOXTON_USERNAME = "Hoxton Username";
const String PASSWORD = "Password";
const String FORGOT_PASSWORD = "Forgot Password?";
const String LOGIN = "Login";

//home
const String ASSETS = "Assets";
const String LIABILITIES = "Liabilities";
const String ASSETS_AND_LIABILITIES = "Assets & Liabilities";
const String WEALTH_VAULT = "Wealth Vault";
const String FINANCIAL_TOOLS = "Financial Tools";
const String THE_SAFE_PLACE_TO_KEEP_YOUR_DATA =
    "The safe place to keep your data";
const String NETWORTH = "Networth";
const String ASSET_PERFORMANCE = "Asset Performance";
const String MORE = "More";
const String MONTH = "Month";
const String WEEK = "Week";
const String YEAR = "Year";

// add bank account
const String ADD_BANK_ACCOUNT_TITLE =
    "Great! Let’s start by adding your bank accounts.";
const String SEARCH_YOUR_BANK = "Search your bank";
const String OR_SELECT_FROM_THE_BANK = "Or select from the banks below";
const String IT_JUST_TAKE_A_MINUTE = "It just takes a minute";
const String ADD_YOUR_FINANCIALDATA_MESSAGE =
    "Remember, the more accurate the data you add is, the better financial insights you'll get.";
const String ADD_BANK_ACCOUNT = "Add Bank Account";
const String SKIP_ANYWAY = "Skip Anyway";
const String SKIP = "Skip";
const String ADD_LATER = "Add Later";

// ADD ASSETS/liab
const String LETS_ADD_ASSETS = "Let's Add Assets";
const String LETS_ADD_LIABILITIES = "Let's Add Liabilities";
const String ADD_INCOME_SOURCE = "Add Income Sources";
const String BANK_ACCOUNTS = "Bank Accounts";
const String PROPERTIES = "Properties";
const String VEHICLES = "Vehicles";
const String STOCKS_BONDS = "Stocks/Bonds";
const String CRYPTO = "Crypto";
const String PENSIONS = "Pensions";
const String INVESTMENT_ACCOUNTS = "Investment Account";
const String E_WALLETS = "eWallets";
const String SUCCESS = "Success";
const String PERSONAL_LOANS = "Personal loans";
const String CREDIT_CARD = "Credit Cards";
const String MORTGAGE = "Mortgages";
const String VEHICLE_LOANS = "Vehicle loans";
const String OTHER_LIABILITIES = "Custom liabilities";
const String ADD_PERSONAL_LOAN = "Add Personal Loan";
const String ADD_A_CREDIT_CARD_DEBT = "Add a Credit Card Debt";
const String ADD_MORTGAGE = "Add Mortgage";
const String ADD_VEHICLE_LOAN = "Add Vehicle loan";
const String ADD_OTHER_LIABILITIES = "Add Other Liabilities";
const String ADD_MORE = "Add More";
const String ADD_MORE_LIABILITIES = "Add More Liabilities";

String addAssetsSuccessMessage(String type) {
  return "Great you have successfully added your $type details. You can add more by clicking on the plus sign above.";
}

const String ADD_PROPERTY = "Add Property";
const String ADD_STOCKS = "Add Stocks/Bonds";
const String ADD_VEHICLE = "Add Vehicle";
const String ADD_CRYPTO = "Add Crypto";
const String ADD_PENSION = "Add Pension";
const String ADD_INVESTMENT_ACCOUNT = "Add Investment Account";
const String ADD_E_WALLET = "Add eWallet";
const String ADD_PRIMARY_INCOME = "Add Primary Income";
const String ADD_RENTAL_INCOME = "Add Rental Income";
const String ADD_OTHER_INCOME = "Add Other Income";

const String NAME = "Name";
const String VALUE = "Value";
const String RENTAL_HOME = "Rental Home";
const String MONTHLY_RENTAL_INCOME = "Monthly Rental Income";
const String SAVE = "Save";
const String NUMBER_OF_STOCKS = "Number of stocks";
const String VEHICLE_NAME = "Vehicle Name";
const String PROVIDER_NAME = "Provider Name";
const String POLICY_NUMBER = "Policy number";
const String INITIAL_VALUE = "Initial Value";
const String CURRENT_VALUE = "Current Value";
const String GENERAL_TRANSECTION_AMOUNT = "General transaction amount";
const String GROWTH = "Growth";
const String QUANTITY = "Quantity";

const String MORTGAGE_PROVIDER = "Mortgage Provider";
const String OUTSDANDING = "Outstanding";
const String TERM_REMAINING = "Term remaining";
const String MONTHLY_PAYMENT = "Monthly payment";
const String MONTHLY_INCOME = "Monthly Income";
const String FL_NAME = "FI Name";
const String CAR_MODEL = "Car make/model";
const String INTEREST_RATE = "Interest rate";
const String CREDIT_LIMIT = "Credit Limit";

const String PRIMARY_INCOME = "Primary Income";
const String RENTAL_INCOME = "Rental income";
const String OTHER = "Other";
const String EMPLOYER_NAME_BUSINESS_DESCRIPTION =
    "Employer Name / Business Description";

// support Email
const String supportEmail = "clientportal-support@hoxtoncapital.com";

// Number Format const
final numberFormat = NumberFormat('#,###,###.##'); //0,000,000.00
final numberFormat1 = NumberFormat('#,###,##0.00'); //0,000,000.00
final numberFormat2 = NumberFormat('#,###,###.#'); //0,000,000.0

// Date formater
final DateFormat dateFormatter = DateFormat('dd MMM yy');
final DateFormat dateFormatter1 = DateFormat('DD MMM yy');
final DateFormat dateFormatter2 = DateFormat('dd-MMMM-yyyy');
final DateFormat dateFormatter6 = DateFormat('dd-MM-yyyy');
final DateFormat dateFormatter5 = DateFormat('yyyy-MM-dd');
final DateFormat dateFormatter3 = DateFormat('yyyy-MM');
final DateFormat dateFormatter4 = DateFormat('MMMM-yyyy');
final DateFormat dateFormatter7 = DateFormat('dd MMM yy hh:mm a');
final DateFormat dateFormatter8 = DateFormat('dd-MMM-yy');
final DateFormat dateFormatter9 = DateFormat('dd-MMM');
final DateFormat dateFormatter10 = DateFormat('MMM yy');
final DateFormat dateFormatter11 = DateFormat('dd');
final DateFormat dateFormatter12 = DateFormat('dd MMMM yyyy');
final DateFormat dateFormatter13 = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
final DateFormat dateFormatter14 = DateFormat('MMM yyyy');
final DateFormat dateFormatter15 = DateFormat('dd/MM/yyyy');

//Formatted

String getFormattedDate2(String date) {
  if (date.isEmpty) {
    return "Nil";
  }
  return dateFormatter6.format(DateTime.parse("${date} 00:00:00"));
}

String addAssetsTitleMessage(String type) {
  return "Please add your $type details. Remember, the more accurate data you add, the more better financial insights you’ll get.";
}

AppLocalizations? translateStrings(context) {
  return AppLocalizations.of(context);
}
