// // ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dio/dio.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:tdvp/components/backend/orders/check_slip.dart';
// import 'package:tdvp/models/order_model.dart';
// import 'package:tdvp/models/users_model.dart';
// import 'package:tdvp/utility/config_icon_button.dart';
// import 'package:tdvp/utility/config_progress.dart';
// import 'package:tdvp/utility/config_text.dart';
// import 'package:tdvp/utility/config_title.dart';
// import 'package:tdvp/utility/dailog.dart';
// import 'package:tdvp/utility/style.dart';

// class OrderSeller extends StatefulWidget {
//   final String docIdUser;
//   const OrderSeller({
//     Key? key,
//     required this.docIdUser,
//   }) : super(key: key);

//   @override
//   State<OrderSeller> createState() => _OrderSellerState();
// }

// class _OrderSellerState extends State<OrderSeller> {
//   bool load = true;
//   bool? haveOrder;
//   var orderModels = <OrderModel>[];
//   var userModels = <UserModel>[];
//   List<List<Widget>> listWidget = [];
//   var docIdOrders = <String>[];
//   int totalsum = 0;

//   final statuss = StyleProjects.misstatus;

//   @override
//   void initState() {
//     super.initState();
//     readMyOrder();
//   }

//   Future<void> readMyOrder() async {
//     orderModels.clear();
//     docIdOrders.clear();
//     userModels.clear();
//     listWidget.clear();

//     var user = FirebaseAuth.instance.currentUser;
//     String uid = user!.uid;
//     print('## uid ==> $uid');

//     await FirebaseFirestore.instance
//         .collection('order')
//         .where('uidSeller', isEqualTo: uid)
//         .get()
//         .then((value) async {
//       load = false;
//       if (value.docs.isEmpty) {
//         haveOrder = false;
//       } else {
//         haveOrder = true;

//         for (var item in value.docs) {
//           OrderModel model = OrderModel.fromMap(item.data());
//           orderModels.add(model);
//           docIdOrders.add(item.id);

//           var widgets = <Widget>[];
//           widgets.add(
//             Column(
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: ConfigText(lable: 'สินค้า'),
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: ConfigText(lable: 'ราคา'),
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: ConfigText(lable: 'จำนวน'),
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: ConfigText(lable: 'รวม'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//           for (var i = 0; i < model.docIdProducts.length; i++) {
//             //totalsum = totalsum + int.parse(model.sumProducts[i]);
//             // print('totalsum ==> ${totalsum}');
//             widgets.add(
//               Column(
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child: ConfigText(lable: model.productname[i]),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: ConfigText(lable: model.priceProducts[i]),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: ConfigText(lable: model.amountProducts[i]),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: ConfigText(lable: model.sumProducts[i]),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           }
//           listWidget.add(widgets);

//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(model.uidcustomer)
//               .get()
//               .then((value) {
//             UserModel userModle = UserModel.fromMap(value.data()!);
//             userModels.add(userModle);
//           });
//         }
//       }
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return load
//         ? const ConfigProgress()
//         : haveOrder!
//             ? newContent()
//             : Center(
//                 child: ConfigText(
//                 lable: 'ไม่มีรายการ สั่งซื้อ',
//                 textStyle: StyleProjects().topicstyle9,
//               ));
//   }

//   Widget newContent() => ListView(
//         children: [
//           const ConfigTitle(title: 'รายการสั่งซื้อ'),
//           ListView.builder(
//             shrinkWrap: true,
//             physics: const ScrollPhysics(),
//             itemCount: orderModels.length,
//             itemBuilder: (context, index) => ExpansionTile(
//               children: listWidget[index],
//               title: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       ConfigTitle(title: 'ผู้ซื้อ:${userModels[index].fname}'),
//                       ConfigText(lable: statusThai(index)),
//                       orderModels[index].status == 'order'
//                           ? ConfigIconButton(
//                               iconData: Icons.edit_outlined,
//                               pressFunc: () {
//                                 // print('you  click ==> $index');

