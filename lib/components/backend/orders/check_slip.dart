// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:tdvp/models/order_model.dart';
// import 'package:tdvp/models/products_model.dart';
// import 'package:tdvp/utility/config_button.dart';
// import 'package:tdvp/utility/config_progress.dart';

// class CheckSlip extends StatefulWidget {
//   final String docIdOrder;

//   const CheckSlip({
//     Key? key,
//     required this.docIdOrder,
//   }) : super(key: key);

//   @override
//   State<CheckSlip> createState() => _CheckSlipState();
// }

// class _CheckSlipState extends State<CheckSlip> {
//   String? docIdOrder;
//   SlipModel? slipModel;

//   @override
//   void initState() {
//     super.initState();
//     docIdOrder = widget.docIdOrder;
//     readSlip();
//   }

//   Future<void> readSlip() async {
//     await FirebaseFirestore.instance
//         .collection('orders')
//         .doc(docIdOrder)
//         .collection('slip')
//         .get()
//         .then((value) {
//       for (var element in value.docs) {
//         slipModel = SlipModel.fromMap(element.data());
//       }
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: slipModel == null
//           ? const ConfigProgress()
//           : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Image.network(slipModel!.urlSlip),
//                   ConfigButton(
//                     label: 'ตัดยอด',
//                     pressFunc: () {
//                       processCutStock();
//                     },
//                   )
//                 ],
//               ),
//             ),
//     );
//   }

//   Future<void> processCutStock() async {
//     await FirebaseFirestore.instance
//         .collection('orders')
//         .doc(docIdOrder)
//         .get()
//         .then((value) async {
//       OrderModel orderModel = OrderModel.fromMap(value.data()!);
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(orderModel.uidSeller)
//           .collection('products')
//           .doc(orderModel.docIdProducts[0])
//           .get()
//           .then((value) async {
//         ProductModel productModel = ProductModel.fromMap(value.data()!);
//         int oldStock = productModel.quantity;

//         int orderStock = int.parse(orderModel.amountProducts[0]);

//         print('oldStock ==> $oldStock, orderStock ==> $orderStock');

//         Map<String, dynamic> map = productModel.toMap();
//         map['stock'] = oldStock - orderStock;

//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(orderModel.uidSeller)
//             .collection('product')
//             .doc(orderModel.docIdProducts[0])
//             .update(map)
//             .then((value) async {
//           Map<String, dynamic> map2 = productModel.toMap();
//           map2['status'] = 'delivery';

//           await FirebaseFirestore.instance
//               .collection('order')
//               .doc(docIdOrder)
//               .update(map2)
//               .then((value) {
//             Navigator.pop(context);
//           });
//         });
//       });
//     });
//   }
// }
