// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:wedge/core/contants/string_contants.dart';
// import 'package:wedge/core/contants/theme_contants.dart';
// import 'package:wedge/core/utils/wedge_country_picker.dart';
// import 'package:wedge/core/utils/wedge_currency_picker.dart';
// import 'package:wedge/core/widgets/bottom_nav_single_button_container.dart';
// import 'package:wedge/features/assets/add_assets_success_screen.dart';
// import 'package:country_currency_pickers/country_pickers.dart';
// import 'package:country_currency_pickers/country.dart';

// class AddVehicleLoanPage extends StatefulWidget {
//   // AddVehicleLoanPage({Key key}) : super(key: key);

//   @override
//   _AddVehicleLoanPageState createState() => _AddVehicleLoanPageState();
// }

// class _AddVehicleLoanPageState extends State<AddVehicleLoanPage> {
//   //define country and currency pickers
//   Country _selectedDialogCurrency =
//       CountryPickerUtils.getCountryByCurrencyCode(DEFAULT_CURRENCY);
//   Country _selectedDialogCountry =
//       CountryPickerUtils.getCountryByPhoneCode(DEFAULT_COUNTRY_CODE);

//   bool _generateRentalIncome = false;

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
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.pop(context, false);
//             },
//           ),
//           backgroundColor: kBackgroundColor,
//           iconTheme: IconThemeData(
//             color: appThemeColors!.primary, //change your color here
//           ),
//           elevation: 0.0,
//           title: Text(
//             "Add Loan",
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
//                   hintText: "Loan Provider list/Create new",
//                 ),
//               ),
//               SizedBox(
//                 height: ktextBoxGap,
//               ),
//               TextField(
//                 decoration: InputDecoration(
//                   fillColor: Colors.white,
//                   filled: true,
//                   border: ktextFeildOutlineInputBorder,
//                   hintText: "Loan Provider Name",
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
//                     hintText: "Outstanding",
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
//               TextField(
//                 decoration: InputDecoration(
//                   fillColor: Colors.white,
//                   filled: true,
//                   border: ktextFeildOutlineInputBorder,
//                   hintText: "Interest rate",
//                 ),
//               ),
//               SizedBox(
//                 height: ktextBoxGap,
//               ),
//               TextField(
//                 decoration: InputDecoration(
//                   fillColor: Colors.white,
//                   filled: true,
//                   border: ktextFeildOutlineInputBorder,
//                   hintText: "Term remaining",
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
//                     hintText: "Monthly payment",
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
//                 height: 10,
//               ),
//             ],
//           ),
//         ),
//         bottomNavigationBar: BottomNavSingleButtonContainer(
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(primary: appThemeColors!.primary),
//             onPressed: () {
//               Navigator.pop(context, true);
//             },
//             child: Text(
//               SAVE,
//               style: TextStyle(fontSize: kfontMedium, color: Colors.white),
//             ),
//           ),
//         ));
//   }
// }
