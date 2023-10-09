// import 'package:flutter/material.dart';
// import 'package:wedge/core/widgets/wedge_expension_tile.dart';
//
// //TODO: @Shahabz Need to know why everything Static
// class VehicleLoanWidget extends StatelessWidget {
//   final loan;
//   const VehicleLoanWidget({this.loan});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         shrinkWrap: true,
//         physics: const ScrollPhysics(),
//         itemCount: loan.length,
//         itemBuilder: (context, index) {
//           return WedgeExpansionTile(
//             index: index,
//             leftSubtitle: 'GBR',
//             leftTitle: 'Provider Name',
//             midWidget: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: const [
//                       Text("Loan"),
//                       SizedBox(
//                         height: 8.0,
//                       ),
//                       Text("Interest rate"),
//                       SizedBox(
//                         height: 8.0,
//                       ),
//                       Text("Maturity date"),
//                       SizedBox(
//                         height: 8.0,
//                       ),
//                       Text("Monthly Payments"),
//                       SizedBox(
//                         height: 8.0,
//                       ),
//                       Text("Vehicle"),
//                     ],
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: const [
//                       Text("Yes"),
//                       SizedBox(
//                         height: 8.0,
//                       ),
//                       Text("2%"),
//                       SizedBox(
//                         height: 8.0,
//                       ),
//                       Text("14 Months"),
//                       SizedBox(
//                         height: 8.0,
//                       ),
//                       Text("1500 per month"),
//                       SizedBox(
//                         height: 8.0,
//                       ),
//                       Text("Vehic"),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             onDeletePressed: () {},
//             onEditPressed: () {},
//             rightTitle: 'GBR 69,000',
//             rightSubTitle: '',
//           );
//         });
//   }
// }