//                                 Map<String, dynamic> map = {};
//                                 StyleDialog(context: context).actionDialog(
//                                   cancleButton: true,
//                                   title: 'เลือกสถานะใหม่',
//                                   message:
//                                       'กรุณาเลือก แจ้งชำระสินค้า หรือ ยกเลิกคำสั่งซื้อ',
//                                   label1: 'แจ้งชำระสินค้า',
//                                   label2: 'ยกเลิกคำสั่งซื้อ',
//                                   presFunc1: () {
//                                     map['status'] = statuss[1];
//                                     Navigator.pop(context);
//                                     processChangeStatus(
//                                         docIdOrder: docIdOrders[index],
//                                         map: map,
//                                         docIdBuyer:
//                                             orderModels[index].uidcustomer);
//                                   },
//                                   presFunc2: () {
//                                     map['status'] = statuss[5];
//                                     Navigator.pop(context);
//                                     processChangeStatus(
//                                         docIdOrder: docIdOrders[index],
//                                         map: map,
//                                         docIdBuyer:
//                                             orderModels[index].uidcustomer);
//                                   },
//                                 );
//                               },
//                             )
//                           : orderModels[index].status == statuss[1]
//                               ? ConfigIconButton(
//                                   iconData: Icons.money,
//                                   pressFunc: () {
//                                     StyleDialog(context: context).normalDialog(
//                                         title: 'สถาณะ Payment',
//                                         message: 'รอให้ ลูกค้าชำระสินค้าก่อน');
//                                   })
//                               : orderModels[index].status == statuss[2]
//                                   ? ConfigIconButton(
//                                       iconData: Icons.attach_money_outlined,
//                                       pressFunc: () async {
//                                         StyleDialog(context: context)
//                                             .actionDialog(
//                                                 title: 'ตรวจสอบสลิป',
//                                                 message:
//                                                     'ตรวจสอบยอดเงินจาก สลิป',
//                                                 label1: 'ตัดยอด',
//                                                 label2: 'รอไว้ก่อน',
//                                                 presFunc1: () {
//                                                   Navigator.pop(context);
//                                                   Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) =>
//                                                             CheckSlip(
//                                                                 docIdOrder:
//                                                                     docIdOrders[
//                                                                         index]),
//                                                       )).then((value) {
//                                                     readMyOrder();
//                                                   });
//                                                 },
//                                                 presFunc2: () {
//                                                   Navigator.pop(context);
//                                                 });
//                                       })
//                                   : orderModels[index].status == statuss[3]
//                                       ? ConfigIconButton(
//                                           iconData: Icons.train_sharp,
//                                           pressFunc: () {
//                                             StyleDialog(context: context)
//                                                 .normalDialog(
//                                                     title: 'Delivery',
//                                                     message:
//                                                         'อยู่ระหว่างการจัดส่งสินค้า');
//                                           })
//                                       : orderModels[index].status == statuss[4]
//                                           ? ConfigIconButton(
//                                               iconData: Icons.face_outlined,
//                                               pressFunc: () {})
//                                           : orderModels[index].status ==
//                                                   statuss[5]
//                                               ? ConfigIconButton(
//                                                   iconData: Icons.cancel,
//                                                   pressFunc: () {
//                                                     StyleDialog(
//                                                             context: context)
//                                                         .normalDialog(
//                                                             title:
//                                                                 'ยกเลิกสินค้า',
//                                                             message:
//                                                                 'สินค้านี่ยกเลิกไปแล้ว');
//                                                   })
//                                               : const SizedBox(),
//                     ],
//                   ),
//                   // Row(
//                   //   children: [
//                   //     ConfigTitle(title: 'โทร:'),
//                   //     ConfigText(lable: userModels[index].phone),
//                   //   ],
//                   // ),
//                   Row(
//                     children: [
//                       ConfigTitle(title: 'สถานที่จัดส่ง'),
//                       ConfigText(lable: orderModels[index].logistics),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );

//   String statusThai(int index) {
//     String thaista = 'สั่งสินค้า';
//     if (orderModels[index].status == 'order') {
//       thaista = 'สั่งสินค้า';
//     } else if (orderModels[index].status == 'payment') {
//       thaista = 'ชำระเงิน';
//     } else if (orderModels[index].status == 'paymented') {
//       thaista = 'จ่ายเงินแล้ว';
//     } else if (orderModels[index].status == 'delivery') {
//       thaista = 'ส่งของ';
//     } else if (orderModels[index].status == 'finish') {
//       thaista = 'รับของแล้ว';
//     } else {
//       thaista = 'ยกเลิก';
//     }

//     return thaista;
//   }

//   Future<void> processChangeStatus(
//       {required String docIdOrder,
//       required Map<String, dynamic> map,
//       required String docIdBuyer}) async {
//     await FirebaseFirestore.instance
//         .collection('order')
//         .doc(docIdOrder)
//         .update(map)
//         .then((value) async {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(docIdBuyer)
//           .get()
//           .then((value) async {
//         UserModel modle = UserModel.fromMap(value.data()!);
//         String token = modle.token;
//         String title = 'รายการสั่งสินค้า ${map['status']}';
//         String body = 'ขอบคุณครับ';

//         String path =
//             'https://www.androidthai.in.th/bigc/noti/apiNotilardgreen.php?isAdd=true&token=$token&title=$title&body=$body';

//         await Dio().get(path).then((value) {
//           readMyOrder();
//         });
//       });
//     });
//   }
// }
