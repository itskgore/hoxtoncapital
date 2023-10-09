// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:wedge/core/contants/string_contants.dart';
// import 'package:wedge/core/contants/theme_contants.dart';
// import 'package:wedge/core/utils/wedge_country_picker.dart';
// import 'package:wedge/core/utils/wedge_currency_picker.dart';
// import 'package:wedge/core/widgets/bottom_nav_single_button_container.dart';
// import 'package:wedge/core/widgets/custom_dialog.dart';
// import 'package:wedge/dependency_injection.dart';
// import 'package:wedge/features/assets/add_assets_success_screen.dart';
// import 'package:country_currency_pickers/country_pickers.dart';
// import 'package:country_currency_pickers/country.dart';
// import 'package:wedge/features/assets/properties/add_mortgage/presentation/pages/add_mortgage_page.dart';
// import 'package:wedge/features/assets/properties/add_properties/presentation/widgets/mortgages_widget.dart';
// // import 'package:wedge/features/assets/properties/properties_main/presentation/pages/properties_main_page.dart';
// import 'package:wedge/features/assets/vehicle/add_loan/presentation/pages/add_loan_page.dart';
// import 'package:wedge/features/assets/vehicle/add_vehicle/presentation/widgets/vehicle_loan_widget.dart';

// class AddVehiclePage extends StatefulWidget {
//   // AddVehiclePage({Key key}) : super(key: key);

//   @override
//   _AddVehiclePageState createState() => _AddVehiclePageState();
// }

// class _AddVehiclePageState extends State<AddVehiclePage> {
//   //define country and currency pickers
//   Country _selectedDialogCurrency =
//       CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);
//   Country _selectedDialogCountry =
//       CountryPickerUtils.getCountryByPhoneCode(DEFAULT_COUNTRY_CODE);

//   bool _generateRentalIncome = false;
//   List _loan = [];

//   @override
//   void initState() {
//     super.initState();

//     //assign default country and currency
//     _selectedDialogCurrency =
//         CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);
//     _selectedDialogCountry =
//         CountryPickerUtils.getCountryByPhoneCode(DEFAULT_COUNTRY_CODE);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: kBackgroundColor,
//         appBar: AppBar(
//           backgroundColor: kBackgroundColor,
//           iconTheme: IconThemeData(
//             color: appThemeColors!.primary, //change your color here
//           ),
//           elevation: 0.0,
//           title: Text(
//             ADD_VEHICLE,
//             style: TextStyle(color: kfontColorDark),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ListView(
//             children: [
//               TextField(
//                 decoration: InputDecoration(
//                   fillColor: Colors.white,
//                   filled: true,
//                   border: ktextFeildOutlineInputBorder,
//                   hintText: "Vehicle Name",
//                 ),
//               ),
//               SizedBox(
//                 height: ktextBoxGap,
//               ),
//               GestureDetector(
//                 onTap: () {
//                   WedgeCountryPicker(
//                       context: context,
//                       countryPicked: (Country country) {
//                         setState(() {
//                           _selectedDialogCountry = country;
//                         });
//                       });
//                 },
//                 child: Container(
//                   child: Center(
//                       child: Row(
//                     // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       SizedBox(
//                         width: 10,
//                       ),
//                       CountryPickerUtils.getDefaultFlagImage(
//                           _selectedDialogCountry),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Text(_selectedDialogCountry.name.toString()),
//                     ],
//                   )),
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: ktextfeildBorderRadius,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: ktextBoxGap,
//               ),
//               TextField(
//                 decoration: InputDecoration(
//                     fillColor: Colors.white,
//                     filled: true,
//                     border: ktextFeildOutlineInputBorder,
//                     hintText: VALUE,
//                     suffixStyle: TextStyle(color: Colors.black),
//                     suffix: GestureDetector(
//                         onTap: () async {
//                           WedgeCurrencyPicker(
//                               context: context,
//                               countryPicked: (Country country) {
//                                 setState(() {
//                                   _selectedDialogCurrency = country;
//                                 });
//                               });
//                         },
//                         child: Container(
//                           width: 60,
//                           child: Row(
//                             children: [
//                               Text(
//                                 _selectedDialogCurrency.currencyCode.toString(),
//                                 style: TextStyle(color: kfontColorDark),
//                               ),
//                               Icon(Icons.arrow_drop_down)
//                             ],
//                           ),
//                         ))),
//               ),
//               SizedBox(
//                 height: ktextBoxGap,
//               ),
//               SizedBox(
//                 height: ktextBoxGap,
//               ),
//             ],
//           ),
//         ),
//         bottomNavigationBar: BottomNavSingleButtonContainer(
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(primary: appThemeColors!.primary),
//             onPressed: () {
//               // locator.get<WedgeDialog>().success(
//               //     context: context,
//               //     title: "Your vehicle details have been added successfully.",
//               //     info: "",
//               //     onClicked: () {
//               //       Navigator.pop(context);
//               //       Navigator.push(
//               //           context,
//               //           CupertinoPageRoute(
//               //               builder: (BuildContext context) =>
//               //                   VehiclesMainPage()
//               //               // AddBankAccountPage()
//               //               ));
//               //     });

//               Navigator.pop(context);
//             },
//             child: Text(
//               SAVE,
//               style: TextStyle(fontSize: kfontMedium, color: Colors.white),
//             ),
//           ),
//         ));
//   }
// }
